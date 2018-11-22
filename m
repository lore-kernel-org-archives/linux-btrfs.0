Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92115C43610
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 05:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59DD420685
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 05:42:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=etsukata-com.20150623.gappssmtp.com header.i=@etsukata-com.20150623.gappssmtp.com header.b="tQnNdBez"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59DD420685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=etsukata.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392247AbeKVQUq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 11:20:46 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40285 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389359AbeKVQUq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 11:20:46 -0500
Received: by mail-io1-f67.google.com with SMTP id n9so5775279ioh.7
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 21:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DhNxjsaHlE6NkJNsWYsUyJoWSm4jY6YELejwHMW30qU=;
        b=tQnNdBezYxE76WKWU3QZG0bOiy/MbaFde9PyJPtjWH6xhQ41+Cr7lL6VyV/8yMCZs+
         mWaTswiVFapjoKd4OzgB4nQO/VV1cgW6p2CyKMsrBdO66Lpx843rmH+1j4GYOj/l08xc
         8nMbOoUA7WUbl8wmu83wHwtctzYpxRPH8pJ8rTFU42WmunhIBJk/da+EgiiatARPZMm1
         IDTEVqCcVJfVBqTdS+bXdegrsBKvsBX8+FRGihwh1wcqiaVM6EdXnXT4u2O3coqqba3s
         sOjrP6+7d9SrQUl0O2Or1EGeEItVQ47+aTWQiixBtAaRhCHkon4uCmSxRFr8ok5QOY5C
         IBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DhNxjsaHlE6NkJNsWYsUyJoWSm4jY6YELejwHMW30qU=;
        b=ceB3vtTZWoQ42lugl9f6K7ar9ngNB3qJzcxsz7Xbwqj/H8jkduTHYZY8YRYo6vCwLJ
         RU/EaRFNmGPCoc5FGMjidmlNpbKs/v6kz2ziNFUcxee4NXxgVzl7Uss7ElX9vTQB9Uyu
         NdkPTCkEREKvjhaA7A80d8W2D5kkW8lHyxw4crxbDuZxh8XNhcTDV8D0zwbx01bORPVQ
         Oyz7U9QGHxMKrIf9xGApjq+wiWN0NdJQgneEdw0hlva8MjGcF6r0ytitaMpeQTl6bQP5
         P5VW9Gwf+sQ6GSVcY2hWQ+dLAqyws+94f7j8PccHzyNoTHxKgoDSOFlnaDjTMIC5b/dg
         IQ6Q==
X-Gm-Message-State: AA+aEWbwFzj5GiUiwcKDntjb3V9YF5+RQni2ksYGAaB786rEd7prfQ8+
        866wAQPNzWzO6LrvbWz7iANSoIaUQuv3ypeOKzVSmQ==
X-Google-Smtp-Source: AFSGD/Wv7vxjnbaYDMfzsLR6mZSZHsdXEdwwFhxGi9rhcOAL6FaW7DCu2F9+wZ+TL+GhgaOUSm+aSb9TxY50/VCzaio=
X-Received: by 2002:a6b:38c3:: with SMTP id f186mr7129113ioa.186.1542865377265;
 Wed, 21 Nov 2018 21:42:57 -0800 (PST)
MIME-Version: 1.0
References: <20181121024400.4346-1-devel@etsukata.com> <20181121024400.4346-4-devel@etsukata.com>
 <20181121092314.GB10667@infradead.org>
In-Reply-To: <20181121092314.GB10667@infradead.org>
From:   Eiichi Tsukata <devel@etsukata.com>
Date:   Thu, 22 Nov 2018 14:42:41 +0900
Message-ID: <CANhTXPTk0BB7DTSx1uMMRGiBJD+x3qkde_Q6AmqiiY_t3dYTGg@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] f2fs: fix race between llseek SEEK_END and write
To:     hch@infradead.org
Cc:     andi@firstfloor.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

2018=E5=B9=B411=E6=9C=8821=E6=97=A5(=E6=B0=B4) 18:23 Christoph Hellwig <hch=
@infradead.org>:
>
> On Wed, Nov 21, 2018 at 11:43:59AM +0900, Eiichi Tsukata wrote:
> > This patch itself seems to be just a cleanup but with the
> > commit b25bd1d9fd87 ("vfs: fix race between llseek SEEK_END and write")
> > it fixes race.
>
> Please move this patch to the beginning of the series and replace
> the commit log with something like the one below.  Note that your
> commit id is different from the one that will appear once applied
> upstream, so the aboe isn't too helpful.
>
> ---
> f2fs: use generic_file_llseek
>
> f2fs always passes inode->i_sb->s_maxbytes to generic_file_llseek_size,
> and thus should simply use generic_file_llseek.  For now this is a just
> a cleanup, but it will allow f2fs to pick up a race fix in
> generic_file_llseek for free.

Thanks, I'll fix it in v2.
