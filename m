From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs csum failed
Date: Wed, 04 May 2011 08:39:10 -0400
Message-ID: <1304512672-sup-1948@think>
References: <4DC07A10.7070200@mur.at>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Martin Schitter <ms@mur.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DC07A10.7070200@mur.at>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Martin Schitter's message of 2011-05-03 17:56:32 -0400:
> since my last debian kernel-update to 2.6.38-2-amd64 i got troubles with 
> csum failures. it's a volume full of huge kvm-images on md-RAID1 and 
> LVM, so i used the mount options: 'noatime,nodatasum' to maximize the 
> performance.
> 
> it happened two weeks ago for the fist time. and now again a kvm-image 
> isn't readable again. i have to use an older snapshot to substitute the 
> virtual machine.
> 
> this are the entries in dmesg/kernel-log on any access:
> ...
>   [2412668.409442] btrfs csum failed ino 258 off 2331529216 csum 
> 3632892464 private 2115348581
> ...
> 
> it's a production machine, so i can not make to much experiments on it.
> do you see an obvious way to solve this problem?

What OS is inside these virtual machines?  The btrfs unstable tree has
some fixes for windows based OSes.

Is your kvm config using O_DIRECT?

I've also got patches here that force us to honor nodatasum even when
the file has csums, that can help if the contents of the file are
actually good.

-chris
