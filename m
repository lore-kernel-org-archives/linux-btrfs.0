Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09F7C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 13:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FEC02087E
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 13:01:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eaIiU8pZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfAHNBk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 08:01:40 -0500
Received: from mail-ed1-f44.google.com ([209.85.208.44]:44911 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfAHNBk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 08:01:40 -0500
Received: by mail-ed1-f44.google.com with SMTP id y56so4098043edd.11
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 05:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=daGtYK1EFGhxqB74Te0I1fmQLGkZeYa2VrTY36SALBI=;
        b=eaIiU8pZzJPDi8udZqvFTOoPLIe94Z88V6iPU4Q1+2HaK5fczGLNUz7Te7NaCfVied
         OZ6FijjUvpMdts/N9MfZe0JR93/xL6BLkB/cyHldPyy5RvDjTsRP4Hfb/XBsZ7z/cHJz
         HNeaRqf89VXkxZY/lYSuSTfsvBxr7x/yxcYDC5dHxRcMCGLD+KusT4VJsvfRtm45hqmY
         imPB1A2UyUHhRzVJDckDkjR9iuwtiE/nTuzqUkJtHw27ea2JHj7hSRIy2+L3FWa1NyMZ
         HkOeRVKIJ+xnrxp721BrICg5Rerx2fqNiEyGY2uGIlkerzupD3L+6KmNHHfnO89bcpgZ
         jRsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=daGtYK1EFGhxqB74Te0I1fmQLGkZeYa2VrTY36SALBI=;
        b=oUnljaMlQyr4WxphtS/tQcW7oA36xdP4pmRyLM5R0kJz2q8tGybehgE0mTQjbKPwmd
         bpgZQrHvdblCegvjG4IsOh8Sugth9kAqLQcdsQzOmjfgtQRosRMABKdfC3ATU0BxX8jD
         4T2tSZkS0Q0kW6LzNGCZrXnzdEKEv8oyv2gqW34/A6e/ABQ5kU+t9Ep2xgY1eextiPkJ
         q0paPK0LQwCH8BZaduSfIeRkyy1QpzhxlG1pdtWCubIpFT84ojsN/7F186iik3n69SRv
         dFlpdRZHQsKOqewYK8THH+u7w8iKsFiW3u2bl1zx8V/oqqBDVn+A8/KiNKNyCsv/w0MF
         /TNg==
X-Gm-Message-State: AJcUukcgpBGOxjrU9pys8Yzpqvge3IbqUVSQPREoleUCr34LCJnCsh4T
        WtS3N6t8suiy3VRkvlIdv3dxNqurz3aihlCMcbwKv0Y9jW0=
X-Google-Smtp-Source: ALg8bN5e+FW3EaZG1RbMBRf1l2NEWm3pWIKNstIKR4O6DhuyFw5ACKW6enyaTjFtc0xdpBCdLJzCDOiBmhsYJXEVqzE=
X-Received: by 2002:a17:906:6298:: with SMTP id t24-v6mr1870281ejk.58.1546952498464;
 Tue, 08 Jan 2019 05:01:38 -0800 (PST)
MIME-Version: 1.0
References: <2543962.HIiRWmuHEy@exnet.gdb.it> <3834bc23-03bf-f6e4-dd56-2cf028469a82@suse.com>
 <2282965.574ZSNQ4d8@exnet.gdb.it> <CAL3q7H6XWfo1HwRrV0BDVOhQJ3=8R7qd6qoZAQrTNimEYZFh8A@mail.gmail.com>
 <CAO6aweODMWZrsmBKvZQp0sgjQq4ZaBhJM04jEu7YpSbvvfyjDQ@mail.gmail.com> <CAL3q7H5AXzJfQg=nLPBKL3TWk9Zf1Q5sET5eL+yuF4XzFynr4g@mail.gmail.com>
In-Reply-To: <CAL3q7H5AXzJfQg=nLPBKL3TWk9Zf1Q5sET5eL+yuF4XzFynr4g@mail.gmail.com>
From:   gius db <giusdbg@gmail.com>
Date:   Tue, 8 Jan 2019 14:01:36 +0100
Message-ID: <CAO6aweNSWo2bKdBTZNUFaMpZ2eJ_nz3fJ1HCAiUTo92pAXKSEA@mail.gmail.com>
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can hangs.
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Il giorno mar 8 gen 2019 alle ore 13:29 Filipe Manana
<fdmanana@gmail.com> ha scritto:

]zac[
> > It matches what I seem to have noticed (problem that occurs after a
> > snapshot deletion, occurs randomly due to a race condition, etc..).
> >
> > P.S. I suppose the 4.x.x kernel will not be corrected.
>
> Why do you suppose that?

My mistake, I suppose ( :) ).

> The patch has a tag (see the bottom of the changelog) to signal it
> should be added to stable kernels 4.4+:
>
> CC: stable@vger.kernel.org # 4.4+

I missed it.
Thanks.

Gdb
