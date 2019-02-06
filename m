Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD30C169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 14:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E15320844
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 14:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="qlJQdnZg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfBFO03 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 09:26:29 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35350 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfBFO03 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2019 09:26:29 -0500
Received: by mail-pg1-f196.google.com with SMTP id s198so2963504pgs.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2019 06:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7teqC4jF23iWU75y8Hv96ZnFrGD8heMEDeJ77FPh+gU=;
        b=qlJQdnZgObYXUZAKzw5lwcM38+ZwEefOl2ubUyxGSS9YfkplOur3H6feDHcAo8hlu6
         cjP9CmNKu5qE8iNBxmJwXtqx0mBVy1YYCtrCroNKolcUZ2ZqBdICS1EPC8cmbAyaK4JM
         AEBwmqa579yXoQhKpKcMv2u5zjumUbprHM3DZ9ZPSzt52EY/SXMySQKpZJcqTQUgJvjQ
         EHQKXCVxtuzahTz8FGKpijEkxNbWTLNT7ygT5QkO2b51PJUFdEn/MzFQs3f/dvx7Zl7y
         8GZjLNOPXQg7c2GD2c9aOGbLLO8qV33cYcn5jJzicvEg54kUDoVlUkAaw5+z6bCMTLYr
         sUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7teqC4jF23iWU75y8Hv96ZnFrGD8heMEDeJ77FPh+gU=;
        b=JJrgkRndECeOBqNctuEKVk32Orzu0XbxjMUrwH/Qy9ryrYTaZUWXaT6rQx8p3vnTwP
         UWjtCzdbKd06zUmKghnWZVcIK+MGnK/wSZB4QFsdvmhjPOBk2Ae2xOEjPyOkvjmaa7SX
         Bu/DZuqSWsbZHRrIMxVxcETcEES8atlufQw7qNPGP8G/9287yGOEMgcyiTNiMsjLsc6b
         xxbj2Mi6eCFiD5G4tRaGpz3cjIute6/BAs0Kqw7g1J7iivmqNsMLu5EJSFrkEzWTjF4s
         XOnQkaGR3bcC4OjsuGtszZ6KNZIYoU6KoAghnDjKDlsYBxYUP1c8sS8XdYD1ZLUeUFeE
         ywDA==
X-Gm-Message-State: AHQUAuZFqopHhSc6WstmnOJ7OJBbZammt28G+n3xMHz8BnUSB2Jfd87I
        Aw2+yaoP7GJH12PEer6PN9HO/6C0LjIRtcFAdo1dTQ==
X-Google-Smtp-Source: AHgI3Ibo5KPHo0+6wia6jvqEBhtdoZ9YO9z94SUgSZzFbbhfv3c0w5zy8iFQZay16byt8TgizPDCLeoHzyARyqsubCk=
X-Received: by 2002:a63:6f0d:: with SMTP id k13mr9829763pgc.42.1549463188209;
 Wed, 06 Feb 2019 06:26:28 -0800 (PST)
MIME-Version: 1.0
References: <1534346817-9108-1-git-send-email-nborisov@suse.com> <20181106143024.GC24115@twin.jikos.cz>
In-Reply-To: <20181106143024.GC24115@twin.jikos.cz>
From:   Alex Lyakas <alex@zadara.com>
Date:   Wed, 6 Feb 2019 16:26:15 +0200
Message-ID: <CAOcd+r3CzY2w94Y--9Nb+Fawv_JGFLnK3AgZdYWjNOsKth_aeQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] eb reference count cleanups
To:     David Sterba <dsterba@suse.cz>, Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, robbieko@synology.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Nikolay, David,

Isn't patch 5 (btrfs: Remove extra reference count bumps in
btrfs_compare_trees) fixing a memory leak, and hence should be tagged
as "stable"? I am specifically interested in 4.14.x.

The comment says "remove redundant calls to extent_buffer_get since
they don't really add any value". But with the extra ref-count, the
extent buffer will not be properly freed and will cause a memory leak,
won't it?

Thanks,
Alex.



On Tue, Nov 6, 2018 at 4:30 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Wed, Aug 15, 2018 at 06:26:50PM +0300, Nikolay Borisov wrote:
> > Here is a series which simplifies the way eb are used in EXTENT_BUFFER_UNMAPPED
> > context. The end goal was to remove the special "if we have ref count of 2 and
> > EXTENT_BUFFER_UNMAPPED flag then act as if this is the last ref and free the
> > buffer" case. To enable this the first 6 patches modify call sites which
> > needlessly bump the reference count.
> >
> > Patch 1 & 2 remove some btree locking when we are operating on unmapped extent
> > buffers. Each patch's changelog explains why this is safe to do .
> >
> > Patch 3,4,5 and 6 remove redundant calls to extent_buffer_get since they don't
> > really add any value. In all 3 cases having a reference count of 1 is sufficient
> > for the eb to be freed via btrfs_release_path.
> >
> > Patch 7 removes the special handling of EXTENT_BUFFER_UNMAPPED flag in
> > free_extent_buffer. Also adjust the selftest code to account for this change
> > by calling one extra time free_extent_buffer. Also document which references
> > are being dropped. All in all this shouldn't have any functional bearing.
> >
> > This was tested with multiple full xfstest runs as well as unloading the btrfs
> > module after each one to trigger the leak check and ensure no eb's are leaked.
> > I've also run it through btrfs' selftests multiple times with no problems.
> >
> > With this set applied EXTENT_BUFFER_UNMAPPED seems to be relevant only for
> > selftest which leads me to believe it can be removed altogether. I will
> > investigate this next but in the meantime this series should be good to go.
>
> Besides the 8/7 patch, the rest was in for-next for a long time so I'm
> merging that to misc-next, targeting 4.21. I'll do one last pass
> thhrough fstests with the full set and then upddate and push the branch
> so there might be some delay before it appears in the public repo.
> Thanks for the cleanup.
