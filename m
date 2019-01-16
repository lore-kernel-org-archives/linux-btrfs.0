Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48315C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13BD120651
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:38:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="rPUG+O7S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfAPBis (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 20:38:48 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46928 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbfAPBir (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 20:38:47 -0500
Received: by mail-lj1-f195.google.com with SMTP id v15-v6so3999463ljh.13
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 17:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=WzAWCQZOKt17mCBs4ZQ7nWd83W/EZcI6rk/xchM/FEU=;
        b=rPUG+O7SNPqe9xju7FlCWUPq3XXV5EjuKTjwuAc7FmsyNcY7sZOhJr8qKW+odkyTkX
         AMSs+J9p3jrXW1J4NnY/dTvh12x55t679f6d+t2CF0tG8dAXKwtUskKxFJNfg5XUVw/r
         iQFiO3X7CcbCDorx057h4gX5TnZEfaXiNa4tdX/uHhqxbOFODWpX6ngBGXhe89+G97VF
         bGJRuBEpBy4jTSoPGCQRluOCyklIEJSwgxzREH0QHFrPNbktAODiOus9PZW+1StyBNb1
         dDfWSZ4jnZnRzEDvgwou6hYWqNZ3o56/Whr8sErK+93E62DIQLS5T87MxbPHIknGqJSx
         U51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=WzAWCQZOKt17mCBs4ZQ7nWd83W/EZcI6rk/xchM/FEU=;
        b=bkDLr2bTY5gQO+Secr6bvc7Duj7wOj/IWh6/RrctLcvCJaEksZBWaRVKcgy8z875Dz
         5gGj1fnGwkVTZ7T1dcgb8AxP+o4Zb6Q2ZKy4gYGt28lWlX9uSMYQuDWiP0edsmapdHS0
         Fh9usTvawwjvNMVFFZtO5euRRbrqRZXgpFc1Jc6JpB8KfjxYYSvr5qI0Uu3kcTp+cj9b
         WL0vnXqTe2/eQYYYy7azT2Tdg7rhFwgbglR7o63ssecFfyuyTV19BtnY+7hZoV6Y4vbA
         BaSQeO6TZiXvYIAl7SfWqaxiuzE/fm7WjwbMnVR/QZGRE2Scv06IGRgAd3a+i7xWnZqz
         KEtQ==
X-Gm-Message-State: AJcUukemzdUM8Nysi+JTzujJm0qJEvhn6TgyoBo/E9QreIwKapY3krML
        yrefoDFblaOSbrtQ/WhTqqxDGnFjnIImt+MFgT/HRA==
X-Google-Smtp-Source: ALg8bN7exMSFr/sRHxq0zZE1pNvU/U5VKtuLUOf2UvgNEHrKYtXiHzALSvXNOkzBw5/lZdI92JjKo+hflKYZybf0hec=
X-Received: by 2002:a2e:841:: with SMTP id g1-v6mr4996425ljd.21.1547602725201;
 Tue, 15 Jan 2019 17:38:45 -0800 (PST)
MIME-Version: 1.0
References: <87d0oyw46b.fsf@lausen.nl> <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
 <20190115120359.GG2900@twin.jikos.cz>
In-Reply-To: <20190115120359.GG2900@twin.jikos.cz>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 15 Jan 2019 18:38:33 -0700
Message-ID: <CAJCQCtQCwGzuoTc5ZaE-EsbrhjT3yXQ=GKSdjr2ywT375=C_nA@mail.gmail.com>
Subject: Re: BTRFS critical corrupt leaf bad key order
To:     David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 15, 2019 at 5:04 AM David Sterba <dsterba@suse.cz> wrote:
>
> On Tue, Jan 15, 2019 at 07:48:47PM +0800, Qu Wenruo wrote:
> > Super nice move, it shows the corruption and the cause.
> >
> >       item 66 key (1714119835648 METADATA_ITEM 0) itemoff 13325 itemsize 33
> >       item 67 key (10510212874240 METADATA_ITEM 0) itemoff 13283 itemsize 42
> >       item 68 key (1714119868416 METADATA_ITEM 0) itemoff 13250 itemsize 33
>
> The key order is the most frequent and also very reliable report of the
> memory bitlips. I think we should add an unconditional check before a
> leaf or node is written so we catch such errors before the bad data hit
> the disk.
>
> This seems to happen way too often, I believe the check overhead would
> be acceptable and at least give early warning.

What about out of tree or proprietary modules tainting the kernel? Or
other corruptions we see that aren't key order related, like the
several recent "unable to find ref byte" reports? Are these memory
corruption related, or are they non-Btrfs bugs causing such
corruption? Does it make any sense for users who are running
proprietary or out of tree kernels to run with slub_debug=F or even
FZP and possibly get a better idea what category the corruption is in?

I guess what I'm getting at is, users get a corrupt file system, they
can't repair it (honestly the tools are not good enough, and aren't
user friendly), so we tell them OK just start over with a new file
system. It would be better if there's some additional advice to give
them to try and find out what caused the corruption to begin with,
rather than just start over and maybe run into the same problem again.


-- 
Chris Murphy
