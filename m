Return-Path: <SRS0=0DI8=CJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A566C433E6
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 03:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0248520720
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 03:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lechevalier.se header.i=@lechevalier.se header.b="QhqTgIrm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgHaDPN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 23:15:13 -0400
Received: from mailrelay2-3.pub.mailoutpod1-cph3.one.com ([46.30.212.11]:58799
        "EHLO mailrelay2-3.pub.mailoutpod1-cph3.one.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726573AbgHaDPN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Aug 2020 23:15:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lechevalier.se; s=20191106;
        h=content-transfer-encoding:content-type:mime-version:subject:references:
         in-reply-to:message-id:cc:to:from:date:from;
        bh=16jXK7Qm+ALyVlU2/zjZuPMd3Px9vVsTTj7GIUvuLyE=;
        b=QhqTgIrmVCeLr2fP8LXkuo11phVQ2r3U+Qfqzi73GIWBIzt+qCDAxtExDPkH8RJ0v1O6NXblTPi1u
         /Gsra7qBVQQTzALwqHSb3LV9i4HrwcRhBKhI4oDFBieIe6SCMxgQLJ/wdvcpDN1K7vfCAno7fxelYo
         lJGLub+1dVglmTzk+ds+dAKsCCuTTF3SdDS7eDjezaZsobc6VGRHQ3Yy4lyfOfutEbZbuUYmJFq/uw
         cdc/6bjPjnn+qAuOlIkmPlAlIe1NOw7zIwqG0imvbtuwrLIcFXaw4OfGHoBSaERve7DNk3Uok8jHa4
         +dkZbk02/Kvb9LHzKZ8qAVuAhWBjFoA==
X-HalOne-Cookie: 35802e5c7d31a8ad260683af660f5b2894163d1a
X-HalOne-ID: 2c6bcab2-eb38-11ea-888a-d0431ea8a290
Received: from [192.168.0.126] (h-131-138.a357.priv.bahnhof.se [81.170.131.138])
        by mailrelay2.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id 2c6bcab2-eb38-11ea-888a-d0431ea8a290;
        Mon, 31 Aug 2020 03:15:09 +0000 (UTC)
Date:   Mon, 31 Aug 2020 05:15:08 +0200 (GMT+02:00)
From:   A L <mail@lechevalier.se>
To:     Eric Wong <e@80x24.org>,
        Hamish Moffatt <hamish-btrfs@moffatt.email>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <a09876c.a736cf94.1744282e338@lechevalier.se>
In-Reply-To: <20200831022019.GA27823@dcvr>
References: <6992fae3-ce87-8ae1-8dfe-1cb65578a16a@moffatt.email> <20200831022019.GA27823@dcvr>
Subject: Re: new database files not compressed
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Mailer: R2Mail2
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



---- From: Eric Wong <e@80x24.org> -- Sent: 2020-08-31 - 04:20 ----

> Hamish Moffatt <hamish-btrfs@moffatt.email> wrote:
>> I am trying to store Firebird database files compressed on btrfs. Althou=
gh I
>> have mounted the file system with -o compress-force, new files created b=
y
>> Firebird are not being compressed according to compsize. If I copy them,=
 or
>> use btrfs filesystem defrag, they compress well.
>>=20
>> Other files seem to be compressed automatically OK. Why are the Firebird
>> files different?
>=20
> Maybe Firebird creates DB with the No_COW attribute?
> "lsattr -l /path/to/file" to check.

Could also be that it is using Direct I/O. DirectIO prevents csum and compr=
ession too.=20

>=20
> I don't know much about Firebird; but No_COW is pretty much
> required for big database, VM images, etc which are subject to
> random writes.  Unfortunately, neither compression nor
> checksumming are available with No_COW set.

I'd not agree with this in general. Nodatacow can help in the case you are =
really bottle necked by disk I/O. I think the general recommendation to use=
 nocow is dangerous as it reduces the integrity of the filesystem for those=
 files.=20

>=20
> Big SQLite and Xapian DBs gave me trouble even on an SSD before
> I recreated them with No_COW.  Small DBs can probably get away
> with autodefrag.

This mostly depends on your application workload and not size of the files.=
 I found that with MariaDB/Innodb it is possible to adjust its settings to =
achieve good performance on Btrfs.

I use both VM images and SQL databases on Btrfs with full cow without issue=
s.

