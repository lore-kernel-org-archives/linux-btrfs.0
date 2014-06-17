Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zougloub.eu ([198.27.83.45]:40568 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932762AbaFQSUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 14:20:46 -0400
Received: from Vantage.tamaggo.local (unknown [IPv6:2607:5300:60:242d:1::2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by zougloub.eu (Postfix) with ESMTPSA id 5279C9676AA
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 14:07:19 -0400 (EDT)
Date: Tue, 17 Jun 2014 14:12:19 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [3.16-rc1] BUG: fsync not finishing during rootfs mount (getty
 doesn't finish)
Message-ID: <20140617141219.599097b1@Vantage.tamaggo.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


I updated 2 computers to 3.16-rc1 and they both did the same thing when
mounting the rootfs: after entering the login/password, the shell didn't
appear.
120 seconds later, there is a message about a hung task, it's about
fsync not finishing, with a traceback showing SyS_fsync / ... /
btrfs_sync_file / btrfs_wait_ordered_range / ...

The linux-btrfs/for-linus doesn't have this problem, so it looks like
it's about integration in -rc1.

Side note: after that, the filesystem is not mountable if I
forcibly reboot the computer or try to mount it elsewhere (with 3.15).
We've had to use btrfs-select-super to allow it to mount.

I'm on #btrfs, have gotten help from xaba and kdave.


Regards,

-- 
Jérôme
