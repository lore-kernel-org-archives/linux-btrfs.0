Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:36025 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751784AbdDIVZT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Apr 2017 17:25:19 -0400
Received: by mail-yb0-f178.google.com with SMTP id i124so26436654ybc.3
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Apr 2017 14:25:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1491758260.15056.2.camel@campus.tu-berlin.de>
References: <1491758260.15056.2.camel@campus.tu-berlin.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 9 Apr 2017 15:25:18 -0600
Message-ID: <CAJCQCtRqidKACy7SAEzpEGLK1PbWQZgbesaLhLEVntMPz9aG5g@mail.gmail.com>
Subject: Re: BTRFS not mountable, recover won't work
To: Malte Eggers <m.eggers@campus.tu-berlin.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 9, 2017 at 11:17 AM, Malte Eggers
<m.eggers@campus.tu-berlin.de> wrote:
> Hi,
>
> After suspending and waking up my laptop with the external hard drive
> connected, I could no longer access the files on it. So I unmounted and
> remounted it, only to discover that I could no longer mount it.

What kernel and btrfs-progs version? Anything older than 4.9 of either
and I'd try something newer as a first step. This sounds to me like
something dropped the ball: either fs freeze didn't happen (unlikely)
or the drive lied about fsync succeeding, or FUA if supported, and
dropped the data once power was cut to the drive. I'd check if there
are firmware updates for the drive.

Curious about:

btrfs rescue super -v <dev>
btrfs check <dev>




-- 
Chris Murphy
