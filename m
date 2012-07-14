Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52424 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab2GNGsO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Jul 2012 02:48:14 -0400
Received: by lbbgm6 with SMTP id gm6so6783752lbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jul 2012 23:48:12 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 14 Jul 2012 10:48:12 +0400
Message-ID: <CAF7mNP4oQ=sSXf-gVSMF2Xq89OL25L7HnWL4MbqSONxr8=RRTQ@mail.gmail.com>
Subject: bug: raid10 filesystem has suddenly ceased to mount
From: =?UTF-8?B?0JjQstCw0L0g0KHQvNC40YDQvdC+0LI=?=
	<feliz.cha.cha.cha@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
The problem is that the BTRFS raid10 filesystem without any
understandable cause refuses to mount.
Here is dmesg output:
[77847.845540] device label linux-btrfs-raid10 devid 3 transid 45639 /dev/sdc1
[77848.633912] btrfs: allowing degraded mounts
[77848.633917] btrfs: enabling auto defrag
[77848.633919] btrfs: use lzo compression
[77848.633922] btrfs: turning on flush-on-commit
[77848.658879] parent transid verify failed on 2363592273920 wanted
31596 found 25250
[77848.659060] parent transid verify failed on 2363592273920 wanted
31596 found 25250
[77848.659274] parent transid verify failed on 2363592273920 wanted
31596 found 25250
[77848.659455] parent transid verify failed on 2363592273920 wanted
31596 found 25250
[77848.659459] parent transid verify failed on 2363592273920 wanted
31596 found 25250
[77848.659464] btrfs: failed to read chunk tree on sdc1
[77848.661376] btrfs: open_ctree failed

Linux kernel: 3.3.0-3-grml-amd64
Distribution: Debian (mix of stable and testing branches with grml kernel).
S.M.A.R.T. of all drives is good.
