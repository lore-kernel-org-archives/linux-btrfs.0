Return-Path: <SRS0=h89n=3F=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3D9C33CB6
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58684207FF
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579191419;
	bh=UQGRvJy+7JZ//PovsjBJ7LchKK481IsY6KERgIx38Go=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=l4WIVp9hSOnfZrg5wjScTFnDr5IH38N0sTHLDdBstq5R/gnVyTS6/PiQC3I4t8DZp
	 5xcC+wXZ/UaP74gsVYh7lW2zi5OzoPX5uc5Wm5qG7egEHJQ6aesFw6RYZKOQeEpz1W
	 56+51d5H5UmsQDgZXo8p/51xIDnB106U4LsNwZd8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgAPQQ7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbgAPQQ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Jan 2020 11:16:58 -0500
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16675206D5;
        Thu, 16 Jan 2020 16:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579191418;
        bh=UQGRvJy+7JZ//PovsjBJ7LchKK481IsY6KERgIx38Go=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ub2YTkHtJ799YCE3Qe5m0WvntUBngVIdIfxkgwMPo1Zbq2Zbpc8iW/utjIk0fT9yn
         pZI0TI0Ad6INL/hvUT7WRC/ubSeMyOLolZL+yQBOrr7qaOWVUUex3O527tHZC0+zKU
         oOOCj0kH6QRgH9d/lOg0eQqrzF9TKGWxgCPhpNHs=
Received: by mail-ua1-f47.google.com with SMTP id a12so7860750uan.0;
        Thu, 16 Jan 2020 08:16:58 -0800 (PST)
X-Gm-Message-State: APjAAAUlNIx2xDMKVfAY9q1Fuh3XfHxqj5lRuADfEzpbiDRrsrLzGLic
        kwVi7vOV5LYUnOJX1RjIDj8/v/8f4PwLvWCDhnA=
X-Google-Smtp-Source: APXvYqyAySVnFrpLaRw+8Ipg5AjPM1RJW84peCGV54THCl2JbN6WSggYTTlsUhrdupiJ1BpVoTkvfUnynIuSJ/E/e+8=
X-Received: by 2002:ab0:2a93:: with SMTP id h19mr18028050uar.27.1579191417027;
 Thu, 16 Jan 2020 08:16:57 -0800 (PST)
MIME-Version: 1.0
References: <20200115132216.24041-1-fdmanana@kernel.org> <785ebd3c-89cb-0079-782c-9fd1e07116fa@toxicpanda.com>
In-Reply-To: <785ebd3c-89cb-0079-782c-9fd1e07116fa@toxicpanda.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 16 Jan 2020 16:16:45 +0000
X-Gmail-Original-Message-ID: <CAL3q7H655byvBYD8-wvHwDWJaWZumvyyj3bvYTOjuVZtFLjJ-w@mail.gmail.com>
Message-ID: <CAL3q7H655byvBYD8-wvHwDWJaWZumvyyj3bvYTOjuVZtFLjJ-w@mail.gmail.com>
Subject: Re: [PATCH] generic/527: add additional test including a file with a hardlink
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 16, 2020 at 4:05 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> On 1/15/20 8:22 AM, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Add a similar test to the existing one but with a file that has a
> > hardlink as well. This is motivated by a bug found in btrfs where
> > a fsync on a file that has the old name of another file results
> > in the logging code to hit an infinite loop. The patch that fixes
> > the bug in btrfs has the following subject:
> >
> >    "Btrfs: fix infinite loop during fsync after rename operations"
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> What's our policy on adding a new variant to an existing test?  I thought we
> preferred to create a new test for these sort of things?  If not then you can add

Usually yes, but since over time there started to be too many fsync
related tests, we had a discussion with Dave (Chinner)
and others about considering consolidating more tests into the same
files. It's not just the number of test files, but more time to run
(even if each one adds only 1 or 2 seconds).

That's why I opted here to update generic/527 instead of adding a new test file.
Thanks.

>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>
> I have no strong opinions either way, I just know it's come up in the past.  Thanks,
>
> Josef
