From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: crash when mounting subvolume in a subdirectory
Date: Tue, 07 Dec 2010 09:40:23 +0800
Message-ID: <4CFD9087.5000503@cn.fujitsu.com>
References: <20101206232724.4bf1ebfc@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Michael Niederle <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101206232724.4bf1ebfc@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

Michael Niederle wrote:
> Hi!
> 
> I'm not sure whether this *should* be possible, but I think it *shouldn't*
> crash:
> 
> I created a snapshot of the root directory within a subdirectory:
> 
> # mount /dev/sde2 /mnt
> # cd /mnt
> # mkdir save
> # btrfs subvolume snapshot . save/snap1
> # umount /mnt
> 
> Then I tried to mount the snapshot:
> 
> # mount -o subvol=save/snap1 /dev/sde2 /mnt
> 
> This inevitably leads to a segfault in the btrfs-driver crashing the whole
> system. I tried this with kernel versions 2.6.32 and 2.6.37.rc4.
> 
> If I create the subvolume within the root directory of the btrfs volume
> everything works fine.
> 
> I'm using btrfs for nearly a year by now (since the release of 2.6.32) and am
> using subvolumes within subdirectories since then but never tried to directly
> mount one until today, when my main btrfs volume crashed (by a hardware failure
> or due to a bug in 2.6.36 - I don't know).
> 
> If you cannot reproduce this behaviour I can try to send you the kernel log
> (not so easy, because the system crashes and I will have to write it down by
> hand).

It's currently not allowed to mount a subvolume which is not created in
the root directory of the default subvolume, so you should have failed
to mount, but you hit a bug..

I've fixed it, and will send out the patch in minutes.
