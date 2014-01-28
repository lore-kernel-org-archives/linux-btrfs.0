Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18184 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaA1IyC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 03:54:02 -0500
Message-ID: <52E77272.9090003@oracle.com>
Date: Tue, 28 Jan 2014 17:03:46 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Alin Dobre <alin.dobre@elastichosts.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Monitoring for disk failures
References: <52E64665.5020109@elastichosts.com>
In-Reply-To: <52E64665.5020109@elastichosts.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Alin,

[bug] its messy when missing device reappears after its been replaced in 
RAID1

  I am aware of it and working on it. I also reported a more
  critical bug earlier as below.

  [bug] its messy when missing device reappears after its been replaced 
in RAID1


  We see IO errors when disk goes missing. But NO as of now
  a mounted FS will never report a missing disk unless you
  unmount and mount (not remount) then kernel will realize
  the missing disk

  Note that don;t be happy about
     btrfs fi show -d <all-devices>
  reporting missing disk (when fs is mounted), since its
  not inline with kernel. Here with -d option btrfs-progs
  is adding its 'own' intelligence to show disk as missing
  (what is not what end user want, end user would want to
  know how btrfs kernel is managing the missing disk and
  they want to do it by using btrfs-progs. At many places
  btrfs-progs is way to intelligent than what actually
  needed. That's wrong).

  More to come.

Thanks, Anand



On 01/27/2014 07:43 PM, Alin Dobre wrote:
> Hi all!
>
> I am trying to create a very simple script that would alert in case of
> disk failures from a RAID Btrfs.
>
> Digging into the code, I have noticed that the "btrfs fi sh" command
> should display a warning if there is a missing disk. However, testing in
> a Qemu, I used "drive_del" via QMP to remove a "live" SCSI drive,
> already mounted as part of a RAID10 array, the "fi sh" command still
> gave no indication that the drive is missing. Then, I tried removing a
> scsi disk from the host via "echo 1 >/sys/block/sdX/device/delete" to
> actually make the kernel SCSI host forget about it, and "fi sh" still
> doesn't show anything.
>
> I have tested using btrfs-progs v3.12 and kernel 3.13.0.
>
> Do you guys know what's wrong with the setup explained above or do you
> have any indication on how to detect if there is a failing disk, part of
> a Btrfs RAID?
>
> Cheers,
> Alin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
