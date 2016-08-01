Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gabriel-3.zfn.uni-bremen.de ([134.102.50.3]:35286 "EHLO
	smtp.uni-bremen.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753971AbcHAQOO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 12:14:14 -0400
Received: from Stephans-MBP.fritz.box (55d45ed3.access.ecotel.net [85.212.94.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.uni-bremen.de (Postfix) with ESMTPSA id C035BE0291
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Aug 2016 18:07:34 +0200 (CEST)
From: =?UTF-8?Q?Stephan_Hopfm=c3=bcller?= <st_ho@uni-bremen.de>
Subject: Corruption through subsequent compression?
To: linux-btrfs@vger.kernel.org
Message-ID: <956dd4cb-973f-6e1e-e06d-85e50c32c5c3@uni-bremen.de>
Date: Mon, 1 Aug 2016 18:07:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

I've got into some trouble with my 40GB BTRFS formatted root partition 
in a 2015 Macbook 15": I was running low on free space so I remembered, 
that I had forgotten to enable compression while installing Antergos (a 
flavour of Arch Linux). So I looked into the Arch Wiki at 
https://wiki.archlinux.org/index.php/Btrfs and executed
"btrfs filesystem defragment -r -v -clzo /"
as normal user. I noticed, that it would only compress files inside my 
home folder (which is on the same partition), so I run it again with 
"sudo". After some time I was surprised by windows closing and thought, 
that this might release file handles or something like that (I'm not 
experienced with the inner structure of BTRFS and optimization like 
defragment). I feared what might happen, when the console session, in 
which I was running the btrfs command, would get closed, but Ctrl-C-ing 
it would probably do damage too - so I waited till the window vanished. 
(KDE did already crash previously, so there already weren't any window 
decorations etc.).
After a reboot I tried running the same command again in a login shell 
(by pressing CTRL+ALT+F2) (so no desktop environment which could 
interfere somehow) and at some time it said "no space left on device". I 
started searching and read about metadata being full resulting in this 
error. A quick check resulted in about 75% usage, so I tried a rebalance 
with increasing "dlimit" till it tried moving blocks - this was the case 
at dlimit=12. Again I received the annoying "no space left on device" 
message and deleted some files (pacman cache etc.) and tried it again 
some more times. After some tries the btrfs executable crashed with a 
weird error saying:
"BTRFS: error (device dm-0) in merge_reloc_roots:2421: errno=-28 No 
space left
----------[ cut here ]----------
kernel BUG at fs/btrfs/volumes.c:3421!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: [...]"
I took a picture of the screen in case the complete error message might 
be needed.
Now I knew I was in trouble but didn't want to give up. I thought, that 
the compression might have somehow overwritten part of the btrfs 
executable with zeros and tried reinstalling it from the pacman cache, 
but it wasn't possible because of the filesystem being switched to read 
only. After a reboot things were looking even worser: Something like 
"...fixing, but needing a reboot" scrolled to the top and afterwards it 
only kept saying something like "CPU #... is hanging for [something 
about 20s]" and named a process (mount, kworker and some btrfs subprocess).
At this time it was past 2 am and all I wanted was getting some sleep, 
so I just powered it of by holding the power key.
Now, some hours later, I still don't know, whether my filesystem still 
can be fixed or whether I'm better left of nuking it and starting over...
My most important files are placed on a EXFAT formated partition and 
partially synced to some cloud-service, so I would probably only loose 
some time to redownload all applications (and my browser history etc.). 
I was really constrained on space so I didn't had much options for 
backing up the system. Next time I probably should get an external hard 
drive...
Now I'm constrained to use OS X but at least my Macbook is still usable 
(so the SSD still seams to be working).
As I'm not experienced with this kind of situation I am not sure what to 
do - probably doing some investigation out of a live system?

Could somebody please help me in trying to fix my filesystem?

Greetings,
Stephan

