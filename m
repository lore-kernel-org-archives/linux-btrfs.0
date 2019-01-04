Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B755C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 01:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0B702184B
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 01:27:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Ao/id6Jz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfADBPe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 20:15:34 -0500
Received: from mail-lj1-f179.google.com ([209.85.208.179]:40851 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbfADBPe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 20:15:34 -0500
Received: by mail-lj1-f179.google.com with SMTP id n18-v6so31230902lji.7
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jan 2019 17:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vM4oBjl4U9LtlZez3rNd8IXGnU1eXJpJ5E5EGpwLjr4=;
        b=Ao/id6Jzex2poXC5yV7IqktriuBS6hpp3rZbTN9PjjbByNlDda05NOlxg8bCT11t9S
         m7sUKtj6ROi3mI/33j2oI8LieWj6S4+tdA14O214uhgXeajxyh0Y1uWmFxDiEsHJ4bIM
         X6xoC3mKaMahMKTFKfDodeDkBBA4t12pZDn+/agS5u6bmmk4Hnc1aq/hTmkxcXEjbTBS
         p6T2wZD/QaVw0rPWxzdoNrmprvDtaYcVJcCy8/4k9DCg3pCtGKNc97lXUwaIjqw9YhLE
         ZmZ+oS7ckC8/m21eRoaNyX8bLvRShe/FYrqHNQrBDE0iTWLWQ2D0Q3CtWRgVWGW4aLvf
         e5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vM4oBjl4U9LtlZez3rNd8IXGnU1eXJpJ5E5EGpwLjr4=;
        b=uR8XJ1b7/70Ei0sfYjOdwSyhXzSgosXgf9Dhbb08K9t9zv6wlS32Morfj16cUKNEC1
         kIxz6GpYuBtAzyj6a44MQ133JXi9LzheVpjoqFs/dJrFKTqWBAxwvmqtHaU+nkWyzAA5
         40aRMG7RwH0zvI6qY1w8CSxBpF0tNBBNu6DnWraYH/6FFPhJV3Pq3rKRKO6ySu3ibzMU
         Wy4aVbZ4+E/u4gAKTKVuwP9X5AmZqogSPluU05fqrzJEbTRalcemAoKhveXf00HC44Sb
         5kjxhvFwhs5oxO8kL01GZYMjxlWzA0obiws8sHYDLuF7tmwvsAn5WUeO/bkrVekGPNLy
         jmtQ==
X-Gm-Message-State: AJcUukccN4ajcxX8fGcEJOEVcHUzuspd/qUqZTDS4Xh7T+A8crKuNf8E
        VToChKSfUIkeMQz966IvDN8fs5x9vNeqzVu3AVfuUg==
X-Google-Smtp-Source: ALg8bN7xlQ9yDJBexwIQLsQ7AwdsLLFhuOotUKOisHFc7UHo2F+alXFRxGg5/AyJn8EBd5azQLSBLfVW2eanh3pD10M=
X-Received: by 2002:a2e:4746:: with SMTP id u67-v6mr6951065lja.142.1546564529978;
 Thu, 03 Jan 2019 17:15:29 -0800 (PST)
MIME-Version: 1.0
References: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
In-Reply-To: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 3 Jan 2019 18:15:18 -0700
Message-ID: <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
Subject: Re: Unrecoverable btrfs corruption (backref bytes do not match extent backref)
To:     Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 3, 2019 at 3:13 PM Nazar Mokrynskyi <nazar@mokrynskyi.com> wrot=
e:

> root@ubuntu:~# btrfsck /dev/mapper/luks-739967f1-9770-470a-a031-8d8b8bcdb=
350
> warning, bad space info total_bytes 2155872256 used 2155876352
> warning, bad space info total_bytes 3229614080 used 3229618176
> warning, bad space info total_bytes 4303355904 used 4303360000
> warning, bad space info total_bytes 5377097728 used 5377101824
> warning, bad space info total_bytes 6450839552 used 6450843648
> warning, bad space info total_bytes 7524581376 used 7524585472
> warning, bad space info total_bytes 8598323200 used 8598327296
> warning, bad space info total_bytes 9672065024 used 9672069120
> warning, bad space info total_bytes 10745806848 used 10745810944
> warning, bad space info total_bytes 11819548672 used 11819552768
> warning, bad space info total_bytes 12893290496 used 12893294592
> warning, bad space info total_bytes 13967032320 used 13967036416
> warning, bad space info total_bytes 15040774144 used 15040778240
> warning, bad space info total_bytes 16114515968 used 16114520064
> warning, bad space info total_bytes 17188257792 used 17188261888
> warning, bad space info total_bytes 18261999616 used 18262003712
> warning, bad space info total_bytes 19335741440 used 19335745536
> warning, bad space info total_bytes 20409483264 used 20409487360
> warning, bad space info total_bytes 21483225088 used 21483229184
> warning, bad space info total_bytes 22556966912 used 22556971008
> warning, bad space info total_bytes 23630708736 used 23630712832
> warning, bad space info total_bytes 24704450560 used 24704454656
> warning, bad space info total_bytes 25778192384 used 25778196480
> warning, bad space info total_bytes 26851934208 used 26851938304
> warning, bad space info total_bytes 27925676032 used 27925680128
> warning, bad space info total_bytes 28999417856 used 28999421952
> warning, bad space info total_bytes 30073159680 used 30073163776
> warning, bad space info total_bytes 31146901504 used 31146905600
> warning, bad space info total_bytes 32220643328 used 32220647424
> Checking filesystem on /dev/mapper/luks-739967f1-9770-470a-a031-8d8b8bcdb=
350
> UUID: 5170aca4-061a-4c6c-ab00-bd7fc8ae6030
> checking extents
> extent item 3114475520 has multiple extent items
> ref mismatch on [3114475520 4096] extent item 1, found 2
> backref bytes do not match extent backref, bytenr=3D3114475520, ref bytes=
=3D4096, backref bytes=3D36864
> backpointer mismatch on [3114475520 4096]
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 39409483813 bytes used, error(s) found
> total csum bytes: 35990412
> total tree bytes: 2395095040
> total fs tree bytes: 2249408512
> total extent tree bytes: 96534528
> btree space waste bytes: 456622616
> file data blocks allocated: 174319587328
>  referenced 61677670400

I haven't seen "bad space info" before and searching the list archive
I only came up with one other report of it and no developer replied.

What do you get with 'btrfs check --mode=3Dlowmem' ? This is a different
implementation of check, and might reveal some additional information
useful to developers. It is wickedly slow however.


> If this seems anything important and you want me to run some commands to =
check what happened exactly, I can start VMs with this partition image conn=
ected and do whatever is needed. I can't send image anywhere though, since =
it contains sensitive information.

If you use btrfs-image -ss option, there won't be any sensitive
information included. Files are hashed. Some short name files or dirs
can't be hashed (you'll see a warning) and those are replaced with
random garbage instead. There is only metadata with the image, no user
data.

