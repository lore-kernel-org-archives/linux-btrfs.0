Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:51429 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbcDOI2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 04:28:33 -0400
Received: from localhost (unknown [192.168.1.166])
	by mail2.linuxsystems.it (Postfix) with ESMTPSA id 5577BA37BA
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 10:21:00 +0200 (CEST)
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Subject: Uncorrectable errors after rebooting with Magic Sysrq Keys
Date: Fri, 15 Apr 2016 10:21:00 +0200
MIME-Version: 1.0
Message-ID: <b4f09d8b-baac-4182-81b1-1ba9f5e4195b@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Unfortunately because of buggy upstream support for my hardware (Dell XPS 
13 9343) I often have to force reboot using Magic Sysrq Keys (REISUB). In 
fact I have quite a few hangs, also the majority of times I am not able to 
shutdown without relying on REISUB. There are obviously times when even 
REISUB do not work (kernel is completely unresponsive), but the vast 
majority of times it works. What I do not understand is why Magic Sysrq 
Keys leave me with a damaged filesystem: shouldn't an emergency SYNC + read 
only remount be enough to secure my data? After rebooting with REISUB my 
system often complains about "read only" files and if I "stat" them I get 
"weird file". I often loose some of my desktop settings like the plasmoids 
I had on the desktop or my favourite applicatios I had in the menu, but 
what's even stranger is that I often magically recover them later, while 
doing exactly NOTHING to recover them. This behaviour scares me so much 
that I'm thinking about switching to another fs if I will not find a 
solution very soon.

The disk seems fine: https://bpaste.net/show/822d4b4ff902

dmesg: http://paste.pound-python.org/show/wVyHXXOw4emWmWFfVJHQ/

$ sudo btrfs scrub status /
[sudo] password di niko: 
scrub status for 28443ff1-5325-45f6-b879-dad895fcdcfb
        scrub started at Fri Apr 15 09:38:09 2016 and finished after 
00:08:41
        total bytes scrubbed: 133.94GiB with 10 errors
        error details: csum=10
        corrected errors: 0, uncorrectable errors: 10, unverified errors: 0

(yesterday there were 4 uncorrectable errors, but after today's reboot with 
Magic Sysrq Keys it is now 10)

Distro is Arch Linux, kernel is 4.6.0-rc3.
$ btrfs --version
btrfs-progs v4.4.1

Greetings,
Niccolò
