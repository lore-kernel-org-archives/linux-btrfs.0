From: Evert Vorster <evorster@gmail.com>
Subject: Re: btrfsck: checksum verify failed
Date: Sun, 8 Aug 2010 22:32:10 -0500
Message-ID: <AANLkTimJYgd2P0OK5nqQ=_MdC8yR6_BuiRw_GWewsY-p@mail.gmail.com>
References: <AANLkTikncVbqe7BJp+PAT3eCzLVgEWo-OzbmADHyARvB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikncVbqe7BJp+PAT3eCzLVgEWo-OzbmADHyARvB@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Is anyone interested in some part of this filesystem to figure out how
it failed?

Or can I erase and start again?

Kind regards,
-Evert Vorster-

On Sun, Aug 8, 2010 at 8:18 AM, Evert Vorster <evorster@gmail.com> wrote:
> Hi there.
>
> I have a btrfs on a raw device. (/dev/sda insted of in a partition, like
> /dev/sda1 )
> The device in question is a USB hard drive with a 1TB size.
>
> The device worked fine for a week or so, and was mounted and unmounted quite
> a few times without trouble.
>
> The last time the device was unmounted it was a normal unmount.
>
> Now, when I try to mount the device, I get the following in dmesg:
>
> usb 2-1: new high speed USB device using ehci_hcd and address 4
> scsi6 : usb-storage 2-1:1.0
> scsi 6:0:0:0: Direct-Access     Seagate  FreeAgent GoFlex 0148 PQ: 0 ANSI: 4
> sd 6:0:0:0: Attached scsi generic sg2 type 0
> sd 6:0:0:0: [sdb] 1953525167 512-byte logical blocks: (1.00 TB/931 GiB)
> sd 6:0:0:0: [sdb] Write Protect is off
> sd 6:0:0:0: [sdb] Mode Sense: 1c 00 00 00
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>  sdb: unknown partition table
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> sd 6:0:0:0: [sdb] Attached SCSI disk
> device label TeraByte1 devid 1 transid 5352 /dev/sdb
> parent transid verify failed on 986800398336 wanted 5352 found 5355
> parent transid verify failed on 986800398336 wanted 5352 found 5355
> parent transid verify failed on 986800398336 wanted 5352 found 5355
> btrfs: open_ctree failed
>
>
> Also, if I try to fsck the device, this is the output:
>
> bin@dora:~# btrfsck /dev/sdb
> parent transid verify failed on 986800398336 wanted 5352 found 5355
> parent transid verify failed on 986800398336 wanted 5352 found 5355
> parent transid verify failed on 986800398336 wanted 5352 found 5355
> btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)'
> failed.
> Aborted
>
>
> I am using v 0.19 of the btrfs-tools, and kernel version 2.6.34.1
>
> While a little sad that I can't get at my data anymore, I do have backups of
> it. I also want to use the device again, but want to stop anybody else
> running into the same problem. So, if you have any requests like maybe a dd
> of some small part of the filesystem to study and see what went wrong, and
> maybe how to fix it, I would be happy to oblige. However, If I hear nothing
> for a day or so, I'll wipe the filesystem and use the device again.
>
> Kind regards,
> -Evert Vorster-
>



-- 
http://magnatune.com - Music shared the way it should be.
