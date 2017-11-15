Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:47089 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757594AbdKOKfT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 05:35:19 -0500
Received: by mail-lf0-f44.google.com with SMTP id k66so13590064lfg.3
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 02:35:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43412efa-ff56-9682-c8f7-a5966b87b10e@lukas-pirl.de>
References: <CAK5rZE51onZEE_f2xg4nxPriU9YQq5AARDLs-BTZL2RaGSCTXA@mail.gmail.com>
 <43412efa-ff56-9682-c8f7-a5966b87b10e@lukas-pirl.de>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Wed, 15 Nov 2017 12:35:17 +0200
Message-ID: <CAK5rZE7rLToV7t+6pZhTbN2+JQj=W67Y5mESNhpaF0ehZzObOA@mail.gmail.com>
Subject: Re: zstd compression
To: Lukas Pirl <btrfs@lukas-pirl.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/15/17, Lukas Pirl <btrfs@lukas-pirl.de> wrote:
> you might be interested in the thread "Read before you deploy
> btrfs + zstd"¹.

Thanks. I've read it. Bootloader is not an issue since /boot is on
another uncompressed fs.

Let me make my question more generic:

Can there be any issues for switching mount time
compressions options from one to another, in any order?
(i.e none -> lzo -> zlib -> zstd -> none -> ...)

zstd is only a newcomer so my question applies to all
combinations..
