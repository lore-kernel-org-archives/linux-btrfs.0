Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5092BC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15E4A20663
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:22:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="2HxgPZ4h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15E4A20663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbeK1GVW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:21:22 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39892 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbeK1GVW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:21:22 -0500
Received: by mail-qk1-f193.google.com with SMTP id q70so15310632qkh.6
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 11:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2IJUCeZw3ffra4SI2ZLUF5YtXGbIaJosSR7bknOaPt4=;
        b=2HxgPZ4hZ8igwfx5miSrpgiMlFUUIz8QEZYWGlnpfS2kSUnG7Dt82ocPZ2CSCzGPZW
         mRSAVwqiKIOsO6Foy3WRJJbqnwzAQMiaUHPHCpxaRMZW3tlIPCuKVJ5o/DYUIVtQUcwX
         UwhGP7tiwun8uqDuW4HvgKwO09B3jvCly3MtXiJrKbs0J1DfIxN1HSNZYfSnRlMNthZ5
         ws800/oHUNpRS8X89cNU0XlCwQqWqZt6sUgbsSLHxpmb7Ca9LwacKDt427oSrcct/OmN
         zVdlM3CmLspPx1TqML53hrlMi15Oibv1WmTl5rDsh0RLEFCFr3KcKIo9c4Z7H40uDbc0
         q4LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2IJUCeZw3ffra4SI2ZLUF5YtXGbIaJosSR7bknOaPt4=;
        b=QlPWMXmgHQO4labzYq97Ef3JiUwWeXU0+uTzCTIZ55HDGrCkEP24F9Xz0V3Iaho/CZ
         Ejoen0F/7tuRzn6H79OSHtfD932/wQ7lYAsafp57nrufGasXNP7KT57H76tl8+uR9OBl
         GfTl7GluDe9QyKpZ9rtQL4bn1wA8cLEPobfJMzR6XeAAfsWUnX8kWv57qfILoNX/h8hV
         UU9/nsyMsV7a5py49QCKDuPKFwluLvN+vucRUqen2C28qSish9bqZ1pWsK6dPXuUWSVq
         jPnRdfuY6skVrLn1uGyAMXPp14MT+wR+TUVs00f/z92dzBcToy3LptYVMrftys5mYNir
         QsBQ==
X-Gm-Message-State: AA+aEWZceur30UNP8BG4DOQqVaI3mhMgYxDRq7a79bO0b0/hbh0J8nWv
        IFUVCqvzko4Z+u9YE7X9qPLawg==
X-Google-Smtp-Source: AFSGD/XLOoesZ/KrIWxlpYDY34RtV4tTxXOucWnWCEEJD/5dS2bJfbHgqDiD2ECRWB4N8DhxqaKXAg==
X-Received: by 2002:a37:7003:: with SMTP id l3mr32065046qkc.80.1543346547539;
        Tue, 27 Nov 2018 11:22:27 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:4c40])
        by smtp.gmail.com with ESMTPSA id x5sm3269330qtc.43.2018.11.27.11.22.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 11:22:26 -0800 (PST)
Date:   Tue, 27 Nov 2018 14:22:25 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: only run delayed refs if we're committing
Message-ID: <20181127192224.zozqhtpcuv5j2qcm@macbook-pro-91.dhcp.thefacebook.com>
References: <20181121191016.25224-1-josef@toxicpanda.com>
 <CAL3q7H45FX3VO0h_9u5-M38ObiWaZPgyXezUDT-4rJvx7BUkhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H45FX3VO0h_9u5-M38ObiWaZPgyXezUDT-4rJvx7BUkhw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 23, 2018 at 04:59:32PM +0000, Filipe Manana wrote:
> On Thu, Nov 22, 2018 at 12:35 AM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > I noticed in a giant dbench run that we spent a lot of time on lock
> > contention while running transaction commit.  This is because dbench
> > results in a lot of fsync()'s that do a btrfs_transaction_commit(), and
> > they all run the delayed refs first thing, so they all contend with
> > each other.  This leads to seconds of 0 throughput.  Change this to only
> > run the delayed refs if we're the ones committing the transaction.  This
> > makes the latency go away and we get no more lock contention.
> 
> Can you share the following in the changelog please?
> 
> 1) How did you ran dbench (parameters, config).
> 
> 2) What results did you get before and after this change. So that we all get
>     an idea of how good the impact is.
> 
> While the reduced contention makes all sense and seems valid, I'm not
> sure this is always a win.
> It certainly is when multiple tasks are calling
> btrfs_commit_transaction() simultaneously, but,
> what about when only one does it?
> 
> By running all delayed references inside the critical section of the
> transaction commit
> (state == TRANS_STATE_COMMIT_START), instead of running most of them
> outside/before,
> we will be blocking for a longer a time other tasks calling
> btrfs_start_transaction() (which is used
> a lot - creating files, unlinking files, adding links, etc, and even fsync).
> 
> Won't there by any other types of workload and tests other then dbench
> that can get increased
> latency and/or smaller throughput?
> 
> I find that sort of information useful to have in the changelog. If
> you verified that or you think
> it's irrelevant to measure/consider, it would be great to have it
> mentioned in the changelog
> (and explained).
> 

Yeah I thought about the delayed refs being run in the critical section now,
that's not awesome.  I'll drop this for now, I think just having a mutex around
running delayed refs will be good enough, since we want people who care about
flushing delayed refs to wait around for that to finish happening.  Thanks,

Josef
