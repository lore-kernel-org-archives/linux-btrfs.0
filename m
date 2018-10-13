Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70747C28CF8
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 23:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FBE6204EC
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 23:05:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Bgd289VA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FBE6204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbeJNGoX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 02:44:23 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:45144 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbeJNGoX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 02:44:23 -0400
Received: by mail-lf1-f53.google.com with SMTP id n13-v6so987405lfe.12
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Oct 2018 16:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=P0223hAfS5Gs1g3re12QgX+R1z9SpAfXM5kHAtG38y8=;
        b=Bgd289VAFvaquNUAUbb0dk4Xncsw1+Xv9Qb13yfx2cYNbWrDN7fplC5m+yl7MhEo9g
         5NJoyO6E66z6/w+FZR7keXzCVxo6at1FtJacuEnytr6s6t1eFyTEnlLu1ykTJtaTLJrb
         E8q8hpbCca6PiptO2RZeIIbwacYetrI5GrQxAPqRR5dBTQ0yuIqP8jRiKK266Ibe79fC
         iptDoOXPh5rDrF+s33wVxg1HmbxKpQf2IiXi5AKtnzKaIj08pLij+Be/Yauj8eallYnH
         UmPk9UMHIKlRNbNBPTKlZb8lwntbmHN7uoJtzBdFJ9F6QFHN5zYGqOqrW+pr8sRPRcN6
         Jb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=P0223hAfS5Gs1g3re12QgX+R1z9SpAfXM5kHAtG38y8=;
        b=BhydQHgAJD+eSr5BU+cp0HKebypNemacUENe6mupKAjNDLdthbQSidPCizttAOkRnp
         qx7mYxqaBgpup1YIHFTJIIivpNIMaohpsOrxNuVFfDNE+EpBHCWYEJWXnEoMWZ+flro4
         HPXGkTK6HMsYO5AxuHLAYmhdLhJ1V2FNZ9o0Wxwnjnn4EZwOgk7rADIdDBKfTtzfig5a
         vEoq2hG0I2VuMe+wHWx6MLUxtQLv3LqoyZPZfHBeYQAf1alBOZ9Df2fDbJpMdIvLThIG
         r6CuSv28Zl52dfSMkr+MMV8VWOSNl+AXGcBFajtmhYK01zZRBd84h4aNE7SwczAiUhvT
         C5Tw==
X-Gm-Message-State: ABuFfogsiDR6Cnp/dw62eYrhLLzHd1fxrf0zPXEi5JaEDzdkaole3ybN
        fn6lvIjBJk+YHm9k9FMOlw+jMPrJ3zj6hjdYK/43Pg==
X-Google-Smtp-Source: ACcGV62m/WxZQuYRb/U5PYqQdqrlGAIx8VL31ktQ3HzTLSAkQqVbvPIUYk4FA2F9+I6Ht56OHLhgVwrry4s+7r13hnw=
X-Received: by 2002:a19:e013:: with SMTP id x19-v6mr6491897lfg.89.1539471933312;
 Sat, 13 Oct 2018 16:05:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Sat, 13 Oct 2018 16:05:32
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 13 Oct 2018 17:05:32 -0600
X-Google-Sender-Auth: TTTs9Rs38z4hV8gs-4EGSeslskw
Message-ID: <CAJCQCtT2ackbOo1QPkaj5W+LXnJx5VUMvbxbD0VmcenWz_85pg@mail.gmail.com>
Subject: Re: reproducible builds with btrfs seed feature
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Anand Jain <anand.jain@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Oct 13, 2018 at 4:28 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Is it practical and desirable to make Btrfs based OS installation
> images reproducible? Or is Btrfs simply too complex and
> non-deterministic? [1]
>
> The main three problems with Btrfs right now for reproducibility are:
> a. many objects have uuids other than the volume uuid; and mkfs only
> lets us set the volume uuid
> b. atime, ctime, mtime, otime; and no way to make them all the same
> c. non-deterministic allocation of file extents, compression, inode
> assignment, logical and physical address allocation

d. generation, just pick a consistent default because the entire image
is made with mkfs and then never rw mounted so it's not a problem

> - Possibly disallow subvolumes and snapshots

There's no actual mechanism to do either of these with mkfs, so it's
not a problem. And if a sprout is created, it's fine for newly created
subvolumes to follow the usual behavior of having unique UUID and
incrementing generation. Thing is, the sprout will inherit the seeds
preset chunk uuid, which while it shouldn't cause a problem is a kind
of violation of uuid uniqueness; but ultimately I'm not sure how big
of a problem it is for such uuids to spread.



-- 
Chris Murphy
