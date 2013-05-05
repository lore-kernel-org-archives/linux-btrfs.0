Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob05.myregisteredsite.com ([209.17.115.43]:45315 "EHLO
	atl4mhob05.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496Ab3EEOPq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 May 2013 10:15:46 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob05.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r45EFiTi012920
	for <linux-btrfs@vger.kernel.org>; Sun, 5 May 2013 10:15:44 -0400
Message-ID: <51866994.8010107@chinilu.com>
Date: Sun, 05 May 2013 07:15:48 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Scrub CPU usage ...
References: <518555FF.4020704@chinilu.com> <2221106.SQ983GtkxQ@merkaba>
In-Reply-To: <2221106.SQ983GtkxQ@merkaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 05/05/2013 02:22 AM, Martin Steigerwald wrote:
> Hi George!
>
> Am Samstag, 4. Mai 2013, 11:39:59 schrieb George Mitchell:
>> the next update.  I am using btrfs raid 1 across five 500GB Seagate
>> nearline drives and btrfs single on a Seagate 4TB backup drive.  I am
>> absolutely delighted with how this system is working.  This is my
>> primary day in and day out system.  I have to date hard crashed this
>> system at least three times without sustaining any apparent damage to
>> the filesystems.  Perhaps I have just been extremely lucky, but it seems
>> like most of the major holes have been closed at this point.  Actually I
>> have only two significant issues currently with btrfs.
> Are you aware that BTRFS RAID-1 works differently than block based RAID? BTRFS
> will only be holding two copies of every data or metadata chunk on two
> different drives, regardless how many drives you use. So only one drive may
> fail.
>
> Well, I think you will have notices with df output for the filesystem, but I
> thought I mention it, just in case.
>
> Thanks,
Yes indeed!  I was aware of this from the beginning.  All I am looking 
for is duplication across hardware.  The advantage of more than two 
drives is that in case you lose a drive, you don't end up losing a lot 
of space, and you are much less likely to end up in an unduplicated 
state for a significant amount of time.  But thanks for your thoughts!  
What I am NOT missing about the old 3ware card is the resyncs.  I used 
to spend half a day doing drive resyncs when a drive dropped out for 
some reason.  Hardware RAID is great when it works, but I much prefer 
btrfs.  Software RAID has its own problems.  Its gotten better I hear, 
but when I used it for a long time, I was a pain.  But both forms of 
block RAID saved me from ever losing data.  - George
