Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:59408 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab2FJGrQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jun 2012 02:47:16 -0400
Received: from [192.168.7.27] (87.6.216.189) by smtp208.alice.it (8.6.023.02) (authenticated as kreijack@alice.it)
        id 4F056E8511CA6720 for linux-btrfs@vger.kernel.org; Sun, 10 Jun 2012 08:47:14 +0200
Message-ID: <4FD442F1.7040008@inwind.it>
Date: Sun, 10 Jun 2012 08:47:13 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Btrfs and data nocow for per inode basis
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

which is the supposed corrected way to set the file flag FS_NOCOW_FL ? I
know that exists the associated ioctl FS_IOC_SETFLAGS; which I didn't
found is an user-space tool to use to set the flags.

I am missing something ?

Thanks in advance
G.Baroncelli



