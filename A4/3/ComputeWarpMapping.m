function [ A ] = ComputeWarpMapping( points1, points2 )
    A = points1 \ points2;
end

