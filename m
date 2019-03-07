Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D38C43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 23:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 803772081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 23:20:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kI//z5Ua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfCGXUE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 18:20:04 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:44389 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbfCGXUE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2019 18:20:04 -0500
Received: by mail-ua1-f68.google.com with SMTP id r21so10791906uan.11;
        Thu, 07 Mar 2019 15:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K2ifAUuZ+Rw3QEu7E7kovvMTTGvwBYz+ohHito/kO58=;
        b=kI//z5UaBlRZk3MlZ5LX6cOo9jDWQzvFr0aFOV069RPH9TbhgHJU0nJFg0l9Hpcddy
         i2wS4x3jbdn48ULKqPVRX46GESdtTU5E9XAKpP1KxOAXid7/Budn0Gdlf6Lb7wXLLVB7
         +/FFdevZCgd/QHXK9njkp3glKn9yDHk8N3OGOlI4DDTcSjW2btJdKJ56vkljdoLnVvMl
         iSQLt1eLYSc2Ys2AwWf2mB5NiLYASMmDJ9VibCBhizORFIyBHlEQYZkw4jH2k0QTEoHq
         JKYa//pI+7munJ42dfJRBSGdQFINOJHM0ASI3Tu4+MESpqOq1eYil3+CAgaUsye4+0l9
         ZSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K2ifAUuZ+Rw3QEu7E7kovvMTTGvwBYz+ohHito/kO58=;
        b=NdborzvO49yvvC0psYc+hvjJ7vW36/UVCeZlrzXfY6jh/2l6LA5dpRCZH6AKu0MfwU
         KYbJ0ZgMWyXGssS0IdiTT3Yq2zeBha24Gtm4y4f/JQOvFh2Oub72kFAQKPPTOvBqV5k6
         BwNGksI9BgAOZp0+57dvbA5mwOYaMnR575Wd3i0IPf8zohnqhbzbZ4uF19O9ETUqbQA5
         c9KYFNcw6kxoJ+bQairfqUtWW6rOv8uNqzSvX5r791RubLQiCdZEsPLcurc4WiLC40Wn
         9VoVebamRiIdrDSd1daWBt+l9hLpRkkvg6+BEPnmwcteDa9Nnnxt7YtLG87Sfje16R/Q
         unOg==
X-Gm-Message-State: APjAAAUgD6wJlL3ijiU33RN5A1V3DrrIUQ43meRR22PINnbmbuwWaliM
        AbhX1Y/RjQUFh+RKk+ARz7ySDtkUUeVelZ9bya4=
X-Google-Smtp-Source: APXvYqwAqfOJzYCLLopc8GK/WZNtcQ/58G7+sNEI1VK9vnqdpw3h+c5zgyh6F5hOd+5xaq0fS66XOcXM73+ukn2VCnA=
X-Received: by 2002:ab0:1e03:: with SMTP id m3mr8191799uak.108.1552000802558;
 Thu, 07 Mar 2019 15:20:02 -0800 (PST)
MIME-Version: 1.0
References: <20190304140622.23997-1-fdmanana@kernel.org> <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <20190305005020.GA26298@dastard> <CAOQ4uxgKj8pAKKra9jv+xTb9dOxG-J5fKvJ_6a_iabWR9RbgrQ@mail.gmail.com>
 <20190305223301.GD26298@dastard> <CAOQ4uxggon==2r2hibMvXc4_N4zod+2z0Ycw74eKRn+q1uwYsw@mail.gmail.com>
 <20190306214813.GE26298@dastard> <CAOQ4uxjM0-D8c3KR0ooXYhhUa5+19j_=3XUaXf6vGMbsNhShJw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjM0-D8c3KR0ooXYhhUa5+19j_=3XUaXf6vGMbsNhShJw@mail.gmail.com>
From:   Jayashree Mohan <jayashree2912@gmail.com>
Date:   Thu, 7 Mar 2019 17:19:51 -0600
Message-ID: <CA+EzBbCuQJen9hSHf8-JSRGG3VPxo9X4ugscMdKuw_A6isHDUQ@mail.gmail.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and rename
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Filipe Manana <fdmanana@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Amir,

> I went back to look at similar fsync tests by Filipe:
> generic/{106,107,335,336,341,342,343,348,498,501,502,509,510,512}
>
> I found some alleged subtle mistakes about SOMC assumptions.
>
> generic/336 does:
> touch $SCRATCH_MNT/a/foo
> ln $SCRATCH_MNT/a/foo $SCRATCH_MNT/b/foo_link
> touch $SCRATCH_MNT/b/bar
> sync
> unlink $SCRATCH_MNT/b/foo_link
> mv $SCRATCH_MNT/b/bar $SCRATCH_MNT/c/
> $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a/foo

This is probably what's happening in this particular test :

SOMC requires:
          fsync(a/foo) must ensure unlink(b/foo_link)  (because they
were linked at some point)

But what happens is:
           fsync(a/foo)          -->  unlink(b/foo_link)
           unlink(b/foo_link)  -->  fsync(b)
           fsync(b)                 -->  rename goes through

SOMC should only require that the unlink persists. The rename
operation persists due to the side-effect of SOMC. So we should be
only testing if the unlink operation went through.

Take a look at this thread that describes the bug which resulted in
this test case (https://patchwork.kernel.org/patch/8293181/).
The file bar was lost during the rename operation and I think this
test simply wanted to verify that file bar was intact in either one of
the directories. Probably the reason this test was written was not to
test SOMC, but to verify that the log replay in btrfs does not delete
the renamed file - luckily it happens to pass on other file systems
because they all persist the rename operation as a side effect of
SOMC. To me, this test currently checks for something more than SOMC.
The check must be modified to only test if b/foo_link is removed, and
that the file bar is *either* in directory b or c.

Test 343 is a similar case where in btrfs log replay ended up
persisting the file in both the source and destination directories
after a rename operation
(https://patchwork.kernel.org/patch/8766401/). The checks must be
updated here as well.

Thanks,
Jayashree
