Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:49544 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaK3DcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 22:32:04 -0500
Received: by mail-qc0-f177.google.com with SMTP id x3so6253117qcv.36
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 19:32:03 -0800 (PST)
MIME-Version: 1.0
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 30 Nov 2014 09:01:42 +0530
Message-ID: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
Subject: Moving an entire subvol?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So the Ubuntu Wiki BtrFS entry advises against using subvol
set-default because it boots its kernel using root=subvol=@ and home
as subvol=@home, and these two subvols are only present under the
subvol with ID 5. But isn't it just possible to move i.e. reparent a
subvol so I can move these two under another subvol and have that as
default?

Possibly this is a hypothetical question as I'm not sure whether it
would be actually practically required but looking at the specific
Ubuntu advice on this I thought I should ask.

I'm also not sure what openSUSE (or other distros) do about this... Do
they mount root using subvolid, or subvol name or such?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
