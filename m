Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10B1C282DE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 08:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8217C20880
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 08:46:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OmnhsIOn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfDHIqr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 04:46:47 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39189 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfDHIqr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2019 04:46:47 -0400
Received: by mail-wm1-f65.google.com with SMTP id n25so13736161wmk.4;
        Mon, 08 Apr 2019 01:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FScztbLxfgAYyDBX6ETQBY9oih7OO35wMO4LBh2mf7g=;
        b=OmnhsIOnjMYeZQSLR7w2oFts6UUI93U1e9Fm//kenmLHQzSBBB6JpuPfiJJfQS8R3g
         bVQA278WhgkUpfv9EKVsOGQguO13qCnnNKeTVCYPfCAPY13SX2tWnIjx/kbJhjGPXV4X
         GtMbM43bkPKDtLJSfSVV4PLRrpzQ2FYXcgqVArDNScg+U8f2BcrHA6H08+SB/mxBChwC
         /0HRSzpT7RfKFhYgomD2eX1eU50TcZNxTeLaAuFajQDUuUZjEZxq7wA9An9UkO35mLbV
         mabYF//FDn2BVN8qJNXAXnpYL7utbua0GPEhcyuFx5ViYq79+kgozPWuf7+aYioPkYwr
         Vphg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FScztbLxfgAYyDBX6ETQBY9oih7OO35wMO4LBh2mf7g=;
        b=OYvveQ4bISAldyViobqNopPRQvX+H9h+7itD1VqIKgThPC7Wlqc8xfvs+kfAfC94hV
         Qu0s4P87rYC5K7UV+Db3A9gZ581hbrBEMwmgB+J4FOjADddWqYB1Rkm6fGgb2gB6F61n
         bgCo+orZYIAu+jOrSUm3qiNMDw6mPg2uKtGAcxVcWS/KCXxJHWv8/2r5LedrOg9ge33E
         0XJt+YKGQxPIGa3hhfNz1sYBp1DFFRwCKAI65p0+soD1F5g4N4xpdK8co4axzpte7jUA
         216aXTHO1JNSHvWiVgUP3nYDg2C+uFPY//MMJ7+g2x6IlfqHz9YTFQtLpm3reDwIFWrT
         dChw==
X-Gm-Message-State: APjAAAVLoeB+nqxF/azWqDFrsA2BWgtoeNcGRFU9VysaJnWWsIp6irBE
        yrB5R0QbSgJfvvawbDR2RFxmlNs8goECMBqSNS0=
X-Google-Smtp-Source: APXvYqzKPICU5V4Ww/fssKJsc2mrwTVsTy4wCUuI4OTUz2v5LQUA9pHVP3WAuabCmfjidQHMCOPZkCsUvqbGf/O7sDQ=
X-Received: by 2002:a1c:658a:: with SMTP id z132mr16788927wmb.92.1554713205322;
 Mon, 08 Apr 2019 01:46:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190407085325.9380-1-ming.lei@redhat.com> <20190408061604.GA26364@lst.de>
 <20190408083333.GA28939@lst.de>
In-Reply-To: <20190408083333.GA28939@lst.de>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Mon, 8 Apr 2019 16:46:33 +0800
Message-ID: <CACVXFVNkTPf1=6JfO4cYhXwZT9Gg2FVeNh4-VJ3bVUwRw21shA@mail.gmail.com>
Subject: Re: [PATCH V2] block: don't use for-inside-for in bio_for_each_segment_all
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Omar Sandoval <osandov@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 8, 2019 at 4:34 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Apr 08, 2019 at 08:16:04AM +0200, Christoph Hellwig wrote:
> > Looks good:
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> Actually..  I just noticed the gratious done rename creates a (trivial)
> conflict in a series I was about to submit for 5.2.  Can you respin
> it without the rename to make everyones life a littler easier?

Yeah, no problem.

You mean the 'done->bvec_done' rename?


Thanks,
Ming Lei
