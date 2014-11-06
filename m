Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:55119 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaKFOzB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 09:55:01 -0500
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id DE370123CE
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Nov 2014 15:45:23 +0100 (CET)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 19241-06 for <linux-btrfs@vger.kernel.org>;
 Thu,  6 Nov 2014 15:45:22 +0100 (CET)
Received: from [172.32.99.66] (mail.oops.co.at [213.129.238.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id 37B67123C8
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Nov 2014 15:45:22 +0100 (CET)
Message-ID: <545B8981.2010603@xunil.at>
Date: Thu, 06 Nov 2014 15:45:21 +0100
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: "corrupt leaf" on kernel 3.17.2, w/ btrfs-progs 3.17
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



My rootfs on /dev/sda2 (an SSD) shows this:

Nov 06 15:37:26 hiro.oops.intern kernel: BTRFS critical (device sda2):
corrupt leaf, slot offset bad: block=100235100160,root=1, slot=142

Scrub runs through fine:

# btrfs scr stat /dev/sda2
scrub status for ea95dbd1-ef4e-48a4-9732-54e6c80b31df
	scrub started at Thu Nov  6 15:35:00 2014, running for 172 seconds
	total bytes scrubbed: 68.46GiB with 0 errors

Do I have to panic? ;-)

Pls advise how to proceed.

Should I do some repair or btrfsck from a live-medium?

I found this:

http://comments.gmane.org/gmane.comp.file-systems.btrfs/34407

but haven't yet figured out what that means to me.


# btrfs version
Btrfs v3.17

# cat /proc/version
Linux version 3.17.2-gentoo (root@hiro.oops.intern) (gcc version 4.8.3
(Gentoo 4.8.3 p1.1, pie-0.5.9) ) #1 SMP Thu Nov 6 00:53:58 CET 2014


Stefan
