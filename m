Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3265DC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 23:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3C5D2177E
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 23:23:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="W98hPq2H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfBRXXm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 18:23:42 -0500
Received: from mail-lj1-f180.google.com ([209.85.208.180]:46645 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfBRXXm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 18:23:42 -0500
Received: by mail-lj1-f180.google.com with SMTP id v16so15772097ljg.13
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 15:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=4mGqOy7coXPnM8wXB9XFmwV47OoJ/opMOPxy5OC+ocY=;
        b=W98hPq2HdziDA5M1V57zw7oWnEywPtVekfm8fwA89ImodyOi7mEYdY5+Kwp3yzPW73
         EkdjJ5m0oissh/1AI5/D4qyr/6/7Fj2Q0mICpN6kuZRylGAqd5i1Ka8zlIjx2vBkvvjg
         oGGwBtm1xL5fHC4/MvE3KWkwoBOGRc80FAtEpStrCk138ihTXLXpe5jAgpw24RSPxdK+
         jiGApB4HjgCxt6auwlJ5F4fBRJjdP+EfLgeZ9BDXUTT+bdpZ1eFyKdqNpxeQW09FXrE2
         0wP7qNuhel1iqCBkhVByWX7uMW4Uwp1+mh0Wl8zTb79fy8H8pTuevli009uKmkEa3owL
         fyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=4mGqOy7coXPnM8wXB9XFmwV47OoJ/opMOPxy5OC+ocY=;
        b=JvEpJrc+PRTRQbRaRPSIGUYZ+tySgD6sT/FxWRsLAGH7p6gyWDrx7RSB2oClrCF0W9
         2mya5/8rkw3MTJgcL6ZL8OzJBlbpR+dtqoEmy0TKcwzgU50ukuk8o2dZenR616WTS82f
         Fchdo9f6pLOhM1iFy4wH9eji2lDChruQmOiiYsEB9xwjv6oAIsQgBuE8HYxODkmPVRIi
         JbOPd/Lrp9+Y9gOqjAfgXk6NNLNdKa0H+XfyHX7+OMAiVzol/JFkatNjuemXMOjoAgja
         MRf/X07IdiOlc1sSj8GsadiqGf+hyxng4hJhGsQ3945KQokzpTB0jnmyOMgrNdjRN/rT
         8/iw==
X-Gm-Message-State: AHQUAubqsdJ21fzZoi32vHnmDfa5J7vpVxgoX2ocUI/wJR06v10I/Wy6
        OXJsH4uueMefvPYgxt1VgTehisLdHamPwu0tYBkBx27qVog=
X-Google-Smtp-Source: AHgI3IbUIJqts9BwYMKgpU5p78rMmoRG8OY1Ft2GPqnynO8gxyQOunGt2GnR9UYq7sxncy7OMAjmzORJ0qOP0wRDD58=
X-Received: by 2002:a2e:870c:: with SMTP id m12mr1007380lji.24.1550532219158;
 Mon, 18 Feb 2019 15:23:39 -0800 (PST)
MIME-Version: 1.0
References: <CAAD7_rAwZR6j=SgZOCx3C8dRM=BUZJVHDzSmj5rWB21HyWtqSg@mail.gmail.com>
 <CAJCQCtQ=1JLtd2BMeZu_=ydi+C=-2ao-ZtJwKWmi4TM=aA1FAA@mail.gmail.com>
 <CAAD7_rBSYJ_Srcsuf--0YMXW3xd3SVdECzmH=BroOwu9YTnTjg@mail.gmail.com>
 <CAJCQCtQknb1qDusDY-iS2n_u5ywqFD4N-nKXBEJs0czEZS3b2w@mail.gmail.com>
 <CAAD7_rArVnFS=s53x2aWR==VYi6eS-OOYvBihxhOickxCxfNOg@mail.gmail.com> <CAAD7_rAk=iArkpSHeTRv7uv1tFz5nEh2qGEb7nixujLXcmhxxw@mail.gmail.com>
In-Reply-To: <CAAD7_rAk=iArkpSHeTRv7uv1tFz5nEh2qGEb7nixujLXcmhxxw@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 16:23:27 -0700
Message-ID: <CAJCQCtSc8dF6K8GGCp+kxXYj1PjpJ4qpcabFzYUx02JaVQK_ng@mail.gmail.com>
Subject: Re: raid 1 filesystem corruption
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> Am Mo., 18. Feb. 2019 um 23:35 Uhr schrieb Rudolf Kastl <che666@gmail.com>:
> >
> > I tried a btrfs check --repair on sda2:

OK I think this is a risky decision, hopefully it works out though.

a. There's corruption and IO error we don't understand the source of
yet. Repairs can make problems much worse if the source of corruption
happens during repair.

b. from the 'man btrfs check' page
           Warning
           Do not use --repair unless you are advised to do so by a
developer or an experienced user, and then only after having accepted
that no fsck successfully repair all types of filesystem corruption.
Eg. some other software or hardware bugs can fatally damage a volume.


-- 
Chris Murphy
