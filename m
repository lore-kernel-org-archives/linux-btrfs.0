Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36171 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbbGKKNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jul 2015 06:13:00 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: "erpo41@gmail.com" <erpo41@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Defrag operations sometimes don't work.
Date: Sat, 11 Jul 2015 12:12:58 +0200
Message-ID: <3753681.2HYhjf7Zfa@merkaba>
In-Reply-To: <CAPQXdDRKpp43M+by8wMGiMZa9VPD5XKs8CGpNLT=J41Q96E1Ug@mail.gmail.com>
References: <CAPQXdDRKpp43M+by8wMGiMZa9VPD5XKs8CGpNLT=J41Q96E1Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 10. Juli 2015, 19:12:34 schrieb erpo41@gmail.com:
> Good afternoon,

Hi Eric,

> First, my apologies if this is a repeat email. My original email
> contained an uncompressed copy of dmesg's output and I *believe*
> that pushed the message over the 100KB limit, causing the list to
> drop it.
> 
> When I try to defragment files (or recursively defragment trees of
> files) on my btrfs filesystem, I get inconsistent results. In the
> following example, I had a 16MB file with 3143 extents. Running btrfs
> fi defrag /path/to/file once did nothing. Immediately running the
> defrag command a second time reduced the file to 2 extents.

Always do "sync" after a "btrfs fi defrag" and before measuring with 
"filefrag". The kernel may not have written everything. I have seen this 
repeatedly that the extent count drops further after a "sync", following 
"btrfs fi defrag".

Or wait longer before you measure.
 
> Other times a file may never defragment, regardless of how many times I
> run the defrag command or which values I pass to the -t option (0, 1,
> 10m, 100m, 1g, etc.).
> 
> Am I using the defrag tool incorrectly, or should I expect this sort
> of behavior while defragging?
> 
> Thanks,
> Eric
> 
> 
> Diagnostic Information
> ----------------------
> uname -a: Linux europa 3.19.0-22-generic #22-Ubuntu SMP Tue Jun 16
> 17:15:15 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> btrfs --version: Btrfs v3.17

I recommend to update both :), but for the defragging it should not matter.

[…]
> Terminal Transcript
> -------------------
> 
> eric@europa:~/filefrag/2015-07-09$ filefrag
> /home/.ecryptfs/eric/.Private/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5Uh
[…]

Nice, someone like me searching the correspondending file name in ecryptfs 
for defragmenting :)

Thanks,
-- 
Martin
