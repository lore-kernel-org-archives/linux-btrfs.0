Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C0CC10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 18:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA7192146F
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 18:01:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eIHUkUeU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfDKSBa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 14:01:30 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:40291 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfDKSB2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 14:01:28 -0400
Received: by mail-vk1-f195.google.com with SMTP id l17so1575628vke.7
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Apr 2019 11:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=ilGUW6i57xy8c5Kd23VpUji1q18gTUUB3chrO4JWhLE=;
        b=eIHUkUeU4KfsQ39oVPdSGerpgfCBEXM7/O4WeR4R2VE6Jab9NOz1u0TKcP3ScQkXAv
         GI90VJIzkMyZkH3D2Yf20HISy99s8NLze6JFQFywqTPDtrw51aaZ8PWQaWmynja+lOZF
         P9C3RAgFnFvXB0yS6XJvQcHU+7qPdWThipg96WCG+kIY4ApOaK4sLY3kMMdytu5tF/0D
         gYLzUfergt7zH4I5RWLJ4QQv3SPVN13vJqRcPJQoekQB+1UuCBXaFpaxN82q+xR2R0oL
         8kRDzDFyGDkNvaCsOMQeq59Fre2fLc27MyNd/n0M9HM3GjIQiTHUdYpfCTAGgXUlyQ+/
         x6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=ilGUW6i57xy8c5Kd23VpUji1q18gTUUB3chrO4JWhLE=;
        b=DYhwf8W8v9zPBiEOtXTSb0qLgrZKjhBIQy4y7L8bVQoAkGNn+lG8l4+0xSWwTY0LOV
         6kdhwOXb4FYpfxNyC/Hm8xT7Xmznaxk6e68ZN8Hu1gtENJ+uYA1Ce7ICxGglodUkONtz
         uDWVO4DTiFnU2SLNSwj0RQq2VkEUzhwXsOS/tp5mS4TuI8CyvXC7QocefeSNSxNNbpXd
         VjjiUsyt38zAhzgzQXzXTlDAWaIZBLVSSYds5SB+a8ja7fzvnqPCmbSs0aHevpK3bZJj
         lubo71q+i9MpxM4Zul8slr1Rmt7V7SfecYbbOPBvKrM5n1hVsUcD+Reoc+GLzP+WtEXn
         Hwdg==
X-Gm-Message-State: APjAAAXUdMVM6p3FYnT5LboQj0KJC9Xye9etpoJ3SMDZMuXJLQUddPvc
        0DxWhqUu2bPgj3f0X0STfqN6iF8qnyvWSbcyS9o=
X-Google-Smtp-Source: APXvYqyER/SsKsVlSq6V5aUh+ZECIGJgTvcABBBpMSihVCXy/5iZj5rKnMvKV5c3UQxPQPNXCsE53WwCFG7y9N97CHk=
X-Received: by 2002:a1f:97ce:: with SMTP id z197mr17792652vkd.58.1555005687151;
 Thu, 11 Apr 2019 11:01:27 -0700 (PDT)
MIME-Version: 1.0
References: <1553572571-15614-1-git-send-email-robbieko@synology.com> <20190411175244.GB3476@twin.jikos.cz>
In-Reply-To: <20190411175244.GB3476@twin.jikos.cz>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 11 Apr 2019 18:01:16 +0000
Message-ID: <CAL3q7H53ZcxVqX80SEtY_=r9WBgm--RgYamP6q9n-sW073qr0Q@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix data bytes_may_use underflow with fallocate
 due to failed quota reserve
To:     dsterba@suse.cz, robbieko <robbieko@synology.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 11, 2019 at 6:53 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Tue, Mar 26, 2019 at 11:56:11AM +0800, robbieko wrote:
> > From: Robbie Ko <robbieko@synology.com>
> >
> > When doing fallocate, we first add the range to the reserve_list
> > and then reserve the quota.
> > If quota reservation fails, we'll release all reserved parts of
> > reserve_list.
> > However, cur_offset is not updated to indicate that this
> > range is already been inserted into the list.
> > Therefore, the same range is freed twice.
> > Once at list_for_each_entry loop, and once at the end of the
> > function.
> > This will result in WARN_ON on bytes_may_use when we free the
> > remaining space.
> >
> > At the end, under the 'out' label we have a call to:
> >    btrfs_free_reserved_data_space(inode, data_reserved, alloc_start,
> > alloc_end - cur_offset);
> > The start offset, third argument, should be cur_offset.
> > Everything from alloc_start to cur_offset was freed by the
> > list_for_each_entry_safe_loop.
> >
> > Fixes: 18513091af94 ("btrfs: update btrfs_space_info's bytes_may_use ti=
mely")
> > Signed-off-by: Robbie Ko <robbieko@synology.com>
>
> I see this error:
>
> generic/102             [02:15:05]
>
> [ 7731.223975] run fstests generic/102 at 2019-04-09 02:15:05
> [ 7731.355111] BTRFS info (device vda): disk space caching is enabled
> [ 7731.358367] BTRFS info (device vda): has skinny extents
> [ 7731.407393] BTRFS: device fsid 99c22651-33bd-4543-96df-da02cc320166 de=
vid 1 transid 5 /dev/vdb
> [ 7731.419081] BTRFS info (device vdb): disk space caching is enabled
> [ 7731.420671] BTRFS info (device vdb): has skinny extents
> [ 7731.421955] BTRFS info (device vdb): flagging fs with big metadata fea=
ture
> [ 7731.426107] BTRFS info (device vdb): checking UUID tree
> [ 7865.389231] BTRFS info (device vdb): disk space caching is enabled
> [ 7865.393289] BTRFS info (device vdb): has skinny extents
>  [02:17:19]- output mismatch (see /tmp/fstests/results//generic/102.out.b=
ad)
>     --- tests/generic/102.out   2018-10-08 09:51:53.890556726 +0000
>     +++ /tmp/fstests/results//generic/102.out.bad       2019-04-09 02:17:=
19.460000000 +0000
>     @@ -1,7 +1,7 @@
>      QA output created by 102
>      wrote 838860800/838860800 bytes at offset 0
>      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>     -wrote 838860800/838860800 bytes at offset 0
>     +wrote 109707264/838860800 bytes at offset 0
>      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>      wrote 838860800/838860800 bytes at offset 0
>     ...
>     (Run 'diff -u /tmp/fstests/tests/generic/102.out /tmp/fstests/results=
//generic/102.out.bad'  to see the entire diff)

Unrelated to this patch.
The test fails often for at least a few kernel releases now.

The test does not even exercises fallocate() at all...

>
> This is with current misc-next, with 2 other patches to tree-checker
> that are unrelated. I've run fstests twice to be sure that it's not some
> random fluke, it happened in both cases.
>
> Running with with one patch below the test passes so I'm reasonably sure
> it's happening due to your patch.
>
> For reference:
>
> - misc-next top commit fbcee956b888abbcbfed295a2191b1d0eccb0f09
>   (reproduced twice)
>
> - one below your patch c8d27001b9067085bd62adf5fdf7cc8a53bd2f7f
>   (not reproduced)



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
