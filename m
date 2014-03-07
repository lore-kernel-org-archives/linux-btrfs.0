Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:41294 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaCGQOr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Mar 2014 11:14:47 -0500
Received: by mail-bk0-f52.google.com with SMTP id my13so967185bkb.39
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Mar 2014 08:14:46 -0800 (PST)
Received: from [192.168.7.7] (a207.net131.okay.pl. [85.28.131.207])
        by mx.google.com with ESMTPSA id ey13sm3106316bkb.11.2014.03.07.08.14.45
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 07 Mar 2014 08:14:46 -0800 (PST)
Message-ID: <5319F075.7050903@gmail.com>
Date: Fri, 07 Mar 2014 17:14:45 +0100
From: KC <impactoria@googlemail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Problems on previously perfect setup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Recently (a week or so back) I started having those problems on my BTRFS 
system

-------------
I. My setup:
-------------
SSD
/boot           ext2    defaults        0       2
/  btrfs rw,noatime,compress=lzo,ssd,space_cache,autodefrag 0 0 (there 
is a /home subvolume mounted automatically)

HDD
/mnt/Disk_D  btrfs rw,noatime,compress=zlib,autodefrag,nofail 0 0
(I disconnected it, but it changed nothing)


--------------------------
II. My problems:
--------------------------
- 1 - . During random boots (seems to be a 50/50 chance) the system 
won't boot, because it get's stuck on

[ OK ] Mounted Configuration File system
[ *** ] (1 of 13) A start job is running for dev-disk-by\.....

It will slowly cycle from 1 to 13, then come back to 1 to cycle again, 
and again, and after three times, I get this:

Timed out waiting for device dev-disk-by\...
Dependency failed for /boot
Dependency failed for Local File System

The computer freezes and I have to shut it down by holding the power 
button for several seconds.



- 2 - . My successful boot times extended considerably. I am using an 
automatic login and X start without any DM. Before, I could hardly see 
the login command line because it was so quickly covered by started 
OpenBox session. Now it lingers several seconds while the disk LED is 
working hard.



- 3 - . For the first 10-15 seeocnds after getting into OpenBox the 
heaviest processes displayed by Conky are several instances of kworker. 
Also, it might be an impression, but I feel like the starting almost 
every program became sluggish.


--------------------------
III. Recent changes to the system:
--------------------------
Perhaps they could indicate potential suspects:

- upgraded kernel (now 3.13.5-2)
- upgraded btrfs tools (always using latest David Sterba's unstable 
'integration' branch)
- did "btrfs balance /" because it had write erros due to no space even 
though there was like 30GB free. After doing it, no space problem went away



Does anyone have any idea what could be happening?
