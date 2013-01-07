Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46291 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3AGAvm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 19:51:42 -0500
Received: by mail-ob0-f169.google.com with SMTP id v19so16640596obq.28
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 16:51:41 -0800 (PST)
MIME-Version: 1.0
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 7 Jan 2013 01:51:21 +0100
Message-ID: <CAG-2HqV_pHerHwVVCPhnbUbKwVrA9yyd8GOWdcgNtiv92F5BEA@mail.gmail.com>
Subject: [bug] oops in linux-3.8-rc2
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

I ran into a bug today with 3.8-rc2 [0], following an "make
modules_install && make install" of the kernel.

I have been using the same kernel without problems for some days, the
only change immediately before the oops was that I switched from plain
partitions to using multi-device and subvolumes.

Is there any more info I could give?

Cheers,

Tom

[0]: <https://plus.google.com/114015603831160344127/posts/fzEYnF64NkZ>
(I'm sorry about the quality of the picture, hopefully it is still
useful).
