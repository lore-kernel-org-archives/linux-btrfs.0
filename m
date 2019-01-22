Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A50C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 15:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5064D21726
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 15:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hJ6BDEKy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfAVPme (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:42:34 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:40721 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbfAVPme (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 10:42:34 -0500
Received: by mail-vk1-f196.google.com with SMTP id v70so5453855vkv.7
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 07:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=Bto2Sf076TvW5q6MdJB8BbEaOMgpUHZTlka9xw8QOXE=;
        b=hJ6BDEKyOgcLuoQc5yycaaImxCu9IvuORsx8gEVjnNMkwlwaG1oPJoquhamtIw1toG
         nnvzdNee8tQLSd8aXyosdB6XT14Rfc/5oTOTioiRp2MbZ837LS0qz2SaIcDz9zIcB/ym
         HFeuNnXTNuO3cSBmCiFN8dR3gnYhMeyV22XlVRzo6ivop4SM7fN0Z6L0hEX3ojy8iDnJ
         tgEH9mZdT2W2CCLHZndAu5QppNLuBd0b+UhpGjgK+PzIeWeMomFlBOxz76wqt2vnUg6U
         wo4w2H5abeqZ7t+y7FJDimfG8Rvzc799SNZ37IJURYkPx7Zn7igAjmM1aff2Nu0STgDA
         d6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=Bto2Sf076TvW5q6MdJB8BbEaOMgpUHZTlka9xw8QOXE=;
        b=NANB7oN1YOElJQYVmvJIkU1tQKNKd0kDuXasHVFosWhURUynobHEZKw0MQuMkoAIe1
         3hze2/jBQuFSZN++Jp+CniQ9DiXb+QmW5wBx1ja3oZGW2V2zuIxMQF5gp9J8qmXWOgEh
         3NQZd5En5l2hg8JjN/wzVB8vG1cDpwybhf1SenXN8Q4k4khhDPIPP3wSzIXd+i5iIJgt
         XPoMMd19OX12oMhRxNctOs8BwJXLyx4qivfWnFKAiKU+lMtsVi96/lHrxn5Prm3O3S/A
         YkcbJcmH+gCZKnv9Iq15WLT/8MeGTgAfyUNGswpdbrEVdmHA/i8aFZoQ1s4J127MNANF
         gsgQ==
X-Gm-Message-State: AJcUukcZmnr0u+uWzI189WmOCcWgHzYiPBkXLboFGcQ8UJhnpu8rixdv
        Pzbxp8qmHwYILX/F4qwGHMoo7mEtvh+zs3LGsoI=
X-Google-Smtp-Source: ALg8bN74KYjivyrAQMf/t9HO5tZ/GuCRzRU2J0RlKPuAWtY//988+7wI655jqR8OqY0h1gGuvuN/KWMG/QlCmC6aiX8=
X-Received: by 2002:a1f:4982:: with SMTP id w124mr13190419vka.4.1548171752547;
 Tue, 22 Jan 2019 07:42:32 -0800 (PST)
MIME-Version: 1.0
References: <CAJtFHURMDnM9EMAeLE4yr-UbWHa=o8M0=Yvm-MZp8ixWykfxFw@mail.gmail.com>
In-Reply-To: <CAJtFHURMDnM9EMAeLE4yr-UbWHa=o8M0=Yvm-MZp8ixWykfxFw@mail.gmail.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 22 Jan 2019 15:42:21 +0000
Message-ID: <CAL3q7H4HsGMLS5mjTLSugQ-YoF-M24Fy6eCEAF9=04g_=A=jFA@mail.gmail.com>
Subject: Re: btrfs receive deadlock and questions
To:     Eli V <eliventer@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 22, 2019 at 3:26 PM Eli V <eliventer@gmail.com> wrote:
>
> I seem to have it a deadlock trying out btrfs send & receive. Now I
> haven't used btrfs send & receive much, so don't have much experience
> with them. Anyways, bug report and stack traces:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D202383

This is the same you reported at:
https://bugzilla.kernel.org/show_bug.cgi?id=3D199753

It just happens through a different path, unrelated to send/receive.
You are running a 4.19.16 kernel, which doesn't have the fix [1]:

$ git tag --contains 5ce555578e0919237fa4bda92b4670e2dd176f85
v4.20
v4.20-rc1
v4.20-rc2
v4.20-rc3
v4.20-rc4
v4.20-rc5
v4.20-rc6
v4.20-rc7
v4.20.1
v4.20.2
v4.20.3
v5.0-rc1
v5.0-rc2
v5.0-rc3

All the deadlock problems you reported are fixed by [1] and [2].
The second, related to the free space tree, is very recent and only on 5.0-=
rcs:

$ git tag --contains a6d8654d885d7d79a3fb82da64eaa489ca332a82
v5.0-rc2
v5.0-rc3

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D5ce555578e0919237fa4bda92b4670e2dd176f85
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Da6d8654d885d7d79a3fb82da64eaa489ca332a82


>
> Seems like the receive is hung as well as several kworkers. It's about
> 1.2TB into a 9TB or so transfer onto a brand new pretty empty fs. This
> is just a btrfs send snapshot, not an incremental. That was supposed
> to come next. If this was an rsync based backup I'd just kill the
> rsync process and restart it, not sure if there's a way to restart a
> btrfs send receive, or if I'd have to delete the partially created
> snapshot on the destination and restart the send. I guess I could just
> use rsync to finish the copy of the initial snapshot as well before
> using send | receive for the incrementals. Thoughts and options would
> be appreciated, thanks.
>
> -Eli



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
