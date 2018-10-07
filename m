Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28604C65C30
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 08:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C41832088F
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 08:28:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZdjbFvt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C41832088F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbeJGPfI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 11:35:08 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:35853 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbeJGPfI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2018 11:35:08 -0400
Received: by mail-qt1-f173.google.com with SMTP id u34-v6so18116945qth.3
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Oct 2018 01:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tncaMWwT7QGxWDQV7e2MJRuePo9witINdcoPdcFcVOI=;
        b=iZdjbFvtcaDi0XVm/Jemtbipl/ykENT60Z3NljsK2ZEoTrp62SI4Y75DMmIfrFujLs
         AhCUjeSRkPdnJkuS/cgUXsWSBfFeBaOBaIpsDTaNigE+RumM7xP67t6YoRKgOaqMR2Hg
         GCYno9Rxic1jNyQ0uiMceXjNBNZbibCtGRYFp69BldUKWdWJzpgLSE7KyaWWy3CjgtYc
         O5SwyAn+Q7M1pNLvbtd7PZzbK7nWVNHseQV2CAAxpLwngq+7kIqDI4SAfU42+OOzeE4Z
         fhk1ykNn5mjOlr3/uF3EpGS3320ldODi4uDj3lCLotAZqJFASlSO/bSgl86Ys+lyxx+t
         UiTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tncaMWwT7QGxWDQV7e2MJRuePo9witINdcoPdcFcVOI=;
        b=OG9rDsmiLWmGNzUsN/vWDI9ekccwve+o767se13RI0Opuln2HS+LiXL2IrIFaPan8Q
         1e7rJeD9i1luE4qiakNldiMoa104KDRJFDW/e9cyxwyy6BAIyxi7zraC2AQDUTOgf6Mm
         ba+eqDPzs7Q5Ki23Esz8kZZDbtB74ufAlyT5o8AisYZuiyHNMbTulDEJALcyZ5R9V1xW
         Q76DQwDcR56saXGEkqHEDx2SYr/Err6PbezpX66eVNfvvfA3UZJrQphZQxPLyMKQymXW
         8WLVQN5vH1XRnTHjNCCTVnpSTIEAyDoqFoO8y8SITJaLfCQYBJpudlGkyfq4Js+J4Kdl
         qoqg==
X-Gm-Message-State: ABuFfogD/etuHwSpfTBLeLr26vXQPlyA2toMWzsYixoLqLR6CJKPGglb
        0/qN7WOjhXly6Ojev84BLqOINlBjF4dLrMniVrZFeuiH
X-Google-Smtp-Source: ACcGV61r3efLYyilFfubWiNWf82wsAhfTGceNywA4FotzbcLCbjcpFK/10GE3PEPdSqS0aZj7GA6DO7Impo7bPoxClo=
X-Received: by 2002:ac8:190e:: with SMTP id t14-v6mr15186005qtj.327.1538900917527;
 Sun, 07 Oct 2018 01:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com> <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com> <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
 <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com> <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>
 <14c82713-72c8-a243-293b-5c482031f70a@gmx.com>
In-Reply-To: <14c82713-72c8-a243-293b-5c482031f70a@gmx.com>
From:   evan d <forumscollective@gmail.com>
Date:   Sun, 7 Oct 2018 10:28:26 +0200
Message-ID: <CAG__1a4_jPWJ2LcBQ2ubWeuXR3AWa4vS7vrV3Ysm-wFORddH7g@mail.gmail.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS filesystem
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> >> # dd if=/dev/sdb bs=1M of=last_chance.raw count=128 skip=256M
> >> # grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" last_chance.raw

grep returns no result on either drive

>>>> If still no hit, you could try just run the grep command on the disk.

like so?:
grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" /dev/sdc
