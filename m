Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kingswood-consulting.co.uk ([88.97.16.53]:36295 "EHLO
	andromeda.kingswood-consulting.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755168AbaBULmK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 06:42:10 -0500
Message-ID: <53073B8B.7050206@kingswood-consulting.co.uk>
Date: Fri, 21 Feb 2014 11:42:03 +0000
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS partitioning scheme (was BTRFS with RAID1 cannot boot when
 removing drive)
References: <CAJbEPe6COMz0Dmj9rSOjb0wCVu-e0OR_2d8irKxgSA3N4sBB+g@mail.gmail.com> <E588F10F-919E-405C-8120-7375A2A6885B@colorremedies.com> <CAJbEPe4FFBemxf289aRn8M2DKH6sZYVi=fpST8Jp-fd6_ot0mQ@mail.gmail.com> <52FC8769.9030405@kingswood-consulting.co.uk> <298ECBDF-898C-4C2E-8004-BBCFEB677969@colorremedies.com> <52FD08A2.3080205@gmail.com>
In-Reply-To: <52FD08A2.3080205@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13/02/14 18:02, Austin S Hemmelgarn wrote:
> On 2014-02-13 12:33, Chris Murphy wrote:
>>
>> On Feb 13, 2014, at 1:50 AM, Frank Kingswood <frank@kingswood-consulting.co.uk> wrote:
>>
>>> On 12/02/14 17:13, Saint Germain wrote:
>>>> Ok based on your advices, here is what I have done so far to use UEFI
>>>> (remeber that the objective is to have a clean and simple BTRFS RAID1
>>>> install).
>>>>
>>>> A) I start first with only one drive, I have gone with the following
>>>> partition scheme (Debian wheezy, kernel 3.12, grub 2.00, GPT partition
>>>> with parted):
>>>> sda1 = 1MiB BIOS Boot partition (no FS, "set 1 bios_grub on" with
>>>> parted to set the type)
>>>> sda2 = 550 MiB EFI System Partition (FAT32, "toggle 2 boot" with
>>>> parted to set the type),  mounted on /boot/efi
>>>
>>> I'm curious, why so big? There's only one file of about 100kb there, and I was considering shrinking mine to the minimum possible (which seems to be about 33 MB).
>>
>> I'm not sure what OS loader you're using but I haven't seen a grubx64.efi less than ~500KB. In general I'm seeing it at about 1MB. The Fedora grub-efi and shim packages as installed on the ESP take up 10MB. So 33MiB is a bit small, and if we were more conservative, we'd update the OS loader by writing the new one to a temp directory rather than overwriting existing. And then remove the old, and rename the new.
>>
>> The UEFI spec says if the system partition is FAT, it should be FAT32. For removable media it's FAT12/FAT16. I don't know what tool the various distro installers are using, but at least on Fedora they are using mkdosfs, part of dosfstools. And its cutoff for making FAT16/FAT32 based on media size is 500MB unless otherwise specified, and the installer doesn't specify so actually by default Fedora system partitions are FAT16, to no obvious ill effect. But if you want a FAT32 ESP created by the installer the ESP needs to be 500MiB or 525MB. So 550MB is a reasonable number to make that happen.

For the record, this works for me on a Dell laptop:

I have resized my EFI partition to 40 MB, reformatted it with
    mkfs.vfat -F 32 -n EFI /dev/sda1
and copied back the grubx64.efi file.

Note that mkvs.vfat gives "WARNING: Not enough clusters for a 32 bit 
FAT!" unless the file system is more than 32 MiB.

Because the GUID in the GPT partition table is modified by the 
repartitioning the BIOS must be updated to point to this file. That can 
be done with efibootmgr, or in my case it is also possible in the BIOS 
setup.

Frank


