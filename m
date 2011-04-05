From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix subvolume mount by name problem when default mount subvolume is set
Date: Tue, 05 Apr 2011 01:07:29 -0400
Message-ID: <1301979914-sup-1391@think>
References: <1301558362-2650-1-git-send-email-xin.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1301558362-2650-1-git-send-email-xin.zhong@intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Zhong, Xin's message of 2011-03-31 03:59:22 -0400:
> We create two subvolumes (meego_root and meego_home) in
> btrfs root directory. And set meego_root as default mount
> subvolume. After we remount btrfs, meego_root is mounted
> to top directory by default. Then when we try to mount
> meego_home (subvol=meego_home) to a subdirectory, it failed.
> The problem is when default mount subvolume is set to
> meego_root, we search meego_home in it but can not find it.
> So the solution is to search meego_home in btrfs root
> directory instead when subvol=meego_home is given.

I think this one is difficult because if they have set the default
subvolume they might have done so because the original default has the
result of a busted upgrade or something in it.

So, I think the subvol= should be relative to the default.  Would it
work for you to add a new mount option to specify the subvol id to
search for subvol=?

-chris
