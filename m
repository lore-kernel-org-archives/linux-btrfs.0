Return-Path: <SRS0=mgXs=P3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC98C5AE5E
	for <linux-btrfs@archiver.kernel.org>; Sat, 19 Jan 2019 02:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D726B2084C
	for <linux-btrfs@archiver.kernel.org>; Sat, 19 Jan 2019 02:43:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="fk22la1q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbfASCnr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 21:43:47 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:34495 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729963AbfASCnr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 21:43:47 -0500
Received: by mail-lj1-f174.google.com with SMTP id u89-v6so13244047lje.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 18:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=8m19siplM+7xm6lAPVTsQX2Ff0uZpTCuUwTZvS9rv6g=;
        b=fk22la1qnf9SWdwkoZIfMqsxP4j3JSCOVi+yUC84TLiixgAlBz04calHe3G+aceeEY
         Ct2yYyHznTaRLKTNCN1rXO7qWudGKyl8qC/b/9ntmnizb94WiVv93scIrW6iszVePhNr
         wPcvMSGpub/8BOWl3u2Z41Jaewg/Ewb+VGuiR1Xc2e1sj1lc0ItMjAA8NuCcURWDNlhD
         CM8G3aL7eu1lS2zseRfNat/Axk6mFeBKj+fetEmj2N5AglNURSkXfH0lmifFezzcwf53
         2D4ukOWJRGleIJe011rVk2AaCEbUax36/g5qAqTdXbEEpJoi4WgWAq0CNYLmhVRr2s9L
         dE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=8m19siplM+7xm6lAPVTsQX2Ff0uZpTCuUwTZvS9rv6g=;
        b=pSIPZgDC32UR24Ra/BsR2TlRtn82Si3zn0F610aTuADcexZVrYBLhzCgt4PCDd/d+a
         O14w0sT8+HvOcB0Tj5TIO23nWw8lzdseqcXUA12d9G1cjdHDEpXf31n1amLYMhehPPd5
         9QoE7iXKnKORa/JI2Fr5OOL+h6hje9lcLjfp3Cc7gQPT5enw9WncRYqd7rJmPacNnD2A
         QD/5xUUnM4Zbf40Ak5hN+AC2bu7z60IvCpIPsFz2gXdEK8KbKL57wm4xa+MYjf+d9PyU
         oZDvu+oYtY50nTmfeW+Zgmjs1Q4tm6leLRTaq8OXYfrc4eQak/283Rx+dXvCbvVu5dAd
         5h6A==
X-Gm-Message-State: AJcUukfWqX/GIM0XagWpNDtiMfWVawAN0H1wDZduOMyBcUBF000zV2Oj
        9MmmMu2EQwIiykeLcByPRVWEd9hbIDWOOtEKJ7pLJvtG
X-Google-Smtp-Source: ALg8bN4By2cEHWQyYAPow0L4UHuFNYin4vSa/O9u0vOsfhl6s6sJh9uXCio3NPyaOzm3YK8Vk7MCj72xfSRMr/g97ZM=
X-Received: by 2002:a2e:841:: with SMTP id g1-v6mr14419216ljd.21.1547865824510;
 Fri, 18 Jan 2019 18:43:44 -0800 (PST)
MIME-Version: 1.0
References: <3318002.5e9V1lv8s4@t460-skr> <1980543.jviTh1pdNs@t460-skr>
 <CAJCQCtTErRwS5Omb4Asob3sYx8Svt4yV8V5so7fcs+2BX8t3Gg@mail.gmail.com> <2875582.WnnmDmFHSm@t460-skr>
In-Reply-To: <2875582.WnnmDmFHSm@t460-skr>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 18 Jan 2019 19:43:32 -0700
Message-ID: <CAJCQCtRYrD72Bz0K7-pPRDVXdn9MT0Pa54uVcV4W55sXfih5cg@mail.gmail.com>
Subject: Re: question about creating a raid10
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Stefan K <shadow_7@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 18, 2019 at 12:02 AM Stefan K <shadow_7@gmx.net> wrote:
>
> > Btrfs raid10 really should not be called raid10. It sets up the wrong
> > user expectation entirely. It's more like raid0+1, except even that is
> > deceptive because in theory a legit raid0+1 you can lose multiple
> > drives on one side of the mirror (but not both); but with Btrfs raid10
> > you really can't lose more than one drive. And therefore it does not
> > scale. The probability of downtime increases as drives are added;
> > whereas with a real raid10 downtime doesn't change.
> WTF?! really, so with btrfs raid10 I can't lose more than one drive?

Correct.

>that sucks, that an advantage of raid 10!
> and the crazy thing is, thats not documented, not in the manpage nor btrfs wiki and and thats is very important.
> thats unbelievable ..

Yep. It comes up from time to time, it's discussed in the archives. I
suspect if someone comes up with a btrfs-progs patch to add a warning
note under the block group profiles grid (note 4 perhaps) I suspect
it'd get accepted.

-- 
Chris Murphy
