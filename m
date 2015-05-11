Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35711 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbbEKCzG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 May 2015 22:55:06 -0400
Received: by ieczm2 with SMTP id zm2so98512344iec.2
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2015 19:55:05 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 10 May 2015 20:55:05 -0600
Message-ID: <CAJCQCtSyn7XVG4ZZcuF_FrpJDUd3WiaLY5JiGu80e2ghEoCYog@mail.gmail.com>
Subject: bug, volume can be umounted before fs has fully flushed to disk,
 results in scary warning
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=98051

I'm not sure what the expected behavior is here, because a file system
can only do so much to deal with bugs in the device (or USB bridge
chipsets). But my gut instinct is that I shouldn't get a return to
prompt from umount until it's safe to disconnect the device.

This error suggests otherwise. YetI have no idea how long I'd have to
wait to avoid this message, which doesn't always happen. This is not a
regression, I've seen it before. So far there's been no complaints on
normal remount or btrfs check, so despite the 1 flush being dropped
(?) the file system is consistent.


-- 
Chris Murphy
