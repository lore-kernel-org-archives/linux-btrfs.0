Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E34FC65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 21:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A94A20839
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 21:02:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="ywUlhG+L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A94A20839
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbeLLVCH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 16:02:07 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:37104 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbeLLVCH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 16:02:07 -0500
Received: by mail-lj1-f171.google.com with SMTP id e5-v6so17567116lja.4
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 13:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LQAK9jFt7bzK0c7cWjU1X0nyReRhyAy+VZFXVwFYZCY=;
        b=ywUlhG+LJMkobtz2KjJ+q7iEfG/bNKYgUSUXBSwfG4jHMF6mgE5BXy7+B6CfT90Moy
         ej1sSC/xlLZZa7mHT2yfRwLFLMlrmx4YlW1lDKgNg/VmUHtMg+5EIYjzlBg4TXqRmye+
         uBuV7YLhT+KizpEV8zT/yyzyiuxPyoiKYokt/CaMcsEqCj/TPYTuRtFF5KCE5sNTJlSS
         HdFIEehxnTDUR2HvudHlK7jXVFEAMha011WNLCItxDT/qbPjHkBYGfY4BW7QWScpwyPy
         /pG6UUZFxY+VNt2f8QhO31ULj7eBbBClSBQqdxLq6+oaVq2H/kEilYiaRMJVfvfblqM6
         idUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LQAK9jFt7bzK0c7cWjU1X0nyReRhyAy+VZFXVwFYZCY=;
        b=tZABTKoxU/KvSXJAsNr0oVcMa+5njBRuo55w3RObHInm5EBY3Da5CV362KnqOWffOY
         mZuobXtfiQX3zp43+W22+/gSfMBe2ooEwVj8tctFwTO9GQXbD5lQtfaDnacIVarTPjLa
         kQkmCB6NkcKnSw5KDTTAi+w8CdBiuSaZxLt3WS9CH6HAKM+X3lz59p1tduDgqH2pz85J
         /iemM4uwoyuv3dMLU1tKIPrvSMKIzNs4IWjESFGsJk1uRXKIc4mxLgJSwFWhY1iu4W+1
         NCl+WzNOhXrRE2WISZHVPIxZ7dN8jYkOC+rwkeB939O9xFXRP/uGPNOuvOgLSPKNuQLb
         v7Dg==
X-Gm-Message-State: AA+aEWZPGl7SoxbkHN0K+vGTohJwWEK0EYoMNCWd1TEFIo6CtMKmkcJ6
        /pVY9+IfDRlHqDWHvkW2DnTGiLSrzxRzcTEzc0dk/uDg
X-Google-Smtp-Source: AFSGD/WO6JPqjr+RHMn43zccPED0N2jrYD/10eOd2VhxEwwkbW7aNyUYI3hrwpV4WPiPiSVUkSnwzbpPQH1uu7C2Gcs=
X-Received: by 2002:a2e:880a:: with SMTP id x10-v6mr14557671ljh.174.1544648524626;
 Wed, 12 Dec 2018 13:02:04 -0800 (PST)
MIME-Version: 1.0
References: <20181210120514.GA14828@cuci.nl> <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
 <20181211115226.GA20157@cuci.nl> <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
In-Reply-To: <20181212072614.GA9188@cuci.nl>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 12 Dec 2018 14:01:52 -0700
Message-ID: <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
Subject: Re: Kernel traces
To:     "Stephen R. van den Berg" <srb@cuci.nl>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 12:26 AM Stephen R. van den Berg <srb@cuci.nl> wrote:
>
> Chris Murphy wrote:
> >Also, what scheduler are you using? And do you get different results
> >with a different one (better or worse)?
>
> I'm using CFQ, and I don't think I ever tried a different one.
> But, btrfs should be compatible with all schedulers.

Sure but there are some workloads we know where CFQ can cause or
exacerbate problems with some storage stacks, and other schedulers
exist to deal with those workloads better. So the question is whether
the problem is made worse or better by trying another scheduler. It
might have no effect. And it might just flat out be a Btrfs bug, but
I'm doing send and receive on far more meager hardware with much less
RAM and haven't run into problems.

But yeah, one of the developers might have more to say about it once
sysrq+w output is available, which should expose what's stuck or busy.


-- 
Chris Murphy
