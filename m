Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35684 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755909AbcH1ReH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 13:34:07 -0400
Received: by mail-oi0-f50.google.com with SMTP id j203so23747830oih.2
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 10:33:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <em54d2d608-3b06-4e46-b795-214cf333e788@laptophendrik>
References: <em54d2d608-3b06-4e46-b795-214cf333e788@laptophendrik>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 28 Aug 2016 11:33:19 -0600
Message-ID: <CAJCQCtRDJ0_pEqtNiQWJoibO=QT-TfF8c7RE7KmF0KZU4T-=OA@mail.gmail.com>
Subject: Re: btrfs check "Couldn't open file system" after error in transaction.c
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 28, 2016 at 4:04 AM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello,
>
> I have a filesystem (three disks with no raid)

So it's data single *and* metadata single?


> btrfs check will lead to  "Couldn't open file system"

Try btrfs-progs all the most recent btrfs-progs to see if it's any
different: 4.5.3, 4.6.1, 4.7 (or 4.7.1 if you can get it, it's days
old).


>
>
> [   98.534830] BTRFS error (device sde): parent transid verify failed on
> 22168481054720 wanted 1826943 found 1828546


That's pretty weird. It wants a LOWER generation number than what it
found? By quite a bit. It's nearly 1500 generations different. I don't
know what can cause this kind of confusion or how to fix it. Maybe
take advantage of the fact it does read only and recreate it. You
could take a btrfs-image and btrfs-debug-tree first, because there's
some bug somewhere: somehow it became inconsistent, and can't be fixed
at mount time or even with btrfs check.



-- 
Chris Murphy