> P.S. I really wish BTRFS can stop accidentally corrupting itself one day.

I have several Btrfs file systems that I use constantly, all but one
is at least three years old. I've never experienced corruption on any
of them. I did discover some isolated corruption of file data
(systemd-journald and also a VM image) but those were bugs that got
fixed, and also the file system metadata was fine.

So I guess my bigger complaint with Btrfs isn't so much that
corruption happens, but that it sometimes happens in a way we can't
track down and know what to blame for the problem. Knowing what to
blame is important for fixing bugs and also working around them in the
meantime. So for sure it's frustrating, even if I haven't experienced
it myself.

As Btrfs file systems get bigger, the more we're running into the very
scalability complaints that existed pre-Btrfs. The idea of Btrfs is
that it should always be consistent, and not need offline repair.
Doing an offline consistency check is just too expensive. Doing a
check and repair that ends up making the situation worse, is really
expensive. That's a bad user experience that reasonably turns into a
lost user. And in order to fix bugs and make Btrfs better, we need
more and good bug reports, not less.

So... yeah. I'm not sure if there is more tracing or debugging
information that's needed by default in Btrfs, so we can have a better
chance of understanding these corruptions when they occur? Or what. We
can't expect people to leave integrity checking always on, it's too
expensive.

--
Chris Murphy
