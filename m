Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dsl-pw-ha2.btc-net.bg ([212.39.90.102]:58162 "HELO
	dsl-pw-ha2.btc-net.bg" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751605AbaD0MAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Apr 2014 08:00:43 -0400
From: =?UTF-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
To: "'Chris Mason'" <clm@fb.com>, "'Chris Murphy'" <lists@colorremedies.com>,
        "'Marc MERLIN'" <marc@merlins.org>,
        "=?UTF-8?Q?'Johannes_L=C3=B6thberg'?=" <johannes@kyriasis.com>,
        "'Duncan'" <1i5t5.duncan@cox.net>
Cc: <linux-btrfs@vger.kernel.org>
Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or newer? - RESOLVED
Date: Sun, 27 Apr 2014 15:00:16 +0300
Message-ID: <001501cf6210$4142a840$c3c7f8c0$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The problem reported in this thread has been RESOLVED.

It's not BTRFS's fault.

Debugging on my part led to the actual problem in do_mounts.c - some filesystems mount routines return error codes other than 0, EACCES and EINVAL and such return codes result in the kernel panicking without trying to mount root with all of the available filesystems.

Patch is available as attachment to bug 74901 - https://bugzilla.kernel.org/show_bug.cgi?id=74901 . The bugentry documents how I managed to find the problem.

Also, the patch has been sent to the linux kernel mailing list - see http://news.gmane.org/find-root.php?group=gmane.linux.kernel&article=1691881 Hopefully, it will find its way into the kernel, and later on - in stable releases.

Thanks to you all!
------------------------------
Plamen Petrov

