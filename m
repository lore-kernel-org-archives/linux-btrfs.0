Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48086 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaJPO4r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 10:56:47 -0400
Message-ID: <543FDCA5.9060908@oracle.com>
Date: Thu, 16 Oct 2014 22:56:37 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 1/1] btrfs-progs: introduce a proper structure on which
 cli will call register-device ioctl
References: <1413333974-25579-1-git-send-email-anand.jain@oracle.com> <20141016100841.GZ22943@twin.jikos.cz> <20141016102035.GA22943@twin.jikos.cz>
In-Reply-To: <20141016102035.GA22943@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/16/14 18:20, David Sterba wrote:
> On Thu, Oct 16, 2014 at 12:08:41PM +0200, David Sterba wrote:
>>      @@ -22,18 +22,21 @@
>>       <NUMDEVS> [SCRATCH_DEV].read_io_errs    <NUM>
>>       <NUMDEVS> [SCRATCH_DEV].write_io_errs   <NUM>
>>       == Show device stats by first/scratch dev
>>      +ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on �oh failed: No such device
>>       [SCRATCH_DEV].corruption_errs <NUM>
>>       [SCRATCH_DEV].flush_io_errs   <NUM>
>>       [SCRATCH_DEV].generation_errs <NUM>
>
> Additional info:
>
> syslog:
>
> [ 1332.330541] run xfstest btrfs/006
> [ 1333.251419] BTRFS: device fsid 02ad1ce3-85e4-41c0-8d54-138a8d950b3d devid 1 transid 3 /dev/sda9
> [ 1333.273512] BTRFS: device fsid 02ad1ce3-85e4-41c0-8d54-138a8d950b3d devid 2 transid 3 /dev/sda10
> [ 1333.345285] BTRFS: device fsid 02ad1ce3-85e4-41c0-8d54-138a8d950b3d devid 3 transid 3 /dev/sda11
> [ 1333.366160] BTRFS: device fsid 02ad1ce3-85e4-41c0-8d54-138a8d950b3d devid 4 transid 3 /dev/sda12
> [ 1334.468250] BTRFS info (device sda12): disk space caching is enabled
> [ 1334.476280] BTRFS: flagging fs with big metadata feature
> [ 1334.491801] BTRFS: creating UUID tree
> [ 1334.774684] BTRFS warning (device sda12): get dev_stats failed, device not found
> [ 1334.805125] BTRFS warning (device sda12): get dev_stats failed, device not found
> [ 1334.832683] BTRFS warning (device sda12): get dev_stats failed, device not found
>
> $ btrfs fi show
>
> Label: 'TestLabel.006'  uuid: 02ad1ce3-85e4-41c0-8d54-138a8d950b3d
>          Total devices 4 FS bytes used 192.00KiB
>          devid    1 size 10.00GiB used 20.00MiB path /dev/sda9
>          devid    2 size 10.00GiB used 256.00MiB path /dev/sda10
>          devid    3 size 10.00GiB used 0.00B path /dev/sda11
>          devid    4 size 10.00GiB used 0.00B path /dev/sda12
>
> SCRATCH_DEV_POOL=/dev/sda9 /dev/sda10 /dev/sda11 /dev/sda12


Quite strange. I didn't see that problem here.
----
btrfs/006 12s ... 13s
Ran: btrfs/006
Passed all 1 tests
---

  Can you retain the scratch mounted and check what is the output of
  'btrfs fi show -m' (when the SCRATCH is mounted).

  OR /proc/fs/btrfs/devlist (in case if you have that) would help
  to debug this.

  OR could you restart test with a wipe all disk ?

Thanks, Anand



