Return-Path: <SRS0=hLRh=AQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BE0C433DF
	for <linux-btrfs@archiver.kernel.org>; Sun,  5 Jul 2020 11:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F2D22075B
	for <linux-btrfs@archiver.kernel.org>; Sun,  5 Jul 2020 11:16:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vZshUHd9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgGELQE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 07:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgGELQD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jul 2020 07:16:03 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E83C061794
        for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2020 04:16:03 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j4so35279312wrp.10
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jul 2020 04:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A0l7Ib8gtUtToyLfGcTKS5sZ3N2EVTDqa+1eZ8yZjNE=;
        b=vZshUHd9fNQqJ/yMZGGplgDzhl3b//Az1jjos58F60o2/QSENwEw4R9SXIk3T6rkVa
         PcJix6ZN/fUN4FGugN2QsloY5vNa/VD8A7QklhcO5KaczeJNEslOO8d7H0LeW9/H7q4O
         olAVXdM6BQsK8mlu1Cih2hlazfPqGk/56Mr7I/Z8eF72HFGrxSeEtTMJU6Q6pdLMrv/k
         gwr58Csolx1yVtEOC/hb4u4kC/eHzHobnbMkXZGG3s+6A4qWUWCfXnvLB7vVWZEXLyG4
         SA4AwtGLV1B517l44rl1UFREI9ieaTiXMu9HWVz3cQ9unZKECe0l4NGCI8fNZOC78bFn
         VJCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A0l7Ib8gtUtToyLfGcTKS5sZ3N2EVTDqa+1eZ8yZjNE=;
        b=Vnl3MuDqJdO9B6ylmQo88O8yCumMtyGok8mCLhRiCkVeAifshz2u+Sj17r1DmlJBSp
         iYm/6aB69a9YF2Pm33525hBkK9XlshqsGjmCS8x7REfIjKnj6n5ark/BhSFEBziK3Z6Q
         fuaJNHVApRN73f1lHpO7m0c7wlVs71EZlFoZY2XgUS57614VsRKochffhruCW253wS3k
         AGQ5+8243u/TT6gBafrrNDcQnCFqKmerrc3BSqe5CnE2Fy4WO0k3g0qC368XKz1ZEKOu
         zfQtL+FpY99QIkkItO0MEr+ckCJf5wg7tuw01RoOrwQ1wwabJfJZV6nLab8a05fbfLV8
         FmGw==
X-Gm-Message-State: AOAM530qrrEFECa84f3ClWrjaHtJk57ZqrF/QtNsP8u9+8kLs9dCMHhi
        tE0Ch7xF/lMgCihJgrHKkhHv5SH712hIZE1EkXc63UTZ
X-Google-Smtp-Source: ABdhPJwNydDQBOHs5QSd9e50Rlfnn67j0/Y9s7iZKCTFwPZ0NaA9I5qeLGn7KgOgv9+UvN/1dxlTLCNW4xLoaXliSP8=
X-Received: by 2002:a5d:4b45:: with SMTP id w5mr41907568wrs.4.1593947762189;
 Sun, 05 Jul 2020 04:16:02 -0700 (PDT)
MIME-Version: 1.0
References: <CANvSZQ_5p4JD4v79gFkSRBBvehCDh_Q5bBKeyNi912tr0biNLg@mail.gmail.com>
In-Reply-To: <CANvSZQ_5p4JD4v79gFkSRBBvehCDh_Q5bBKeyNi912tr0biNLg@mail.gmail.com>
From:   Patrik Lundquist <patrik.lundquist@gmail.com>
Date:   Sun, 5 Jul 2020 13:15:50 +0200
Message-ID: <CAA7pwKNpiyC7EoBVXmUi3B+Wk1BWJTs-5q1veQO1_PjmTzLsXQ@mail.gmail.com>
Subject: Re: Growing number of "invalid tree nritems" errors
To:     Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc:     Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, 5 Jul 2020 at 10:44, Thilo-Alexander Ginkel <thilo@ginkel.com> wrote:
>
> [129532.769569]       Tainted: G            E    4.15.0-109-generic #110-Ubuntu

That's a pretty old kernel from a Btrfs perspective. I'd consider
installing the Ubuntu HWE kernel which is currently at Linux 5.3.

https://wiki.ubuntu.com/Kernel/LTSEnablementStack
