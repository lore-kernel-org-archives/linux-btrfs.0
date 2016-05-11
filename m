Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:49630 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbcEKTut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 15:50:49 -0400
Received: from localhost (unknown [192.168.1.183])
	by mail2.linuxsystems.it (Postfix) with ESMTPSA id 4E3CDA415C
	for <linux-btrfs@vger.kernel.org>; Wed, 11 May 2016 21:50:45 +0200 (CEST)
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Subject: Amount of scrubbed data goes from 15.90GiB to 26.66GiB after =?iso-8859-1?Q?defragment_-r_-v_-clzo_on_a_fs_always_mounted_with_compres?=
 =?iso-8859-1?Q?s=3Dlzo?=
Date: Wed, 11 May 2016 21:50:43 +0200
MIME-Version: 1.0
Message-ID: <264486fb-94ce-4040-a436-e9db5de9a203@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Before doing the daily backup I did a btrfs check and btrfs scrub as usual. 
After that this time I also decided to run btrfs filesystem defragment -r 
-v -clzo on all subvolumes (from a live distro) and just to be sure I 
runned check and scrub once again.

Before defragment: total bytes scrubbed: 15.90GiB with 0 errors
After defragment: total bytes scrubbed: 26.66GiB with 0 errors

What did happen? This is something like a night and day difference: almost 
double the data! As stated in the subject all the subolumes have always 
been mounted with compress=lzo in /etc/fstab, even when I installed the 
distro a couple of days ago I manually mounted the subvolumes with -o 
compress=lzo. Instead I never used autodefrag.

Niccolò
