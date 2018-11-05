Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3C0C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 451222085A
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:30:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="cp6E19Ck"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 451222085A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbeKFBvQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 20:51:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387420AbeKFBvQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 20:51:16 -0500
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 294792085A
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Nov 2018 16:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541435448;
        bh=vG+urKQ7BTZxcIM9mVxS7WGsfYSxbxkEwDmYrYFvCvo=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=cp6E19CkoH+TyKQEMF0aa7ZtdFxCQq2aNBGGlgveRGG7CXm3JqHehNB1H+eo7NQjV
         hK802WDKUVeOFPhlmO1C8w8VqTaL4JMS/GkETTQTnTWAFsqub20uYtvdkYIpaNhqBa
         R3/Isk03KPxcyUxhXQ0rL0pAoYNbGx96XquENyWg=
Received: by mail-vs1-f54.google.com with SMTP id p74so5481113vsc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2018 08:30:48 -0800 (PST)
X-Gm-Message-State: AGRZ1gJso6WeLvpLkznSe8c5t2cT7F7IjcHFpESD6tp6jX7cNkou0PGP
        twlGPyR8AxPwf043L3qHJ0pPH6olXkROslaJdo0=
X-Google-Smtp-Source: AJdET5f1n5maVZTBZ+jXy7IcD+NxKBIjP/UFEWVd1Sgqtnss+BSSdk5lBqSiodAbk9Pgq3t7Ia95GqPfivSuyhSxgHY=
X-Received: by 2002:a67:8a88:: with SMTP id m130mr9611177vsd.206.1541435447057;
 Mon, 05 Nov 2018 08:30:47 -0800 (PST)
MIME-Version: 1.0
References: <20181022090946.1150-1-fdmanana@kernel.org> <20181024091303.20324-1-fdmanana@kernel.org>
 <20181024113717.fcz4klha7isb7r56@MacBook-Pro-91.local> <CAL3q7H5_1T9doxVu-GRCU9-uZVi5q=yw+K+YVqK-As+fJbT6nQ@mail.gmail.com>
 <20181024123959.icp7ssu5sjhqg6c3@MacBook-Pro-91.local> <CAL3q7H7dZm8s2Ey185Xw=bsjG6fZBeEWjQu+He2kQ5JYMPCHWg@mail.gmail.com>
 <20181105162849.GA9136@twin.jikos.cz>
In-Reply-To: <20181105162849.GA9136@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 5 Nov 2018 16:30:35 +0000
X-Gmail-Original-Message-ID: <CAL3q7H45e7B9acpDnx-R5hNxu+033Tfx4yD_ynZ_cY3hPfLryg@mail.gmail.com>
Message-ID: <CAL3q7H45e7B9acpDnx-R5hNxu+033Tfx4yD_ynZ_cY3hPfLryg@mail.gmail.com>
Subject: Re: [PATCH v4] Btrfs: fix deadlock on tree root leaf when finding
 free extent
To:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 5, 2018 at 4:29 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Wed, Oct 24, 2018 at 01:48:40PM +0100, Filipe Manana wrote:
> > > Ah ok makes sense.  Well in that case lets just make btrfs_read_locked_inode()
> > > take a path, and allocate it in btrfs_iget, that'll remove the ugly
> > >
> > > if (path != in_path)
> >
> > You mean the following on top of v4:
> >
> > https://friendpaste.com/6XrGXb5p0RSJGixUFYouHg
> >
> > Not much different, just saves one such if statement. I'm ok with that.
>
> Now in misc-next with v4 and the friendpaste incremental as
>
> https://github.com/kdave/btrfs-devel/commit/efcfd6c87d28b3aa9bcba52d7c1e1fc79a2dad69

Please don't add the incremental. It's buggy. It was meant to figure
out what Josef was saying. That's why I haven't sent a V5.
