From: dima <dolenin@parallels.com>
Subject: Re: Snapshot rollback
Date: Mon, 24 Oct 2011 05:45:06 +0000 (UTC)
Message-ID: <loom.20111024T071806-3@post.gmane.org>
References: <4EA46E3A.9090307@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Phillip Susi <psusi <at> cfl.rr.com> writes:

> I created a snapshot of my root subvol, then used btrfs-subvolume
> set-default to make the snapshot the default subvol and rebooted.  This
> seems to have correctly gotten the system to boot from the snapshot
> instead of the original subvol, but now /home ( @home subvol ) refuses
> to mount claiming that /dev/sda1 is not a valid block device.  What gives?


Hello Phillip,
It is hard to judge without seeing your fstab and bootloader config. Maybe your
/ was directly in subvolid=0 without creating a separate subvolume for it (like
__active in Goffredo's reply)? In my very humble opinion, if you have your @home
subvolume under subvolid=0 and then change the default subvolume, it just cannot
access your @home any more.

Personally I do not store anything in subvolid=0 directly and never bothered
with 'set-default' option - just used a new subvolume/snapshot name
- create a named snapshot
- edit bootloader config to include the new
rootflags=subvol=<your_new_snapshot_name>
- reboot

Here is a very good article that explains the working of subvolumes. I used it
as reference a lot.
http://www.funtoo.org/wiki/BTRFS_Fun#Using_snapshots_for_system_recovery_.28aka_Back_to_the_Future.29

~dima

