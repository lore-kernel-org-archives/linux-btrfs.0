Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6100C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 14:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 799C120873
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547475164;
	bh=+GBBwAOUFMwcTlMXimFhgkwQCeO+E+0b3sQrfhk0IdE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=xojl3OHLCBwsJzMZZtJXzCWONjBsNioG0Gbm8HRCwNFUaWuzMZjB10WdCpY74yfyM
	 tqmRRl2SPTQfBvTJhuju2DHiFQW0Qf9KOdo0506MhFN/p6E2wvMm4oBZBrX9V5SbIY
	 PCwlCqR04SQHszPPiRk397mEfbjBX7VgT5djpT2M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfANOMn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:12:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfANOMn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 09:12:43 -0500
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94EAF20873
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 14:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547475162;
        bh=+GBBwAOUFMwcTlMXimFhgkwQCeO+E+0b3sQrfhk0IdE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KeqhLOBQ4VR7Qa+LFh7yuHiO9p/DQoBG/mskPfjR5Q0eF3NxTHIUb3fNDtReI3ub7
         i0sfCqVamaDMbNzr5WHyBZ+nTv58eA6OpzQA67BQswSKPKL5iNQzIHMipZYFKcuoyd
         b9g1z/hiC8lcn2Iq0weXZIUnLXb/vravatVbOQqU=
Received: by mail-ua1-f41.google.com with SMTP id d2so7101937ual.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 06:12:42 -0800 (PST)
X-Gm-Message-State: AJcUukf8aAnW4vX8xcOjgJwq6vUMrlOaUN/MBS6lgbR/G8BKkau6CRuN
        +7lmXRIWHgUZ8rcNWXX1/cVdnt7Q410hyBOLK1Q=
X-Google-Smtp-Source: ALg8bN4rHoZrpu6G5Xn/9HxVogbVDwoJ1zoTA7Kz4UJ4JKymuORBzzDmUXj7qX6ATmPsKF1WKfLTFjzlcVt4kqKg8iQ=
X-Received: by 2002:ab0:621a:: with SMTP id m26mr2865164uao.36.1547475161512;
 Mon, 14 Jan 2019 06:12:41 -0800 (PST)
MIME-Version: 1.0
References: <20190114133024.18320-1-fdmanana@kernel.org> <20190114145944.609d56b6@suse.de>
In-Reply-To: <20190114145944.609d56b6@suse.de>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 14 Jan 2019 14:12:30 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7_cORSt+hY2mTP0Kx+pqaUoiYKfFs=puq9mwbKA7Wgew@mail.gmail.com>
Message-ID: <CAL3q7H7_cORSt+hY2mTP0Kx+pqaUoiYKfFs=puq9mwbKA7Wgew@mail.gmail.com>
Subject: Re: [PATCH 1/3] Btrfs-progs: fix mount point detection due to partial
 prefix match
To:     David Disseldorp <ddiss@suse.de>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 14, 2019 at 1:59 PM David Disseldorp <ddiss@suse.de> wrote:
>
> On Mon, 14 Jan 2019 13:30:24 +0000, fdmanana@kernel.org wrote:
>
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When attempting to find the mount point of a path we can end up returning
> > an incorrect mount point. This happens because we consider a mount point
> > valid for the given path even if it matches only partially the patch.
>
> s/patch/path/? "...even if it only partially matches" might be a bit
> clearer.

Agreed.
David can probably correct that (and your email address from ddis@ to
ddiss@) when he picks the patch, otherwise I can send a new version.
Thanks.

>
> > diff --git a/utils.c b/utils.c
> > index 3a4bc92a..6616630b 100644
> > --- a/utils.c
> > +++ b/utils.c
> > @@ -2064,7 +2064,8 @@ int find_mount_root(const char *path, char **mount_root)
> >
> >       while ((ent = getmntent(mnttab))) {
> >               len = strlen(ent->mnt_dir);
> > -             if (strncmp(ent->mnt_dir, path, len) == 0) {
> > +             if (strncmp(ent->mnt_dir, path, len) == 0 &&
> > +                 (path[len] == '/' || path[len] == '\0')) {
>
> Looks good and works for me.
> Reviewed-by: David Disseldorp <ddiss@suse.de>
