Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19198C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 12:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE8312083C
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 12:55:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ACBePWrF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE8312083C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbeJOUkL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 16:40:11 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:32800 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbeJOUkL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 16:40:11 -0400
Received: by mail-yb1-f194.google.com with SMTP id u88-v6so7434823ybi.0;
        Mon, 15 Oct 2018 05:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=050C6rnFyEBYbbVGNQ41dYehb7OBRexTAzNz98CZtt8=;
        b=ACBePWrFrGgkhbV+e0i/Mrg1d7bsYcOHl4Qu/nlTVXQQIFlCynzU2ejyyzDAW+5Deh
         vcv/OfjU5MG3BEL7RyY8kndJGCKfhTadGPzamJBOi2Qp9q9g8flchZdu6TjphF+GU8F3
         p0t+4E0vBFUSpTgg+vLVmS6RtZVxuSX+yTHE2imGDxh3ovznqpHXsiRO8r3N+mSNUTxh
         MNKHLNIkB2wSqOBVNyGLOJJgVAcwQrGTpYuMotlcygArEBXmLpX38PD9P4rK1ZYQCuWn
         kCuG+efwZnZijp3rjZOXvjLTB97ltOHsT/0VYHZ870iYbvLmt2zw5tD+VVTE8bsMiMF1
         2vnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=050C6rnFyEBYbbVGNQ41dYehb7OBRexTAzNz98CZtt8=;
        b=qY5adGC5cEzedvPj/ArpoyZknptaqYgu55CjFZShCpYNIzA30+6lpsGvkLw1cjGAjq
         o27fSZL3RlIQUJ81RzdP1J80itC6jQckIIPGClaxjKl6o3+Ap5b+PEYulQ6ckz7GDc8I
         ILlNzNmQes/QKs7J5CBF4RU9fU4Hj9nYmIgNaX/ste5G04Oj9AVPtfModrVpdVoEQUGl
         0vqPPv5W7Ss123Phzz8pTeMPbsYkrmP8tGlb6G6a51rEIWPw0+ZaqT2HNqv/BhbOs08X
         8ByWci/tITkiNv/6q1hkROyhGI2ykhKnbGMI3YcUocMsEGaMAve0ZQmfLWUfv8TIlFBg
         bqIQ==
X-Gm-Message-State: ABuFfohli6nGMzYbirmqiaZgFIUYE7hltHR5GY2ulDzmlMFgyZIJK8Eo
        CCfxW/VFAQaD4GJb74GBNlEbi7Z1C/Npq3f7Mzerkg==
X-Google-Smtp-Source: ACcGV62K16Eqvgzt4S12ZpQ/KWSyvlDEehiJNUbD9bHcMLiMS5V7MhFf5mzUYx0zHecC/gu58C1DyJGwAIvQAIwaJJg=
X-Received: by 2002:a25:af94:: with SMTP id g20-v6mr9043525ybh.320.1539608099107;
 Mon, 15 Oct 2018 05:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938919123.8361.13059492965161549195.stgit@magnolia> <20181014171927.GD30673@infradead.org>
 <CAOQ4uxiReFJRxKJbsoUgWWNP75_Qsoh1fWC_dLYV_zBU_jaGbA@mail.gmail.com> <20181015124719.GA15379@infradead.org>
In-Reply-To: <20181015124719.GA15379@infradead.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 15 Oct 2018 15:54:47 +0300
Message-ID: <CAOQ4uxi7AuNHapyfkLYDSjkZAiDsZFUiPDDWTgGJJSEcOOtaPg@mail.gmail.com>
Subject: Re: [PATCH 07/25] vfs: combine the clone and dedupe into a single remap_file_range
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 3:47 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Mon, Oct 15, 2018 at 09:04:13AM +0300, Amir Goldstein wrote:
> > I supposed you figured out the reason already.
>
> No, I hadn't.
>
> > It makes it appearance in patch 16/25 as RFR_VFS_FLAGS.
> > All those "advisory" flags, we want to pass them in to filesystem as FYI,
> > but we don't want to explicitly add support for e.g. RFR_CAN_SHORTEN
> > to every filesystem, when vfs has already taken care of the advice.
>
> I don't think this model makes sense.  If they really are purely
> handled in the VFS we can mask them before passing them to the file
> system, if not we need to check them, or the they are avisory and
> we can have a simple #define instead of the helper.
>
> RFR_TO_SRC_EOF is checked in generic_remap_file_range_prep,
> so the file system should know about it  Also looking at it again now
> it seems entirely superflous - we can just pass down then len == we
> use in higher level code instead of having a flag and will side step
> the issue here.
>
> RFR_CAN_SHORTEN is advisory as no one has to shorten, but that can
> easily be solved by including it everywhere.
>
> RFR_SHORT_DEDUPE is as far as I can tell entirely superflous to
> start with, as RFR_CAN_SHORTEN can be used instead.
>
> So something like this in fs.h:
>
> #define REMAP_FILE_ADVISORY_FLAGS       REMAP_FILE_CAN_SHORTEN
>
> And then in the file system:
>
>         if (flags & ~REMAP_FILE_ADVISORY_FLAGS)
>                 -EINVAL;
>
> or
>
>         if (flags & ~(REMAP_FILE_ADVISORY_FLAGS | REMAP_FILE_DEDUP))
>                 -EINVAL;
>
> should be all that is needed.

Yeh, I suppose that makes sense.

Thanks,
Amir.
