Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDA4C4161D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 14:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 801B02087A
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 14:13:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DyZ0NEB9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 801B02087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbeJKVlT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 17:41:19 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34487 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbeJKVlS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 17:41:18 -0400
Received: by mail-yw1-f66.google.com with SMTP id m129-v6so3640677ywc.1;
        Thu, 11 Oct 2018 07:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IS6ccKIlqgz56NTbOK6KEroUPGk3eAo76TebqpEl8Zs=;
        b=DyZ0NEB9RelDcALKPlvZ0lP/aLBPT++tb8mB8A4ZHNviOZhLytH1Xha9tVLfLrfWC5
         /yrShBRigH9rkgeGhZi56JLDN+A3G+NR2+pJs8659uQMrB2L2W4ukB3pyF9Q8zn5Xr2k
         qSlGEojvJxC4KHWEpOpbiIHb6C/4Ho748rqvc9Gt+vJcn+C33jv5uznU4G708p1lHoZB
         W2FzyGuTmaidDjEzl/hOpCezLAaj/RNg9AJr2KWbRzqpQJ/+5oiPEURh49O3tMOOktL1
         SO3uF6rASjwl1FNOyH1iLRILmcJ1Kw2SGk1er1lZ0rscL62rP7sdnCF/WRkBq6/5PNJf
         Q9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IS6ccKIlqgz56NTbOK6KEroUPGk3eAo76TebqpEl8Zs=;
        b=DxpK2wkzVjX4LD34X6q2nTkTKWQuVryf/HWSQ9Vj67bkTE9wP9ISZijzsWPLSrf+wj
         gE/VuOX6f61u6XyYO8qLe0FqMktIFdbUijFvx4yIhpNbBxa02hEHPgt3Ov3gW1Sfv9Fc
         23luxHMCu0TxQOKQ/cfhqTx50IHf8oj4SIs9t07e6yapKfHQrFAX4NdRlG4kJCEsonWp
         kbUKRgedgPfg+fC/b1w/hjFQUjXpuE1/c8JH2OH1O5b4OcNMdpSlh7TJo6ZfhDiici5f
         roTURqRDhdVYP0veD5D0ghOQ5cLC7Fhk5ESTPZbxm8KLIVxR/fyxsJA0zXbwKBfs0HZB
         LJEg==
X-Gm-Message-State: ABuFfoiACpRCtrKlsbg94MdL8fIixITb3A43XLYMb+Nd7mMJuHk69TfD
        5Rz8GbEy26U1np06xvtkedsyc3OdNTIsiWYKBaI3vT7pw+A=
X-Google-Smtp-Source: ACcGV63l23acLEN0THTEsqU5qybG+paMIiUbbLDnomDdy2IRelAll7dK5BiGDhHtk8u63fBtfm9+D8DE2POM2QfEEgg=
X-Received: by 2002:a81:6505:: with SMTP id z5-v6mr929417ywb.34.1539267235921;
 Thu, 11 Oct 2018 07:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923115968.5546.9927577186377570573.stgit@magnolia> <20181011134256.GC23424@infradead.org>
In-Reply-To: <20181011134256.GC23424@infradead.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 11 Oct 2018 17:13:44 +0300
Message-ID: <CAOQ4uxiavoysJQEUEaMXb+mnZWhPT5kvmK6WZav9tbiJxara5A@mail.gmail.com>
Subject: Re: [PATCH 03/25] vfs: check file ranges before cloning files
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 4:43 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> > -EXPORT_SYMBOL(vfs_clone_file_prep_inodes);
> > +EXPORT_SYMBOL(vfs_clone_file_prep);
>
> Btw, why isn't this EXPORT_SYMBOL_GPL?  It is rather Linux internal
> code, including some that I wrote which you lifted into the core
> in "vfs: refactor clone/dedupe_file_range common functions".

Because Al will shot down any attempt of those in vfs code:
https://lkml.org/lkml/2018/6/10/4

Thanks,
Amir.
