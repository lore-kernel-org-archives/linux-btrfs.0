Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33362 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbbEIGeF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 May 2015 02:34:05 -0400
Received: by igbpi8 with SMTP id pi8so43002728igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2015 23:34:04 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 9 May 2015 00:34:04 -0600
Message-ID: <CAJCQCtSK6cejsr=5J=XvWHnU6iUTrQ_gMGV3ExBwoxvO0ZaXcQ@mail.gmail.com>
Subject: oops BUG unable to handle kernel NULL point dereference IP io_ctl_check_crc
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=97991

A file system with no problems booting 4.0.1 and 3.9.7 kernels on
ancient i686 hardware. Btrfs check has no complaints. But it won't
boot 4.1.0.rc2 at all and explodes so spectacularly I can't really
capture anything.

The best I have so far is using rd.break=pre-mount, and manually
mounting the btrfs. No complaints. But the instant I try to write a
file: dmesg > dmesg.txt, I get a panic.

All I have at the moment is a photo until I can reproduce in a VM.

-- 
Chris Murphy
