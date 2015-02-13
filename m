Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:36830 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbbBMNST (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 08:18:19 -0500
Received: by mail-yk0-f179.google.com with SMTP id 9so7575086ykp.10
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 05:18:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F8CF413-337F-4E67-9DA1-C738390416C4@gmail.com>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
	<pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net>
	<CABdHLQ6La7BO-TJ3cYEx_NnOUhAYJ69uv3tGnVRYsWkiUrqCsQ@mail.gmail.com>
	<pan$9532$65b1220e$320184ed$94bcf659@cox.net>
	<62ntqb-o2r.ln1@hurikhan77.spdns.de>
	<20150213024624.GB25697@localhost.localdomain>
	<4F8CF413-337F-4E67-9DA1-C738390416C4@gmail.com>
Date: Fri, 13 Feb 2015 14:18:16 +0100
Message-ID: <CABdHLQ44Oj+=AXSoduJFTNsz=SfDVJFJH2RLf2NtvjgCvwmGyA@mail.gmail.com>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
From: "P. Remek" <p.remek1@googlemail.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: bo.li.liu@oracle.com, Kai Krakow <hurikhan77@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> We did benchmark Btrfs aio/dio performance before, we noticed one big differences
> from COW and nocow is not only checksum but checksum cost more metadata, which will
> make Btrfs performance drop suddenly for a while, because of metadata reservation.

I mounted the filesystem with nodatacow which sould also switch off
the checksuming but it didn't help - sudden drops are still there.
