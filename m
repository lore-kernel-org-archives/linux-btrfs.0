Return-Path: <SRS0=8zrQ=7J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE0E1C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 May 2020 16:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDA8A2088E
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 May 2020 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590597122;
	bh=UFIvmE91KFiiFBrywx4aLAIqJGYYqQb29cFoFkX1C2s=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=oUndENe57IthHsKtrZdK/b3GQgp064Tk2ADMoep1gZK63jAMRFDoruKVRPVFAkwoz
	 F45qcdiGxeubu7V7i8TcTayXLnHKXnwx+jM4m03OjNxf4jerPGvZ5NSEMVIp/5N3ta
	 FCsUK+mjqa8trcaknymh8vPButkHdhAAcUAVJRt8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391203AbgE0QcC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 May 2020 12:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390648AbgE0QcB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 May 2020 12:32:01 -0400
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6D062084C
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2020 16:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590597120;
        bh=UFIvmE91KFiiFBrywx4aLAIqJGYYqQb29cFoFkX1C2s=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=njMwaobh7YWm8OWYrWyIn7b0ZXtePp4nE2YmKGwEhVmIXEqaNFk35PD+Cugkg2A0Z
         +LJaIxtLDe4k+cfSEFLfvdZArMhTlRSFXIXU9w6wLCXWvhjAkJVnG2VSAhonFE4v4v
         ljn+H0QQGqxMoXWGtXeQnDsbz/iAApNFYYJ/CICs=
Received: by mail-vs1-f52.google.com with SMTP id a68so3262596vsd.8
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2020 09:32:00 -0700 (PDT)
X-Gm-Message-State: AOAM533MYgu/dANWBwB88SNg6DAlnEy/Mg2x1Jq68PrREtZpBfN/Pg31
        veR2u3R83HGksqN+Y/MhtS+thYezUER1xqkBT30=
X-Google-Smtp-Source: ABdhPJw7YFuB089wKds6v4ByFqkwxafa4WwIRje+2mDDJwldaCAPSnqrzQcFfnkbAkkDJShmwxShoEBuNg/FZXejrrw=
X-Received: by 2002:a05:6102:242b:: with SMTP id l11mr4848694vsi.14.1590597119815;
 Wed, 27 May 2020 09:31:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200527101553.25396-1-fdmanana@kernel.org> <20200527150159.GJ18421@twin.jikos.cz>
In-Reply-To: <20200527150159.GJ18421@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 27 May 2020 17:31:48 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4LZcnVZnzN3mExTq2r5gyMkHjm_qH0nvPkSPb12yNeUw@mail.gmail.com>
Message-ID: <CAL3q7H4LZcnVZnzN3mExTq2r5gyMkHjm_qH0nvPkSPb12yNeUw@mail.gmail.com>
Subject: Re: [PATCH 1/3] Btrfs: fix wrong file range cleanup after an error
 filling dealloc range
To:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 27, 2020 at 4:02 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Wed, May 27, 2020 at 11:15:53AM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > If an error happens while running dellaloc in COW mode for a range, we can
> > end up calling extent_clear_unlock_delalloc() for a range that goes beyond
> > our range's end offset by 1 byte, which affects 1 extra page. This results
> > in clearing bits and doing page operations (such as a page unlock) outside
> > our target range.
> >
> > Fix that by calling extent_clear_unlock_delalloc() with an inclusive end
> > offset, instead of an exclusive end offset, at cow_file_range().
> >
> > Fixes: a315e68f6e8b30 ("Btrfs: fix invalid attempt to free reserved space on failure to cow range")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> 1-3 added to misc-next, thanks.

So I noticed earlier that in patch 3/3, I mention "generic/061"
instead of "btrfs/061". Would you mind amending the changelog with
just that?

Thanks.
