Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20F5C04EB9
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 02:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66F202087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 02:53:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="DuApwlpv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66F202087F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbeLDCw7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 21:52:59 -0500
Received: from mail-lf1-f46.google.com ([209.85.167.46]:38061 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbeLDCw7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 21:52:59 -0500
Received: by mail-lf1-f46.google.com with SMTP id p86so10791166lfg.5
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 18:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hs4yVcvvPFwzFHe1JYna6IGXHCZbQJRSAB4qE4Vug08=;
        b=DuApwlpvpJWvP+KdMPwgJRvSUK0p0P4j7qQL+iAsPVawH4KLCYU6Xu4iRB2QxSaMzU
         7y078Srrqp2K+TJXXzmNESExLmnHf09wXGRzB1LaskJme/3fbSWKrz8b1sv/FJJVt3By
         vyKJ1S2jsPAbnks2S6pRQVZ59kEFtUoXZZH/1oPvJVAQBfcrsCMHbvQprUBFnU01ZFx9
         g/vPc5vUQ07ty5vs/aT9gec0xINnD350wxUBRPLEmTBfTEp52jJVY759sH2OrAXOS6M5
         yW8dwqi1o6/CiJuuxzN2EdsqztkYzh6Ma6glZg+7dXU3Utd8bUzj0Az6An0MuySKctaD
         U6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hs4yVcvvPFwzFHe1JYna6IGXHCZbQJRSAB4qE4Vug08=;
        b=d4prRooNhhe54nUIP96ZYV6c2d+NNGENNycDrf3xV/TQaaUilrkuJX8wtOYJ9rc26c
         TDg+dizV3zNzVGE9u4GsLJnO9o3ruwDJqG85fJqCfU6RY25t0ff+3ry6BG5euV3N9ncD
         vjrtTh5YSbP1u7hrTgFACe+f4zAH6KATiUgoAYK65GMzld1GYwY8zJrXCtYE3KsQfq8n
         /XC5QRrkjhAuYpOA2Aa84WiodOXmrnmddT+WUx5q+o83luC3+pkkrJMQkU3LWfCNLqUo
         sAvtKNOlGVPBC7TMU35UogvRnc29ukJOgg5yDksQUyFeLkTm9SnHN7rKu88of5T+b49X
         0lpw==
X-Gm-Message-State: AA+aEWYN0RMylqOntD1hUR5m5GN1chH5qDopLYK4Mumk7P8J53QCf8cy
        xDDWqYmsHNAPzsqzlJc0rc9JJrzWyU/+V2VYMOYtBQ==
X-Google-Smtp-Source: AFSGD/WXhpb8um2sW0caVmUXy9hUwfhyzd7H9I6N86hBphxdSbFVSffrb45qibpcFBdRNZ5mU1pZi2lO9PUC+/8rbVI=
X-Received: by 2002:a19:c115:: with SMTP id r21mr10441096lff.144.1543891976888;
 Mon, 03 Dec 2018 18:52:56 -0800 (PST)
MIME-Version: 1.0
References: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
 <4746e8ba-b20c-01e2-379e-b76f0d2ab5a7@bouton.name> <56fe7298-af8b-05ac-bc0c-4531abd56476@bouton.name>
In-Reply-To: <56fe7298-af8b-05ac-bc0c-4531abd56476@bouton.name>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 3 Dec 2018 19:52:45 -0700
Message-ID: <CAJCQCtSVdkfgr+X5DfhaBuMy-fWdWbT4UHJo8Vsuw4CtVBfN4g@mail.gmail.com>
Subject: Re: BTRFS Mount Delay Time Graph
To:     Lionel Bouton <lionel-subscription@bouton.name>
Cc:     "Ellis H. Wilson III" <ellisw@panasas.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 3, 2018 at 1:04 PM Lionel Bouton
<lionel-subscription@bouton.name> wrote:
>
> Le 03/12/2018 =C3=A0 20:56, Lionel Bouton a =C3=A9crit :
> > [...]
> > Note : recently I tried upgrading from 4.9 to 4.14 kernels, various
> > tuning of the io queue (switching between classic io-schedulers and
> > blk-mq ones in the virtual machines) and BTRFS mount options
> > (space_cache=3Dv2,ssd_spread) but there wasn't any measurable improveme=
nt
> > in mount time (I managed to reduce the mount of IO requests
>
> Sent to quickly : I meant to write "managed to reduce by half the number
> of IO write requests for the same amount of data writen"
>
> >  by half on
> > one server in production though although more tests are needed to
> > isolate the cause).

Interesting. I wonder if it's ssd_spread or space_cache=3Dv2 that
reduces the writes by half, or by how much for each? That's a major
reduction in writes, and suggests it might be possible for further
optimization, to help mitigate the wandering trees impact.


--=20
Chris Murphy
