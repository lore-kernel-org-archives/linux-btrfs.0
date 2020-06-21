Return-Path: <SRS0=ivmk=AC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED78C433E0
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Jun 2020 19:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07A6225230
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Jun 2020 19:39:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="uLOnr3ri"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgFUTjx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Jun 2020 15:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730070AbgFUTjw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jun 2020 15:39:52 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0E5C061794
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2020 12:39:52 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id u26so12179108wmn.1
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2020 12:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Yuf+yh+QO5dpULXgXFG1kCByFElPNy1aUnOcfqTvzUE=;
        b=uLOnr3riLke7zE/WZt1hlvRY09d/io8VvMjtCQ1TxUDXXmtclATY6bv6Z9PoQU8eSi
         zaalZk4Nv5cO+GNzllfkVWk/a+TkHws3VhA3f6deJNYi0ZxFUbq+5+uHUkLwCoYcJ862
         1wvu8Anf3iruwBqcbIx6v3b56Kw46OLt+ZY8gT+UVjZy12ElSSG/l+XSCNvktq0zK2vJ
         sTYK/B4++GKy/KI/oZoeBaWAvMKjy4Jim1N2Z0VaWQEa6SvmoavMa6XYWPSlGT5EaHyg
         abuomNXfvO2litUjRicuu3Mhwr8qOYgNFN0srCL7BlGCDK+kK/2OspOIoW1K+r9nSl26
         OUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Yuf+yh+QO5dpULXgXFG1kCByFElPNy1aUnOcfqTvzUE=;
        b=hZKHWvsToOqzR2F4NIhRCW+S0vLNsKFgPh2OOJbYRdB2krPerN/bwB8jktGNMIv9zD
         980gJASBpQ9eP2Ghd9mDVd8mwLpB410XG4hVaMnBPbbpX+wRLvtmO6bsPsO0MO1TTCgB
         5Ag1RGVki7N0YXFaVvtfZSfoCgl42qDVV/biZJBkp0Hqt0FkJOKI2RIdIiUlA14j4yoe
         a1sVhpFEoHAnrPIakiJUBq+kwRpyJJ+Z/dEN9AaZ31uK75L89aItEOkDQRBsvKrnQfHP
         TyYvQrCY/X393opHXm7gdWXe3WJzXO4OwyNHNF2PwtowGAJd4LKWIkQpBAr3zNrrMHXw
         q8RQ==
X-Gm-Message-State: AOAM531/C83K94mK3+gmqighWFhZJJjLjp/uhjiaIIozdaOoDSfMQ5Dh
        w71vOEf1KXD2X5Q5vnLBZToc+4K2avDsHUiQpsudADhZ+GU=
X-Google-Smtp-Source: ABdhPJxtSGkItZlGO3JFSO3QU7VegyLNCpUh5OtIq/fHeGmlg5KY70NMVphkMnoQ1aJb+GDWlWjNPRCHA6av5wfuz6E=
X-Received: by 2002:a1c:4105:: with SMTP id o5mr14412065wma.168.1592768390939;
 Sun, 21 Jun 2020 12:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200621054240.GA25387@tik.uni-stuttgart.de>
In-Reply-To: <20200621054240.GA25387@tik.uni-stuttgart.de>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 21 Jun 2020 13:39:34 -0600
Message-ID: <CAJCQCtSbCid6OzvjK9fxXZosS_PAk2Lr7=VTpNijuuZXmRVVEg@mail.gmail.com>
Subject: Re: weekly fstrim (still) necessary?
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Jun 20, 2020 at 11:50 PM Ulli Horlacher
<framstag@rus.uni-stuttgart.de> wrote:
>
> On SLES a weekly fstrim is done via a btrfsmaintenance script, which is
> missing on Ubuntu.
>
> For ext4 filesystem an explicite fstrim call is no longer neccessary, what
> about btrfs?
> Shall I call fstrim via /etc/cron.weekly ?

util-linux provides fstrim.service and fstrim.timer for a while now.
fstrim.timer runs on Monday at 00:00 local time. The upstream default
is disabled, some distributions enable it by default. You can use this
until your kernel supports discard=async mount option for btrfs.


-- 
Chris Murphy
