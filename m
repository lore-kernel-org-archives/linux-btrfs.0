Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A28FC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 18:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23B4E2081C
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 18:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="FmkpcPk1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23B4E2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbeLDSSL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 13:18:11 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43062 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbeLDSSL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 13:18:11 -0500
Received: by mail-yw1-f66.google.com with SMTP id l200so7350749ywe.10
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Dec 2018 10:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=B2JVSXQQzENsx7hRGUg1fHVBn2HhJ+ye77/PA5a1wLU=;
        b=FmkpcPk1H/ITJ31s4jqMDoJsg8L6Aw8hSG6i4d7SM6I11WdCmy8kfwvznTMmPUpAWg
         y+iDfdQyn8jGExQ5YVcCbWUDjLeLP8sOIrnAA/XtkIe1Eii1CX68rjlELQQhx0cojStR
         A6p0LJgcEJTwjG+0J3FnK3PrH5jEC8dQc9gp5rZbm+gkydGuYkHd+PJzRp7PSbFEnSy9
         YMvf4Ei9QiyaD/NNYD2c9/IwlLajHE7nUGgvUQ3fhNaAoJkPzkAIIycQzw5Y0XtMFNGC
         o0xnKgI5rkZFGev01Q4g5kHJGuXRow7ub2S5h7l6ZqJkxhHeK3yDO+SiWTp9forG2qRl
         vy9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=B2JVSXQQzENsx7hRGUg1fHVBn2HhJ+ye77/PA5a1wLU=;
        b=MO0gxbfRKszAcbTDcKoBXYGc6aso/1dTCfRL7COAMB6xvNt4gw5lV7X7UCB3MAR6uc
         ja+iuYcqLVHp2rD6mg4q4SFM14xYXliBbp7Pra+BGr15nxZ2MN3bTJAT6mS2uCaLQvpN
         PSSzRrA3gmjEhlzPrZzT6AtuIgq922C6po2QpbngBoLqfGbDboGzADA7XW5vKaf54gXY
         a5iLra1T6QOu2Rn1btP0P7lfXl76H4VZSBuD7HhD1inrj2bM6wMQXQ9Ps2kJ1JaJUJH7
         aggyS+HDsZohH2El9tjhWKgw6EKunuKHwQ9e/9r6yOTx3sU4/7UXCO5zuVfb0RX3+Doz
         RxUA==
X-Gm-Message-State: AA+aEWaDEH4kwsItSJAoR0yiOPhl9KCeFRNFWxdIpDLuu9r/T0sCYEW6
        PB12ce7TE2XyRa29nCCmbm9WHYehRJA=
X-Google-Smtp-Source: AFSGD/UYVC742X4R7pIpZpUnW/0KbUmXFJHXRqGsSTkWNNJ7aGje/HTOWeTIJSCIWMvBy33l0vc1qA==
X-Received: by 2002:a81:ad26:: with SMTP id l38mr20759741ywh.439.1543947490697;
        Tue, 04 Dec 2018 10:18:10 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id x1sm5645053ywf.94.2018.12.04.10.18.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Dec 2018 10:18:10 -0800 (PST)
Date:   Tue, 4 Dec 2018 13:18:08 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed iput
Message-ID: <20181204181807.e4w5ebs4p2vv47kh@MacBook-Pro-91.local>
References: <20181203160652.25078-1-josef@toxicpanda.com>
 <20181203160652.25078-3-josef@toxicpanda.com>
 <410f70ed-232b-5e1d-1368-0adf9f180b48@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <410f70ed-232b-5e1d-1368-0adf9f180b48@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 04, 2018 at 11:21:14AM +0200, Nikolay Borisov wrote:
> 
> 
> On 3.12.18 г. 18:06 ч., Josef Bacik wrote:
> > The cleaner thread usually takes care of delayed iputs, with the
> > exception of the btrfs_end_transaction_throttle path.  The cleaner
> > thread only gets woken up every 30 seconds, so instead wake it up to do
> > it's work so that we can free up that space as quickly as possible.
> 
> This description misses any rationale whatsoever about why the cleaner
> needs to be woken up more frequently than 30 seconds (and IMO this is
> the most important question that needs answering).
> 

Yeah I'll add that.

> Also have you done any measurements of the number of processed delayed
> inodes with this change. Given the behavior you so desire why not just
> make delayed iputs to be run via schedule_work on the global workqueue
> and be done with it? I'm sure the latency will be better than the
> current 30 seconds one :)

We already have the cleaner thread to do this work, and it sets up for the
snapshot drop stuff to be run as well.  We could probably add another delayed
work thing, but I would rather do that in a different patch.  Thanks,

Josef
