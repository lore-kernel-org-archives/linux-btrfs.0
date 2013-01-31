Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:45444 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab3AaTSU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 14:18:20 -0500
Received: by mail-we0-f173.google.com with SMTP id r5so2345027wey.18
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 11:18:18 -0800 (PST)
Message-ID: <510AC367.2070605@statystyka.net>
Date: Thu, 31 Jan 2013 20:17:59 +0100
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Chris Murphy <lists@colorremedies.com>
Subject: Re: Poor performance of btrfs. Suspected unidentified btrfs housekeeping
 process which writes a lot
References: <510934E6.7080302@statystyka.net> <6F302998-3D6E-4E91-9DDA-C475344B51BF@colorremedies.com> <5109C2A8.7090005@statystyka.net> <150353F1-2795-4FDD-A1F4-8F544813E7A0@colorremedies.com> <510A4DF5.8020308@statystyka.net> <D0563603-0770-4058-9A40-030FE1A127B7@colorremedies.com>
In-Reply-To: <D0563603-0770-4058-9A40-030FE1A127B7@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-01-31 20:08, Chris Murphy wrote:
> On Jan 31, 2013, at 2:45 AM, Adam Ryczkowski <adam.ryczkowski@statystyka.net> wrote:
>> Yes, you are right. It is important contributing factor, why relatime mount option killed my performance so badly.
> So is this what was causing the problem?
Yes.
>> Can you tell me more? Because I have only learned, that btrfs multi-device support cannot join two volumes without striping. And striping in this case is equivalent to fragmentation, which we want to avoid. In contrast to what LVM can do. LVM can concatenate the underlying storage together, without striping.
> When you create a btrfs file system, by default the data profile is single, and metadata profile is dup. When you add another device to the volume, it stays this way. The single data profile behaves similar to LVM linear, except btrfs will alternate chunk allocations between devices, so that one isn't just sitting there spinning for a month and not being used at all.
>
> So it's not striping. But even if it were striping, that would help you on write performance in particular because now it's effectively RAID 60. I don't see why striping is considered fragmentation.
Well, if the devices are on the same physical hard-drive, than 
sequential file reading would cause hard drive heads to seek between the 
first and the other partition on every extent. This is something 
equivalent to defragmentation; it is only good if the partitions are on 
separate hard drives.
> To change the profile for the volume, you use -dconvert and/or -mconvert with a rebalance operation.
Once again, thank you very much, Chris.
-- 

Adam Ryczkowski
+48505919892 <callto:+48505919892>
Skype:sisteczko 
<skype:sisteczko><https://www.google.com/calendar/b/0/embed?src=adam.ryczkowski@statystyka.net&ctz&gsessionid=OK>

