Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 149A9C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 00:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C18E02082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 00:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="qH/+5re+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbfAPAl6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 19:41:58 -0500
Received: from mail-lj1-f172.google.com ([209.85.208.172]:40419 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfAPAl6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 19:41:58 -0500
Received: by mail-lj1-f172.google.com with SMTP id n18-v6so3969884lji.7
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 16:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=95at9oLudWEEA0WeHMhGi2bMo06c2u7LR2KN+CMDT7w=;
        b=qH/+5re+QS93RKEbmGAa3S5SvbxHPXergfsyAk5bEq90qyCtb/0qfq1A8f5mVuXHTt
         zhVcwwf7A/AVrrW4NZKyVEmTaswJemymZEfwEEFVap5d0sC8Tm3/zKI4rNdzeX3eIsjK
         0g8MTH5aVwf7LPsJ3ZsMc2xNsV8cloVLMI7LfmDXwqBU3sCckGrOgyz6OTv36beiWsT1
         p3fUVvMJHt8fxWOqBuM0UE0GAWsxkhoZsTAcRI1zToUT5Tkf8xjWAvkgUjyuv4Nr8GWa
         GvhSGz8x+ixl5Pqg4hcgbnSHTjHI6Z1sAtXjLtiXSP9BEdtWUbAPCDCHKFgCh2ckQl/X
         +Rhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=95at9oLudWEEA0WeHMhGi2bMo06c2u7LR2KN+CMDT7w=;
        b=VJhORpY3ePY8GdwpTmr9ecxIvx8QFVYKkCgOt5fvxU9zwU6X6SRmIJyTy8UCVr4g2e
         AaXk5Z9Wx6T7TsZ6MsAJtAbBJepDon53eWx6enprWIlemDBjouh5SaYWEov4tl5/MUzE
         EuEpGkq3AZVfWkXHfIpxYwrRG4umyCLILb8quZk24/NUPDObpNFltRvvatI9pR13QElk
         /uD7rv/bHs5VmkCZl5xo3zljIXYQP4PeoayKTItFbBs0JkuFs5rLXWxEMS1fhAm1EDjX
         aDvRB9t5rjeb4yW1R0MiE9SJt1bZnEvA06aYzjZK8qiJLzDcmtrRdinLYk9qp2uDrQwx
         U4JA==
X-Gm-Message-State: AJcUukcHlu3EKeaiv+OQbPdqVud7huyt5duPtOSCZ7WaH8YDTwb3ZhSd
        Z+/so15i1ILeCQFLqlAnClVxjSTkN/iB25a+TdTFYQ==
X-Google-Smtp-Source: ALg8bN46JCBQiyrsY/lHcYKrCDsq3xrRJfAfEc6q+YlQB8OwDVhMtcn4pYhv+4Be0diBCjf7fvMBuMd/86dBbePd1Fc=
X-Received: by 2002:a2e:841:: with SMTP id g1-v6mr4873248ljd.21.1547599316175;
 Tue, 15 Jan 2019 16:41:56 -0800 (PST)
MIME-Version: 1.0
References: <16012349-e490-6659-8e94-2d4c57c2c3a6@googlemail.com>
In-Reply-To: <16012349-e490-6659-8e94-2d4c57c2c3a6@googlemail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 15 Jan 2019 17:41:43 -0700
Message-ID: <CAJCQCtSFxdRVeEv_G-ka3oenaR2e=HwNJ0ni3Fxn=pV_XDKDyA@mail.gmail.com>
Subject: Re: btrfs goes read-only when btrfs-cleaner runs
To:     Oliver Freyermuth <o.freyermuth@googlemail.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The relevant error messages are:

unable to find ref byte
errno=-2 No such entry

Somehow a reference byte has been corrupted and inserted into multiple
locations in the tree and it's not repairable: i.e. neither a correct
value can be inferred from other available information, nor do the
tools have a good way to just trim out the item that contains bad key
pointers - part of the problem with just cutting out the bad parts is
it's not clear the problem is made even worse or how far the
corruption extends.

What's further troubling though is the idea that this corruption might
have propagated to a separate volume via snapshot send receive. Either
of the file systems might still be useful for a developer, it seems to
me important to have some kind of check to make sure it's not possible
for corruption to propagate in this manner.

In the meantime, I think it's a good idea to do a memory test. There's
some information in the archives about how to do this in a more
reliable way than just memtest86 type tests, but if you can run even a
memtest86 over a weekend it might confirm there's a memory problem.
Unfortunately a pass doesn't necessarily mean there aren't rare
transient problems.


Chris Murphy
