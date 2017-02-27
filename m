Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f172.google.com ([209.85.213.172]:34055 "EHLO
        mail-yb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdB0GXm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 01:23:42 -0500
Received: by mail-yb0-f172.google.com with SMTP id i66so16760754yba.1
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Feb 2017 22:23:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5d68d16c-8dd8-ca69-a345-a64350d5f65f@gmx.net>
References: <5d68d16c-8dd8-ca69-a345-a64350d5f65f@gmx.net>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Mon, 27 Feb 2017 06:25:38 +0100
Message-ID: <CANznX5F0TYv7zaM13jQway8XsJWFghqN=BRdQfTSh1gaDePHkA@mail.gmail.com>
Subject: Re: linux 4.8 kernel OOM
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So far 4.10.0 seems to be flawless for me. All the strange OOMs (which
may or may not were related to Btrfs but it looked that way), random
unexplained Btrfs mount failures (as well as some various other things
totally unrelated to filesystems like sdhc card reader driver
problems) which were present with 4.8.x and 4.9.x seem to be all gone
(at least so far... it has been only a few days that I updated to
4.10.0).
