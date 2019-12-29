Return-Path: <SRS0=hNl+=2T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C2BC2D0C0
	for <linux-btrfs@archiver.kernel.org>; Sun, 29 Dec 2019 23:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8B3F20748
	for <linux-btrfs@archiver.kernel.org>; Sun, 29 Dec 2019 23:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfL2XTo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 29 Dec 2019 18:19:44 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42324 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfL2XTn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Dec 2019 18:19:43 -0500
Received: by mail-ot1-f68.google.com with SMTP id 66so44036810otd.9
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2019 15:19:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KrQ//YOEx/f9TiJmENlU/Dlq7v+NRnSofgy/8MN7FXE=;
        b=b6hUrg5vUBGQBsWbsSrb99Ze3NNhSiAFXyGChlF3LJdxuBoHrHc1NkETz544x9Brkw
         EdGxahAA9aETjUSrVERH9/91Pyb6imA7tAo9V3aD024otloAlJx9IXpfuqotxPLKd6P1
         GS9KS9R0Jo7XRzxSOdJrVy8Z6CNXedqePeX3LQo7JlwhGUXUM2jxGKv5hDCzqrk/OQ6g
         Terksg4t8YlqTAv1RAGeboD9sbIgsv47FiQ0cWBdHm4yiJylkfCpOLaPNY4FvEpgPTKL
         BW1gLANIPqNZ93+9zcFMl/HHV7IRzw2dO5bNf7yvIv/slsoNkzEqfpE/4MCp/RP5D7JU
         C+Jg==
X-Gm-Message-State: APjAAAXeYEZ7vyq6gn96MOoEImpXRFmYE3V+3d67ugeRi+I0DQqCILw5
        WjZG13nfLOpouFYGn7DHFx28qDw7o3FHh4UedjVLbA==
X-Google-Smtp-Source: APXvYqy6YR8dYeGlfHgllxRXRIb9ReDofG8kgSOe7pSNq+oPuHUaz+2VvO3A302DxXXp4uVhsJLFOnc/cQYd/QC/EQQ=
X-Received: by 2002:a05:6830:1251:: with SMTP id s17mr69603600otp.108.1577661582964;
 Sun, 29 Dec 2019 15:19:42 -0800 (PST)
MIME-Version: 1.0
References: <CAOB=O_jxu5JOe=JiYVW_VZ1rgs9+mdHpAHkscXkc4MVRLrBKDw@mail.gmail.com>
 <CAJCQCtQwLrZxfc7xb8FpVcV9r9rpEpD0SRPebRtRpS5SPYM_3A@mail.gmail.com>
 <CAOB=O_hLvVaSdnvXwFeC5h6=AySnb4Fh9Fzx-zjFmw92odSLzQ@mail.gmail.com>
 <CAJCQCtQogopy56foRdqb6+3ejYL=gofVyYKwoAWFjYRgyaVZew@mail.gmail.com>
 <CAOB=O_jmoMJ=Tt7wRqv6btofDQCxefYC7LaNKye7MOiQ98Djbw@mail.gmail.com> <CAJCQCtTBFeBLA3DhwyHqXmkQ6KCSkZaj7e8KGY8q5TU7Fi1PAA@mail.gmail.com>
In-Reply-To: <CAJCQCtTBFeBLA3DhwyHqXmkQ6KCSkZaj7e8KGY8q5TU7Fi1PAA@mail.gmail.com>
From:   Patrick Erley <pat-lkml@erley.org>
Date:   Sun, 29 Dec 2019 15:19:31 -0800
Message-ID: <CAOB=O_j4e1RteXwDuKw_AAEdnW9cAxFg4HHb6L5oRr+B-FmThg@mail.gmail.com>
Subject: Re: read time tree block corruption detected
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Nah, this 'corruption' hasn't affected anything other than not being
able to go to a newer kernel.  The system doesn't do anything
important.  I'll grab the logs, and clone an image of the drive so I
don't need to go single user RO mode to get dumps for devs when follow
up requests come in.

On Sun, Dec 29, 2019 at 3:11 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Sun, Dec 29, 2019 at 3:36 PM Patrick Erley <pat-lkml@erley.org> wrote:
> >
> > K.  Gotta roll a new initrd with btrfs 5.4, then will reboot into it
> > and grab logs of btrfs check (both iterations, against each of my
> > volumes).  Probably be a few hours, so don't expect another follow up
> > until tomorrow.  Thanks for chiming in.
> >
> > Would it be worth creating an image of the drive while I'm in single
> > user mode for faster analysis/iteration?
>
> Depends on the developer who replies. These days they usually just ask
> for selected dump-tree output. The image might be useful if you can't
> wait and want to blow away the file system and start over sooner than
> later.
>
>
>
> --
> Chris Murphy
