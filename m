Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1291DC677F5
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 10:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA28520882
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 10:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="seL0UJio"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA28520882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbeJGRq6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 13:46:58 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:38026 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbeJGRq6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2018 13:46:58 -0400
Received: by mail-qt1-f174.google.com with SMTP id l9-v6so18238226qtf.5
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Oct 2018 03:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gcURJDl8t3kvpKrLCaYj1JMLV7sznT+bRyVr8d0r1tg=;
        b=seL0UJioCgUUYBTiN0zlX4psM+4O+Zbe31o68VoEVWHoV720eYUB9q2Uwu5OEVd/9W
         ++3RrmNvMS4BOE7bd6pJdsfzalNVuCvqmLDwllnSIaIdvfZeJdFCxK0qFMYlhkW7FotB
         6qtRevg9xkDX/SoygztjWJKAa2DjEQ8EZ70d7DfZJBBgWOVpuxEMDXM9qHTLmU7w0DBe
         ToKY84KIh0n9z9vKbxTLd6EWAfo0ua+qmB1cD8EieVJZ6qMfSSsmiyNP97LlH3+vsquZ
         FVugJ9Q7xycX4QIvTA0ZjhwiAcz42KK/gNELKIiJl65PjZXaR5ezda88dIXrjEUR2Q9G
         sd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gcURJDl8t3kvpKrLCaYj1JMLV7sznT+bRyVr8d0r1tg=;
        b=iafwbr62MDvBoZvoPGKiGlShyAANH/ulzm8zj8+yuE8B3LBlyDw4XjBUUwhJQdJ67x
         NZAbakWBhppHxp1RLGmIX34AjiDwVX/YR0xC5vGNcU1QHSODXI4j4MuOrOxQ7XVCnVVe
         7JP38zK9xohsTmuhYXkc/f5P0tZ2dJ6L+DYvFNscl/hiGMdmzFs7c75FNFDMaPQSKj09
         YkSerkYUig6xFLjep4WLnsdMtUjQvWGLIO6cxYs4eOYrKvcyoub8xanSwjCjUdmuzLzh
         faUiwAAD6Pio3632PyItedTQVdzFvoLNfah+SKbBODrYVr3RwsV6pDEl2qqAbMrLwVYw
         u3Kw==
X-Gm-Message-State: ABuFfoiZIXM3994JooeS8WqzBKSuoj9Kw083f82zvQPCW0pJWHuZzBjA
        TH2+AuiOD4VXhyRtlrGhMGoCj+Yj2S3bVr3DMh8=
X-Google-Smtp-Source: ACcGV62hxC5M7BRJp1k2CvTp8OVBplHot40RWJNtjeVwWYUAA441fZOQaf8xicoXN9eJ5pHqWvHveL/BR+3jx9dWXP4=
X-Received: by 2002:aed:3c93:: with SMTP id d19-v6mr15546753qtf.5.1538908807150;
 Sun, 07 Oct 2018 03:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com> <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com> <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
 <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com> <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>
 <14c82713-72c8-a243-293b-5c482031f70a@gmx.com> <CAG__1a4_jPWJ2LcBQ2ubWeuXR3AWa4vS7vrV3Ysm-wFORddH7g@mail.gmail.com>
 <7ffc25c7-1442-99da-8600-add6b3ce2dd4@gmx.com>
In-Reply-To: <7ffc25c7-1442-99da-8600-add6b3ce2dd4@gmx.com>
From:   evan d <forumscollective@gmail.com>
Date:   Sun, 7 Oct 2018 12:39:56 +0200
Message-ID: <CAG__1a63yUA3N4N2HjsTS7ng3tkxei6Vpo3QdckPu1CDLyv0yg@mail.gmail.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS filesystem
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> > like so?:
> > grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" /dev/sdc
> >
> Yes. And it will be very slow, since you're going to read out the whole
> disk.
>
> But I don't really think you would get some hit, according to current
> result.

Ok, so it is what it is.  Based on what you're telling me, whilst the
data may be there and intact, the superblock is irretrievably damaged
and the data is thus for all intents and purposes lost.

I may as well use wipefs to clear crud from both drives, partition and
format them and then use them elsewhere.   -- this more or less
accurately summarise the situation?
