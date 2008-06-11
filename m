From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: FileSystem level compression support.
Date: Wed, 11 Jun 2008 12:13:41 +0100
Message-ID: <f058a9c30806110413y39102d33t98cd685f289beb2d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

Providing compression and/or encryption at the file system layer has
proven to be contentious and polemic, at least in the linux kernel
world.

However, I would like to probe you guys (specially Chis Mason) about
your thoughts on the issue.
I have seen quite a few benchs were compression provides better
performance, since it reduces the amount of IO.
It seems to be a cpu/io trade-off. And given that cpu power is more
easily accessible than fast IO.. it is starting to look a good idea
that should be more deeply explored.

Is compression for data on BTRFS a feature that is:
- completely out of the table - it will not happen at the BTRFS layer
- considered, but no efforts on developing this feature are planed.
- considered, and design decisions are contemplating it.. but no code
yet.. not this soon. (not for 1.0)


Kind regards!

-- 
Miguel Sousa Filipe
