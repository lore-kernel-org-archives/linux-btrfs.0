Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:2469 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaJDKe1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Oct 2014 06:34:27 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id BD560313AF
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Oct 2014 06:38:35 -0400 (EDT)
Message-ID: <542FCB53.1070201@shiftmail.org>
Date: Sat, 04 Oct 2014 12:26:27 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Performance reduces with nodatasum
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
apparently I have found an issue with btrfs: performance reduces with 
nodatasum and multi-device "raid0" or "single".

I was testing with a series of 8 LIO ramdisks, with btrfs on those in 
multi-device single mode, and writing zeroes on the filesystem with 16 
dd in parallel.
Performance decreases significantly if the filesystem is mounted with 
nodatasum, or with nodatacow which implies nodatasum.
CPU occupation also reduces, together with speed, as seen with htop.

At first I thought it was my problem, but then I saw this web page
http://www.linux-mag.com/id/7308/3/
which also reports reduced performance with nodatasum and multi-device 
raid0 or single, e.g. see these two lines:

Btrfs
two disks,
single
standard
50.144    50.264    126.984    131.130

Btrfs
two disks,
single
nodatacow,
nodatasum
43.834    47.603    131.612    131.470

similarly with raid0

even more with compression:

Btrfs
two disks,
raid0
-o compress
70.234    69.048    130.852    129928
Btrfs

two disks,
raid0
-o compress
nodatacow,
nodatasum
48.762    48.831    130.812    130.202


If you go higher with the performances, such as with ramdisks, in the 
GB/sec range, it reduces more than that. I have noticed upto 50% reduction.

It would be important to fix this problem for high-performance usages of 
btrfs.

Best regards
BM

