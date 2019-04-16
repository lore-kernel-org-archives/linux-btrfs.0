Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A989C10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44BB3206B6
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:52:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="FSFiREk3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfDPQwY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:52:24 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44636 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728710AbfDPQwY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 12:52:24 -0400
Received: by mail-oi1-f194.google.com with SMTP id i21so17543939oib.11
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 09:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yzroFUTL3qdzXgy0/HOd8rRb5RiTiJrQnHckuVTi0m0=;
        b=FSFiREk3fEXjg/mbFruT9cjPWa80srAsXgLnGsgpKGNYxvPhBQ3HMDNCBrQpUPZVxp
         cHYRXf+M6HVpUR4/HYsVNjvCFfLxt/QLcAbKywd0OIGdf7KdwV50gyi4DfzeLoHux5A/
         NFm9Eo/vYIZr8C9/OhsaUNrvkuepVMPhIyGwxXC4aJL1Cnz8601y1nHTKcFzRYZLDP88
         FD3Uv2y916L8varemjeq2DmuJrxYG/E/ZXulXcPLdZMOtpyiUTII3kfGIiW62Dk3when
         cWkZj3he9bDASj6cat2fQQ8E3OVUUoqDcy/CQbgXSiJSk+x6YWqh866Az8CydE1Ocg9T
         cG5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yzroFUTL3qdzXgy0/HOd8rRb5RiTiJrQnHckuVTi0m0=;
        b=Si8jWz7EBN61UND/N9HRhw5GxxSdR6xQCa4Js7j7rJ3L6cADAdn7efWK22KWoGDd70
         8RmYy84//6714qadqw0Kqdz4zLKR83w11p7EEBh0mtugpDfJ9nIeAnj99pl44Fpk99QT
         91WYp0+QWOPTR69/RBypglUxnwzB263ZUzGlHOgr/waoOqb6Kly16OF94Z4Vbs1cslcf
         k1IvJPs7MjxuSdwTOfeFiLp7kyKWZ7f8Hw5UI2gK4kvPwxKBMQVVKdwyrmXre036loMC
         nYG34m8STLsE0/S1LsP3RQH8Q9x8Dz8ajU/5LT1IsWz/X+XPTaGEII0zoyoNd94rWFLd
         6/VA==
X-Gm-Message-State: APjAAAXD/7nbi9ua7BwlbwrfOcInaRmTVbuK5F7D7yRKTq2o/JKQWUtF
        Np6j8D+k8BwSN5zzuNJtP7ciCgtyLguDUgR8jfqvPw==
X-Google-Smtp-Source: APXvYqxurP6qNuhwJ0pfL1LFK5ePAHfLMiff5uZA1sV7wNqgUoTLMMK6rqw5NV004jzzqUqjg4A4kLJ6yvQ+do+RskY=
X-Received: by 2002:aca:e64f:: with SMTP id d76mr25850764oih.105.1555433543227;
 Tue, 16 Apr 2019 09:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190416164154.30390-1-rgoldwyn@suse.de> <20190416164154.30390-2-rgoldwyn@suse.de>
In-Reply-To: <20190416164154.30390-2-rgoldwyn@suse.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 16 Apr 2019 09:52:12 -0700
Message-ID: <CAPcyv4gJ5A6OyNi2GC1SKfcAW2PGv=WBh7eEK=B2jJFYGNGUxA@mail.gmail.com>
Subject: Re: [PATCH 01/18] btrfs: create a mount option for dax
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, kilobyte@angband.pl,
        Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, nborisov@suse.com,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        david <david@fromorbit.com>, dsterba@suse.cz,
        Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 9:42 AM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> This sets S_DAX in inode->i_flags, which can be used with
> IS_DAX().
>
> The dax option is restricted to non multi-device mounts.
> dax interacts with the device directly instead of using bio, so
> all bio-hooks which we use for multi-device cannot be performed
> here. While regular read/writes could be manipulated with
> RAID0/1, mmap() is still an issue.
>
> Auto-setting free space tree, because dealing with free space
> inode (specifically readpages) is a nightmare.
> Auto-setting nodatasum because we don't get callback for writing
> checksums after mmap()s.
> Deny compression because it does not work with direct I/O.

I'd like to consider the dax mount option deprecated and require new
implementations to use a dynamic scheme that Darrick and I once
discussed where "dax" (or more specifically the MAP_SYNC semantic) is
an attribute that can be set on an empty directory and then inherited
by all files / directories created in that hierarchy.

Dax mappings are not always a performance win and enabling it for all
files in the filesystem is potentially overkill, and I'm of opinion
that we should step away from an filesystem-global mount option.
