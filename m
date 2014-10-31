Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:52318 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161331AbaJaAV6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 20:21:58 -0400
Received: by mail-yk0-f169.google.com with SMTP id 142so2821985ykq.28
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 17:21:57 -0700 (PDT)
MIME-Version: 1.0
From: Noah Massey <noah.massey@gmail.com>
Date: Thu, 30 Oct 2014 20:21:17 -0400
Message-ID: <CADfjVrj9dwq4gpzcFt_OW4wFb+oLX-cvD5PAOfnHTMqCzHfcvw@mail.gmail.com>
Subject: fstrim on BTRFS
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am looking for some clarification on TRIM / SSD maintenance.
The wiki [1] suggests periodic fstrim, but fstrim does not discard
unallocated blocks[2].
Which makes sense, given that mkfs issues a device wide trim, so they
shouldn't have data.

But it seems like both a balance, and a pending patch
( 47ab2a6 Btrfs: remove empty block groups automatically )
can deallocate block groups without TRIM, leading to the SSD retaining
data it doesn't need to.

Is there a bitter way to trigger a more thorough discard than
fallocate, rm, fstrim, balance -dusage=0 ?
And are there plans to support trimming unallocated space, or is this
not possible with current FS format?

Thank you,
Noah

[1] https://btrfs.wiki.kernel.org/index.php/FAQ#Does_Btrfs_support_TRIM.2Fdiscard.3F
[2] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg14195.html
