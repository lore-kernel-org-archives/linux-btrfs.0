From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: rootfs snapshots and rollback (i.e. testing updates)
Date: Tue, 10 Nov 2009 10:53:46 +0100
Message-ID: <4AF9382A.60804@wpkg.org>
References: <4AF82E78.1010200@wpkg.org> <m3639jk610.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3639jk610.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Ball wrote:
> Hi,
> 
>    > Is it possible, with current btrfs:
> 
> Yes, I think so.
> 
>    > - to take a rootfs snapshot (i.e. prior to a major update),
> 
> btrfsctl -s newsnap /
> 
>    > - do changes in the root filesystem (i.e. install major update),
>    > 
>    > - if we don't like what the major update did to the system
>    > (rootfs), "rollback" the snapshot and make it the "original"
>    > rootfs again (perhaps, with a reboot in between).
> 
> Before rebooting, edit whatever mounts your root partition (initrd,
> fstab, kernel argument) to add a "subvol=newsnap" mount argument.

So, if I understand it correctly, it's not really "rolling back".

Rather, with a "failed upgrade", we would mount a "newsnap" snapshot to 
use the old rootfs again.


What's still left here would be:

- remove the "failed upgrade" "(sub)volume" (which is "/" now?)

- turn everything to such a state, so that you can mount the 
old/original rootfs without adding any "subvol=newsnap" mount arguments


Correct me if I'm wrong.


-- 
Tomasz Chmielewski
http://wpkg.org
