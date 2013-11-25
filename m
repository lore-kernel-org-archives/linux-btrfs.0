Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:56534 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3KYVph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 16:45:37 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2A8549A0017
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 14:45:37 -0700 (MST)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id c1QmIxL4rYCKR2Km (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 14:45:36 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Message-ID: <20131125214534.8160.40797@ret.masoncoding.com>
From: Chris Mason <chris.mason@fusionio.com>
Subject: btrfs-progs tagged as v3.12
Date: Mon, 25 Nov 2013 16:45:34 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've tagged the current btrfs-progs repo as v3.12.  The new idea is that
instead of making the poor distros pull from git, I'll be creating
tagged releases at roughly the same pace as Linus cuts kernels.

Given the volume of btrfs-progs patches, we should have enough new code
and fixes to justify releases at least as often as the kernel.  Of
course, if there are issues that need immediate attention, I'll tag a .y
release (v3.12.1 for example).

If the progs changes slow down, we might skip a version.  But tracking
kernel version numbers makes it easier for me to line up bug reports,
mostly because I already devote a fair number of brain cells to
remembering how old each kernel is.

Just let me know if there are any questions.

-chris

