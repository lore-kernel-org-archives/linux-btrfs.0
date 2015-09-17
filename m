Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49754 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbbIQPSt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 11:18:49 -0400
Message-ID: <55FAD9CC.5060206@oracle.com>
Date: Thu, 17 Sep 2015 23:18:36 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: "erpo41@gmail.com" <erpo41@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: RAID1 storage server won't boot with one disk missing
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
In-Reply-To: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for the report.

  There is a bug that raid1 with one disk missing and trying to mount 
for the 2nd time.. it would fail. I am not too sure if in the boot 
process would there be mount and then remount/mount again ? If yes then 
it is potentially hitting the problem as in the patch below.

   Btrfs: allow -o rw,degraded for single group profile

  you may want to give this patch a try.

  more below..

On 09/17/2015 07:56 AM, erpo41@gmail.com wrote:
> Good afternoon,
>
> Earlier today, I tried to set up a storage server using btrfs but ran
> into some problems. The goal was to use two disks (4.0TB each) in a
> raid1 configuration.
>
> What I did:
> 1. Attached a single disk to a regular PC configured to boot with UEFI.
> 2. Booted from a thumb drive that had been made from an Ubuntu 14.04
> Server x64 installation DVD.
> 3. Ran the installation procedure. When it came time to partition the
> disk, I chose the guided partitioning option. The partitioning scheme
> it suggested was:
>
> * A 500MB EFI System Partition.
> * An ext4 root partition of nearly 4 TB in size.
> * A 4GB swap partition.
>
> 4. Changed the type of the middle partition from ext4 to btrfs, but
> left everything else the same.
> 5. Finalized the partitioning scheme, allowing changes to be written to disk.
> 6. Continued the installation procedure until it finished. I was able
> to boot into a working server from the single disk.
> 7. Attached the second disk.
> 8. Used parted to create a GPT label on the second disk and a btrfs
> partition that was the same size as the btrfs partition on the first
> disk.
>
> # parted /dev/sdb
> (parted) mklabel gpt
> (parted) mkpart primary btrfs #####s ##########s
> (parted) quit
>
> 9. Ran "btrfs device add /dev/sdb1 /" to add the second device to the
> filesystem.
> 10. Ran "btrfs balance start -dconvert=raid1 -mconvert=raid1 /" and
> waited for it to finish. It reported that it finished successfully.
> 11. Rebooted the system. At this point, everything appeared to be working.
> 12. Shut down the system, temporarily disconnected the second disk
> (/dev/sdb) from the motherboard, and powered it back up.
>
> What I expected to happen:
> I expected that the system would either start as if nothing were
> wrong, or would warn me that one half of the mirror was missing and
> ask if I really wanted to start the system with the root array in a
> degraded state.

  as of now it would/should start normally only when there is an entry 
-o degraded

  it looks like -o degraded is going to be a very obvious feature,
  I have plans of making it a default feature, and provide -o
  nodegraded feature instead. Thanks for comments if any.

Thanks, Anand


> What actually happened:
> During the boot process, a kernel message appeared indicating that the
> "system array" could not be found for the root filesystem (as
> identified by a UUID). It then dumped me to an initramfs prompt.
> Powering down the system, reattaching the second disk, and powering it
> on allowed me to boot successfully. Running "btrfs fi df /" showed
> that all System data was stored as RAID1.
>
> If I want to have a storage server where one of two drives can fail at
> any time without causing much down time, am I on the right track? If
> so, what should I try next to get the behavior I'm looking for?
>
> Thanks,
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
