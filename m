Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:10058 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaGVPad (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 11:30:33 -0400
Message-ID: <53CE8394.9010903@giantdisaster.de>
Date: Tue, 22 Jul 2014 17:30:28 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: TM <tmjuju@yahoo.com>, linux-btrfs@vger.kernel.org
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
References: <loom.20140720T102642-239@post.gmane.org> <53CC6B39.1060705@cn.fujitsu.com> <loom.20140721T155907-291@post.gmane.org> <53CDBBC7.6000609@cn.fujitsu.com> <loom.20140722T164042-111@post.gmane.org>
In-Reply-To: <loom.20140722T164042-111@post.gmane.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Jul 2014 14:43:45 +0000 (UTC), Tm wrote:
> Wang Shilong <wangsl.fnst <at> cn.fujitsu.com> writes:
> 
> 
>> The latest btrfs-progs include man page of btrfs-replace. Actually, you 
>> could use it
>> something like:
>>
>> btrfs replace start  <srcdev>|<devid> <targetdev> <mnt>
>>
>> You could use 'btrfs file show' to see missing device id. and then run 
>> btrfs replace.
>>
> 
> Hi Wang,
> 
>   I physically removed the drive before the rebuild, having a failing device
> as a source is not a good idea anyway.
>   Without the device in place, the device name is not showing up, since the
> missing device is not under /dev/sdXX or anything else. 
> 
>   That is why I asked if the special parameter 'missing' may be used in a
> replace. I can't say if it is supported. But I guess not, since I found no
> documentation on this matter.
> 
>   So I guess replace is not aimed at fault tolerance / rebuilding. It's just
> a convenient way to lets lay replace the disks with larger disks , to extend
> your array. A convenience tool, not an emergency tool.

TM, Just read the man-page. You could have used the replace tool after
physically removing the failing device.

Quoting the man page:
"If the source device is not available anymore, or if the -r option is
set, the data is built only using the RAID redundancy mechanisms.

Options
-r   only read from <srcdev> if no other zero-defect mirror
     exists (enable this if your drive has lots of read errors,
     the access would be very slow)"


Concerning the rebuild performance, the access to the disk is linear for
both reading and writing, I measured above 75 MByte/s at that time with
regular 7200 RPM disks, which would be less than 10 hours to replace a
3TB disk (in worst case, if it is completely filled up).
Unused/unallocated areas are skipped and additionally improve the
rebuild speed.

For missing disks, unfortunately the command invocation is not using the
term "missing" but the numerical device-id instead of the device name.
"missing" _is_ implemented in the kernel part of the replace code, but
was simply forgotten in the user mode part, at least it was forgotten in
the man page.


