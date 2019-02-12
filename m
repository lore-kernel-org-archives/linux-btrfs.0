Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1149C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 21:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96AAA222C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 21:48:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="jMHrXZL1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbfBLVsy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 16:48:54 -0500
Received: from mail-lj1-f179.google.com ([209.85.208.179]:46265 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbfBLVsy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 16:48:54 -0500
Received: by mail-lj1-f179.google.com with SMTP id v16so146971ljg.13
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 13:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FHpgFqkpDJoV9DdB4ez4n9AGxtoPtTzXmpQiZyysI6M=;
        b=jMHrXZL1IP4r3O0VQA7VSgD9PE8McFIEk+mrbsO7RqdGih49ipdbXMvo0dpiDs62cp
         Es9xwIz+iLyVrQi4dqTieO7fHPeoONp/lM0TmT961APpxu5ZPFb0lmVJxXedrLGedoDb
         qIcaGwQhfr5G84zXyo2s8GL1otqQleyDsG9zJAmNXkHdX7o4WXBF8KhPIJpEKys0r4d7
         Q8K3toWemLmb0gf6P6tL7aHPD47px73gT4nCGJsBcnrNFp66I9jinJyrWDfNvSzL/svr
         vOHpoLJUW66wMCave2dPR6ci+uOjD/b8Fgn5Clo0Cum0+ioSA+vQ4x83D8ENn3XN3HRS
         7Ghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FHpgFqkpDJoV9DdB4ez4n9AGxtoPtTzXmpQiZyysI6M=;
        b=B/vuRzDtN0hURXB7HECXB/atpYJkjHeN/yniIAWl4K8IeV/+Z2MzsIx+yGQQGB+zF5
         0Xtr3JwkU0g4Kat21S8GUw9juRZab2gY/kX5rU/khw3YDwNhAiheHRPNVrqdiw/ccjRe
         Ay8tk60196EAbIGssF05FlgH5BwRXJPSsw64/dxeumyd4kkqjvHB5d5C/WIi7xbPxSE2
         YAsOcvGL5K3Nque51/Y2l9GwPk/ImCmHTi+oq954SH3BXOX9ShpG08FoI0jvvpwmx/DF
         rc7467+x7z1DWODIU6CMJdDsfzHqjKrR8nIX87fYF5eEwH1+iFr0OCdogGk9aUIy9nqq
         Ielg==
X-Gm-Message-State: AHQUAubsql3MlLB6mCNmTSZYR11UlkOMI3q8o2PN6eTs4W6l5fSZD5bb
        NWscyX5qBa1tAOv3dnOMnhUlJpvL6Yi5PeCSgGmfGK6I
X-Google-Smtp-Source: AHgI3IZNcP1jbBmMopTPzHXOgmryu4cRWzhddFo3DrSRW1rdAH264aPgpvKPhXWdFIdQPKrnmsfl668KDIA2LgADRx0=
X-Received: by 2002:a2e:8719:: with SMTP id m25-v6mr3797134lji.121.1550008131981;
 Tue, 12 Feb 2019 13:48:51 -0800 (PST)
MIME-Version: 1.0
References: <20180823031125.GE13528@hungrycats.org> <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org> <b7d76392-6414-804f-c383-a43dc2d81c1c@gmail.com>
In-Reply-To: <b7d76392-6414-804f-c383-a43dc2d81c1c@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 12 Feb 2019 14:48:38 -0700
Message-ID: <CAJCQCtT1K4RY+_nmcWZdzHVSno-ijHZYLfJz4vu-irN4p+ZYxA@mail.gmail.com>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Filipe Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Is it possibly related to the zlib library being used on
Debian/Ubuntu? That you've got even one reproducer with the exact same
hash for the transient error case means it's not hardware or random
error; let alone two independent reproducers.

And then what happens if you do the exact same test but change to zstd
or lzo? No error? Strictly zlib?

--
Chris Murphy
