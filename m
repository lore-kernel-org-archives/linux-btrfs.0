Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:37869 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbeHAF2p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 01:28:45 -0400
Received: by mail-ua0-f182.google.com with SMTP id y10-v6so11767974uao.4
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2018 20:45:16 -0700 (PDT)
MIME-Version: 1.0
From: MegaBrutal <megabrutal@gmail.com>
Date: Wed, 1 Aug 2018 05:45:15 +0200
Message-ID: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
Subject: BTRFS and databases
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I know it's a decade-old question, but I'd like to hear your thoughts
of today. By now, I became a heavy BTRFS user. Almost everywhere I use
BTRFS, except in situations when it is obvious there is no benefit
(e.g. /var/log, /boot). At home, all my desktop, laptop and server
computers are mainly running on BTRFS with only a few file systems on
ext4. I even installed BTRFS in corporate productive systems (in those
cases, the systems were mainly on ext4; but there were some specific
file systems those exploited BTRFS features).

But there is still one question that I can't get over: if you store a
database (e.g. MySQL), would you prefer having a BTRFS volume mounted
with nodatacow, or would you just simply use ext4?

I know that with nodatacow, I take away most of the benefits of BTRFS
(those are actually hurting database performance – the exact CoW
nature that is elsewhere a blessing, with databases it's a drawback).
But are there any advantages of still sticking to BTRFS for a database
albeit CoW is disabled, or should I just return to the old and
reliable ext4 for those applications?


Kind regards,
MegaBrutal
