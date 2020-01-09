Return-Path: <SRS0=yhka=26=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA9FC282DD
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Jan 2020 22:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E8A42077C
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Jan 2020 22:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="T7CkZ/aD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgAIWtB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 17:49:01 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46465 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbgAIWtA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2020 17:49:00 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so9113161wrl.13
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2020 14:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pdHSSxoF0OqVbTTHcXbEiQ0EWCIaWYi/DNSskbh8/Vo=;
        b=T7CkZ/aDC4aQ9m3V9qKxwrZva1BksO5FeoO20YI3Wpd6115e9ta0TCXn79bE9LynaW
         8SHuPYVN+a7Ni4ea4FpNcaxIhCVpbrM14goMPLU74z1E4dhkqvW0vO/W8WhhAyd2JYfc
         Fp/wS2XfGIv1haJR0PaS/tdgoKbs3SD0VrjfdaXaTCfnrEjF9MyO2dAGwh9PxBa1+Fe5
         VeEsAtT5uuLROptXbvFt/rVJmm24BIielqOYn2aYM0rdYnGYtmw5BR9PKuQC6IwGZXDI
         ezGV/C3vvsShmhTyyqdLx8DywufeqRHNIIc1OjLiVByXXoBGZYq/W86Zekq66E4xmztN
         n2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pdHSSxoF0OqVbTTHcXbEiQ0EWCIaWYi/DNSskbh8/Vo=;
        b=fq1OU8lhn8dapDaSmmABdcgdlZQTQHyLuU27P4fLYQqb7Om+esFzhuaJ4fx6Y/Xp0w
         yLh1ASRVZ+XWhSrMOEoPaVqnAzEI+AdlaRpf8QYSs0chlWMcYVc3MmnSSzfBqlLCWiKi
         3lsJ4cZVARTHAZBzy15O0QHedGcd7ROKoHjnGCHX3HnWs6d1o+fmfL0QLu1Kmjm/YCBD
         kOzcBx83ME/VyOwN0mQ3eqADI4zT8Q6PQqcJoVgG0gL2AdXKeovAhnaf59Swn3Z6LGhm
         lK4zRYb6/9AYk3Gyh85sM2u0Wj8g04k+6tdJOT1/twOUyF/X6OGkK0TCYwRgueOLUI0E
         HYyg==
X-Gm-Message-State: APjAAAVttMQ2FlxrumK0f5fx+UNPxy319eXBgDK8PPSKqGDHlYpCsuuQ
        yMfETj5SrBlL4Law+SfZ8LfLI+eRok2Er0Vu2p9oUQPsM8fafA==
X-Google-Smtp-Source: APXvYqwt1TMyX/+r30GttmmFMo6PZ3drhIyx28UXu+n4I00xcnvI+Qdjw961ES7tAzkT18eJZOd19lmivB5os9UZfUk=
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr93090wrp.167.1578610139771;
 Thu, 09 Jan 2020 14:48:59 -0800 (PST)
MIME-Version: 1.0
References: <b2ccde6952d0fa67c9948a21cd3ac8eddcdb3970.camel@render-wahnsinn.de>
 <CAJCQCtQQWGRQBAeCKt07MG33t9vwi-gahn7Mn9xJpA=HSAuTbw@mail.gmail.com> <0530e18f43a5f31ff8d446be362951f68068b5db.camel@render-wahnsinn.de>
In-Reply-To: <0530e18f43a5f31ff8d446be362951f68068b5db.camel@render-wahnsinn.de>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 9 Jan 2020 15:48:43 -0700
Message-ID: <CAJCQCtTwRx3OX4YmNQ5cDkhuiATa7LRp-iA3LQQW2af1t4AQrQ@mail.gmail.com>
Subject: Re: How long should a btrfs scrub with RAID5/6 take?
To:     Robert Krig <robert.krig@render-wahnsinn.de>
Cc:     Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 8, 2020 at 11:38 PM Robert Krig
<robert.krig@render-wahnsinn.de> wrote:
>
> I'm on Debian using Kernel 5.3.0-0.bpo.2-amd64 and btrfs-progs version
> v5.2.1.
>
> Here's an output of scrub status:
> ######################################
> UUID:             c4adb372-178b-4398-977d-bc91bef6130f
>         no stats available
> Time left:        87884330:53:42
> ETA:              Thu Oct 26 11:30:49 12045
> Total to scrub:   18.67TiB
> Bytes scrubbed:   35.70TiB
> Rate:             55.60MiB/s
> Error summary:    no errors found
> #######################################

10,000 years from now. That's a bug! :D Quick look through btrfs-progs
git log, I'm pretty sure 5.2 has the current scrub related fixes. But
it's best if you can test btrfs-progs 5.4 (or even 5.4.1 if you have
to build it anyway). If it does reproduce still, it might be useful
for a developer to see the following output:

$ cd /sys/fs/btrfs/<fsuuid>/allocation/
$ grep -r .



-- 
Chris Murphy
