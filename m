Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC72C00449
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 12:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8EF12075C
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 12:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ohV/9Ccu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8EF12075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbeJGTeH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 15:34:07 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:43983 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeJGTeH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2018 15:34:07 -0400
Received: by mail-qt1-f174.google.com with SMTP id q41-v6so18338353qtq.10
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Oct 2018 05:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bVKwxoA3/mG0pEmUtdPe1MYXm7VX0oYmucCRe4AVAaQ=;
        b=ohV/9Ccu8VJu9UorLu58Z/92+S0IIJkaBINbBA3NffuHpAP6nhL+RaqfLkiAK0XpLI
         hQV4UwyChBAXfMyK/8cCVB1KkprkRl/UxbT1bu3Iig7rq+w9DgWUBibKeoL4JifK2sgU
         U75yj2Nzn24WplMak2ZhLVqHzc+XLy5JmTKTpI74PSY8yjp2VZ6l8W9BSqDs4KrvMXcK
         pi4YjegRAYbkwRLpilZBa5ad7YM0ay44u1srPjFR4Ee7Tns5D41qh5obYyC6YU1h6Nkp
         mC0ELxpn9Gq1vClQT5vPwJmhDGMUnd9O4ajKfX+tGu6Qyn7uO5tLZs0c0MqXvJqAuokn
         yBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bVKwxoA3/mG0pEmUtdPe1MYXm7VX0oYmucCRe4AVAaQ=;
        b=G+XSX2C4ZXXBAvNtILSqgBFOQTJuSMCMoUys1baXpZunznRLrI9flrltccbwvZ80A3
         BlOMS59bFAcVArkRp6FMMuZ1lqP4uHuPQ9vgmPKVVQmyVJiuLuJsy5MZJd0VE/zLnPFr
         d6/QbZAFDMhqqhSq2UCQQfCYsmShq0w0i/P82T4g7Au4hfFu2LXU2lLPamtzp2+MlLb2
         taHXQwd1zNqll5rlyPm7ukriIsKtL+tS50D0lc8pU96YkQkP1HQX1cXBy66x6+HBj5Ad
         ANpvHcQpUxRlMqxRSYm0Q08HrBrzaZx3dbADJ9WbNUu8LnkJ9z+iozjDIeku+EBAD/FU
         OM3A==
X-Gm-Message-State: ABuFfoj7RUTsr0UNuT5wHaCBmQDmWGXKlV/fVUDEh4ep0jz/kKtHnmrC
        +UXb1ajvBrhhsOA1tyB1l9YaCsn+O7WBX9uYMl0=
X-Google-Smtp-Source: ACcGV62fHI0yGlmt1I07BJZtsXqr2AsUJq9kEBerd6bGo+3iL7UNLjZj+ClBLs45XFdQR320jb/4vpf6ld/cZhvAebc=
X-Received: by 2002:ac8:4042:: with SMTP id j2-v6mr16169603qtl.28.1538915221191;
 Sun, 07 Oct 2018 05:27:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com> <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com> <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
 <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com> <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>
 <14c82713-72c8-a243-293b-5c482031f70a@gmx.com> <CAG__1a4_jPWJ2LcBQ2ubWeuXR3AWa4vS7vrV3Ysm-wFORddH7g@mail.gmail.com>
 <7ffc25c7-1442-99da-8600-add6b3ce2dd4@gmx.com> <CAG__1a63yUA3N4N2HjsTS7ng3tkxei6Vpo3QdckPu1CDLyv0yg@mail.gmail.com>
 <8968c012-7732-2338-c505-2027539cbe56@gmx.com> <CAG__1a7yz1iX7+M7ybGNVHLiZehactYiiJ6EbnA57RDzzx=V2Q@mail.gmail.com>
In-Reply-To: <CAG__1a7yz1iX7+M7ybGNVHLiZehactYiiJ6EbnA57RDzzx=V2Q@mail.gmail.com>
From:   evan d <forumscollective@gmail.com>
Date:   Sun, 7 Oct 2018 14:26:50 +0200
Message-ID: <CAG__1a7RF3nK5Chxj5A5ri+vf6X1UQZ0_ndbi=CMQts+yZgE2g@mail.gmail.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS filesystem
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks for looking at it for me, appreciate the input.
On Sun, Oct 7, 2018 at 2:25 PM evan d <forumscollective@gmail.com> wrote:
>
> > > I may as well use wipefs to clear crud from both drives, partition and
> > > format them and then use them elsewhere.   -- this more or less
> > > accurately summarise the situation?
> >
> > Unfortunately, yes.
>
>
> I recall the machine these drives were in lost the onboard NIC when
> the desktop switch it was connected to went up in smoke.  Perhaps it
> was at that point the corruption occurred, albeit I seem to recall
> checking the drives at the time.  Such is life.  If they pass extended
> SMART tests they'll go back into use.
