Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32260 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbbDMPjN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 11:39:13 -0400
Message-ID: <552BDB7A.8030906@oracle.com>
Date: Mon, 13 Apr 2015 23:06:34 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: ERROR: error removing the device '/dev/sdXN' - Inappropriate
 ioctl for device
References: <mfcdep$d97$1@ger.gmane.org> <20150331173756.GF6821@twin.jikos.cz> <mfeo14$sib$1@ger.gmane.org> <551B98FF.8070000@oracle.com> <mfgiot$3ck$1@ger.gmane.org> <551BEF67.3040305@oracle.com> <mfh9rn$2if$1@ger.gmane.org> <55228ADB.3000404@oracle.com> <mg0fp1$ep4$1@ger.gmane.org>
In-Reply-To: <mg0fp1$ep4$1@ger.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks Martin for helping with the data.

Unfortunately no matter what I try I couldn't reproduce the
"Inappropriate ioctl for device"

But I got INVALD which is wrong as well. So I sent a patch for
that. EIO is appropriate in this case.


Next, Passing a devid to delete a device - yes it would help
patch is ready in my WS BUT - just noticed that error handling
code nicely put the FS into readonly when there is commit
failure so that's something which should be fixed along with
this patch which I am attempting. Since as in your case with
3 disks raid1, your reconstructed radi1 will still be considered
as healthy after taking out a disk.

Further, to recover from your situation you could try replace,
that will work. OR if you are not planning to add another disk then,
try this: (sorry needs a down time)

umount
remove failed disk from the system
mount -o degrade
btrfs dev del missing <mnt>
mount -o remount
(I hope you would check / mange the space availably part)


(By the way, those missing messages are user land fabricated,
  btrfs-progs: 206efb60cbe3049e0d44c6da3c1909aeee18f813

so don't depend on that, to know what kernel knows
probably you need /proc/fs/btrfs/devlist or sysfs
posted in the ML before,

btrfs fi show -m

was written so to know actual kernel visibility but
it was again crippled by above commit id.

David, should back out 206efb60cbe3049e0d44c6da3c1909aeee18f813
as mentioned before it will help.


On 04/07/2015 07:41 PM, Martin wrote:
> On 06/04/15 14:32, Anand Jain wrote:
>> btrfs fi show -d
>
>
> That gives:
>
> # btrfs fi show -d
> warning, device 3 is missing
> warning devid 3 not found already
> warning, device 3 is missing
> warning devid 3 not found already

David,

  As commented before - you shouldn't have integrated the patch

   915902c5002485fb13d27c4b699a73fb66cc0f09


Thanks,  Anand




> Label: 'btrfs_root'  uuid: 92452e9a-2775-45c4-922c-f01b2afd51c2
>          Total devices 3 FS bytes used 30.94GiB
>          devid    1 size 24.00GiB used 24.00GiB path /dev/sda4
>          devid    2 size 24.00GiB used 24.00GiB path /dev/sdc4
>          devid    3 size 24.00GiB used 24.00GiB path /dev/sde4
>
> Label: 'btrfs_data'  uuid: d1b96638-be89-4291-8a40-f2f2e1dc5223
>          Total devices 3 FS bytes used 95.74GiB
>          devid    1 size 87.24GiB used 86.48GiB path /dev/sda5
>          devid    2 size 87.24GiB used 87.24GiB path /dev/sdc5
>          devid    3 size 87.24GiB used 87.24GiB path /dev/sde5
>
> Label: 'btrfs_root2'  uuid: 62603ce8-c333-4ca7-92f7-f8bdd712ab37
>          Total devices 3 FS bytes used 151.60MiB
>          devid    1 size 24.00GiB used 24.00GiB path /dev/sdb4
>          devid    2 size 24.00GiB used 24.00GiB path /dev/sdd4
>          *** Some devices missing
>
> Label: 'btrfs_data2'  uuid: 3aaee716-b98b-4c86-ba5a-53456994f152
>          Total devices 3 FS bytes used 159.34GiB
>          devid    1 size 206.47GiB used 206.02GiB path /dev/sdb5
>          devid    2 size 206.47GiB used 206.47GiB path /dev/sdd5
>          *** Some devices missing
>
> btrfs-progs v3.19.1
>
>
> And without the "-d":
>
> # btrfs fi show
> Label: 'btrfs_root'  uuid: 92452e9a-2775-45c4-922c-f01b2afd51c2
>          Total devices 3 FS bytes used 30.94GiB
>          devid    1 size 24.00GiB used 24.00GiB path /dev/sda4
>          devid    2 size 24.00GiB used 24.00GiB path /dev/sdc4
>          devid    3 size 24.00GiB used 24.00GiB path /dev/sde4
>
> Label: 'btrfs_data'  uuid: d1b96638-be89-4291-8a40-f2f2e1dc5223
>          Total devices 3 FS bytes used 95.74GiB
>          devid    1 size 87.24GiB used 86.48GiB path /dev/sda5
>          devid    2 size 87.24GiB used 87.24GiB path /dev/sdc5
>          devid    3 size 87.24GiB used 87.24GiB path /dev/sde5
>
> Label: 'btrfs_root2'  uuid: 62603ce8-c333-4ca7-92f7-f8bdd712ab37
>          Total devices 3 FS bytes used 151.60MiB
>          devid    1 size 24.00GiB used 24.00GiB path /dev/sdb4
>          devid    2 size 24.00GiB used 24.00GiB path /dev/sdd4
>          devid    3 size 24.00GiB used 24.00GiB path /dev/sdf4
>
> Label: 'btrfs_data2'  uuid: 3aaee716-b98b-4c86-ba5a-53456994f152
>          Total devices 3 FS bytes used 159.34GiB
>          devid    1 size 206.47GiB used 206.02GiB path /dev/sdb5
>          devid    2 size 206.47GiB used 206.47GiB path /dev/sdd5
>          devid    3 size 206.47GiB used 206.47GiB path /dev/sdf5
>
> btrfs-progs v3.19.1
>
>
> Interestingly, all the log messages about /dev/sdf are now no longer
> being repeated.
>
> (And nope, not had a chance to swap that disk yet!)
>
>
> Hence, should I do a "btrfs device delete missing /mnt/data2"?
>
> Cheers,
> Martin
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
