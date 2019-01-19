Return-Path: <SRS0=mgXs=P3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B97C5AE5E
	for <linux-btrfs@archiver.kernel.org>; Sat, 19 Jan 2019 02:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5064A2086D
	for <linux-btrfs@archiver.kernel.org>; Sat, 19 Jan 2019 02:12:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="ExvIDvTv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbfASCMg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 21:12:36 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:46757 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbfASCMf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 21:12:35 -0500
Received: by mail-lj1-f178.google.com with SMTP id v15-v6so13149118ljh.13
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 18:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8KfvN9lfxCFYO5FQPV8BqjWj8qDh0q0S8G06zK9mz+4=;
        b=ExvIDvTvBb3pqYHzfCLAXsoScMJtuxnMN7r7L0a1KgKYUOSw6iFGzgqGnz3LCA8nf3
         Gv/MmLNcTC9EDdWny9oChTTtW796QPU8WlTNsbNou998oQghodfd2TM2Q+UJQHnoOpDp
         uco5+Ju/9ElWNO5zljDcbpozjuSnvTIlcvU+f08/GFrbfF5G3a7ugyA5J3vl6bjeWcOn
         hYx2+SRW702EuPOAogsOH1YprcH4T5j+cKvjT76gkO1IhXUmtkZG2MDpWsmwwznKh7cg
         9kwHrtTK5ChaWDDKuJmRP9mLBk/EF1/ZEiWC20GlHlKQFRU+6aDB71RcVLXH+waraToi
         mzLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8KfvN9lfxCFYO5FQPV8BqjWj8qDh0q0S8G06zK9mz+4=;
        b=epTcnbtUFUyyzmSZju0TTs0bNiX17vwi2zMwSjIQE1qnxhh168gGEetBai70rW+cM6
         +oopkC4nOtDrEYDyL41cMy4SZDyvmqBUr0PkSBKkd8UzJ2PLEzWmA/sKdkUGBOSgRr5c
         NCPZXnmU9rB2ZKjeudOMHgTAn3zZoQ9nHE+30ibQqprwW64p4f9/NQLzW8qqKW0pmONa
         ddSDxujthUbpiqXzVA5l4gKk61JKCMgntpF7ynA1/UDXey1HV7G1vwtUluShAEyA0COz
         iNiHuVN5dQ7YXMRBb8XdDb2IHT43IGppNW27GiJ0GOc9/giDzfpapvchAqci2I8ANNkX
         CE2A==
X-Gm-Message-State: AJcUukcNmZHL5JV5hFRcfudify0RIT/G0gXm34Rx41Z3TdCX9yo9JA8H
        woCnhrYpkEyHSiM0cFoO25EP2Ho/S1hFlIZUAcP0WCQm
X-Google-Smtp-Source: ALg8bN6v9RJ5kxjhcJR1RfcnFWABQpQ8AL9aCTv2PjBn7XVCo51uPvuEDyk3mCnNM7od6s/vZmdiLqbdVSMW2415r4w=
X-Received: by 2002:a2e:2e1a:: with SMTP id u26-v6mr14654816lju.8.1547863953362;
 Fri, 18 Jan 2019 18:12:33 -0800 (PST)
MIME-Version: 1.0
References: <80ef8767a6a5fc0477559732cf18ecb8@virtall.com>
In-Reply-To: <80ef8767a6a5fc0477559732cf18ecb8@virtall.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 18 Jan 2019 19:12:21 -0700
Message-ID: <CAJCQCtS+xi-zN4UxMoULUkUrxOQZ74RdYZ8ivFjY6PDFzd5FdQ@mail.gmail.com>
Subject: Re: question about creating a raid10
To:     Tomasz Chmielewski <tch@virtall.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 17, 2019 at 4:28 PM Tomasz Chmielewski <tch@virtall.com> wrote:
>
> > It is actually more like RAID-1E which is supported by some hardware
> > RAID HBA. The difference is that RAID-1E is usually using strict
> > sequential block placement algorithm and assumes disks of equal size,
> > while btrfs raid10 is more flexible in selecting where next mirror pair
> > is allocated.
>
> s/flexible/random/
>
> In sense, with btrfs, you can't really choose where the blocks are
> allocated, that's not really the definition of "flexible"?

Depends on perspective, if you don't care where they go but you care
about being able to add a single arbitrary sized drive or two or
three, you can grow a Btrfs raid10 volume. You can't do that with
conventional raid10.

-- 
Chris Murphy
