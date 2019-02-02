Return-Path: <SRS0=C6pa=QJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE95C282D7
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Feb 2019 04:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AA912086C
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Feb 2019 04:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="mlc0Uc4D";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LVkMiT4U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfBBE23 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Feb 2019 23:28:29 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55603 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbfBBE22 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Feb 2019 23:28:28 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id E880D217B1
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2019 23:28:27 -0500 (EST)
Received: from imap2 ([10.202.2.52])
  by compute5.internal (MEProxy); Fri, 01 Feb 2019 23:28:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        message-id:date:from:to:subject:content-type
        :content-transfer-encoding; s=fm2; bh=3A3b9XYKlSxwcm/E2stXWEbB5M
        zwpbis4bw3CkSoNCs=; b=mlc0Uc4D31tRDhtYfNIXzft0EvBoUCBNzyVUYg2Kdm
        YB3o89Z8jEWEqjq3Yj8YaekudA9HwhB9DEB1kU2Db2aRAjHpXj/hWJ6HAzb3raBE
        C5R3MKOtaRHcnJ+WnRY/5ea1g4zAx6kN4aXTYKTohMjyxnUgi69eOC6IYHahD6/s
        LcJ5JEbno7ZnKpQ1Ix0vo++ADDO5sspfgplaz5fZLm3QJDnGbic6DzI/5jY97ooe
        p0y5pezPlhFpWaIp6ACu0HAwdbvHAeC+qt3McplOwRUj1nKHUYWhQQM7IIKIsKYo
        uD9rFqsyuE9HsUyQz3GQPMJZzM3PecoDa3kIn3ve/u+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=3A3b9XYKlSxwcm/E2
        stXWEbB5Mzwpbis4bw3CkSoNCs=; b=LVkMiT4UynTjKRvw6cFL0UJTzIFaChfIz
        mdGy87YMJFQ4in8tt23LY37UipQ8//NMH2TKwYHUkQ5NIYEI4K1R038CMCceY3di
        hZ9tIi5LPn6lrBcnXgxyq7zemK53R8LHVVsfwFQOqMxSzneZOawMvK+9SwjEUhqT
        lti74g4FNWoORmrlynQAyxF4VOKTHd1i7ElJZckXIzYTkVacRBqFkfb5OzjdW6Ex
        bCYKhXpM8DmyCxgxs70RJrCRdno5xnAwrOeJelpfAi9pHEVIAvw/77IQWDWNheRG
        0fWSMXid3Kwxu75qaEPUy+Yy3pG3T8aRim54vJ21IcgnFVF3/pqMQ==
X-ME-Sender: <xms:axxVXD4B71wXX9EE-Ym6Vdzri5TMD4bqfjtQTbSBR8L5otb3m0GIzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrjeelgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecufedt
    tdenucenucfjughrpefofgfkfffhvffutgfgsehtqhertderreejnecuhfhrohhmpedfte
    hlrghnucfjrghrughmrghnfdcuoegrlhgrnhhhsehfrghsthhmrghilhdrtghomheqnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgrnhhhsehfrghsthhmrghilhdrtghomhenuc
    evlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:axxVXEl0r6lYKjNn8bbvwQXTmwLgOVJfb6B_BA233549-Rxa7G9KTQ>
    <xmx:axxVXG4a75N1H2rgJb8LionMjnfPb_ZUk1E1RR3aYLYL12ohq6gSKg>
    <xmx:axxVXNTsEuyG5EmaKPjzxCDynXk2DNSB_Icvlt8GCZ2EIfnJjb-lfg>
    <xmx:axxVXFyCFeXcIZVw6MH3n2Ppw98Mt-9WsyZsWryCcwYRzUunITzVvg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B27557C2C4; Fri,  1 Feb 2019 23:28:27 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.5-832-gba113d7-fmstable-20190201v1
X-Me-Personality: 68176920
Message-Id: <4ef8b545-efa8-43b0-8576-78c71bfb0e2c@www.fastmail.com>
Date:   Fri, 01 Feb 2019 23:28:27 -0500
From:   "Alan Hardman" <alanh@fastmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: RAID1 filesystem not mounting
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I have a Btrfs filesystem using 6 partitionless disks in RAID1 that's fa=
iling to mount. I've tried the common recommended safe check options, bu=
t I haven't gotten the disk to mount at all, even with -o ro,recovery. I=
f necessary, I can try to use the recovery to another filesystem, but I =
have around 18 TB of data on the filesystem that won't mount, so I'd lik=
e to avoid that if there's some other way of recovering it.

Versions:
btrfs-progs v4.19.1
Linux localhost 4.20.6-arch1-1-ARCH #1 SMP PREEMPT Thu Jan 31 08:22:01 U=
TC 2019 x86_64 GNU/Linux

Based on my understanding of how RAID1 works with Btrfs, I would expect =
a single disk failure to not prevent the volume from mounting entirely, =
but I'm only seeing one disk with errors according to dmesg output, mayb=
e I'm misinterpreting it:

[  534.519437] BTRFS warning (device sdd): 'recovery' is deprecated, use=
 'usebackuproot' instead
[  534.519441] BTRFS info (device sdd): trying to use backup root at mou=
nt time
[  534.519443] BTRFS info (device sdd): disk space caching is enabled
[  534.519446] BTRFS info (device sdd): has skinny extents
[  536.306194] BTRFS info (device sdd): bdev /dev/sdc errs: wr 23038942,=
 rd 22208378, flush 1, corrupt 29486730, gen 2933
[  556.126928] BTRFS critical (device sdd): corrupt leaf: root=3D2 block=
=3D25540634836992 slot=3D45, unexpected item end, have 13882 expect 1389=
8
[  556.134767] BTRFS critical (device sdd): corrupt leaf: root=3D2 block=
=3D25540634836992 slot=3D45, unexpected item end, have 13882 expect 1389=
8
[  556.150278] BTRFS critical (device sdd): corrupt leaf: root=3D2 block=
=3D25540634836992 slot=3D45, unexpected item end, have 13882 expect 1389=
8
[  556.150310] BTRFS error (device sdd): failed to read block groups: -5=

[  556.216418] BTRFS error (device sdd): open_ctree failed

If helpful, here is some lsblk output:

NAME   TYPE   SIZE FSTYPE MOUNTPOINT UUID
sda    disk 111.8G                  =20
=E2=94=9C=E2=94=80sda1 part   1.9M                  =20
=E2=94=94=E2=94=80sda2 part 111.8G ext4   /          c598dfdf-d6e7-47d3-=
888a-10f5f53fa338
sdb    disk   7.3T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481=
b
sdc    disk   7.3T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481=
b
sdd    disk   7.3T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481=
b
sde    disk   7.3T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481=
b
sdf    disk   2.7T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481=
b
sdh    disk   2.7T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481=
b

My main system partition on sda mounts fine and is usable to work with t=
he btrfs filesystem that's having issues.

Running "btrfs check /dev/sdb" exits with this:

Opening filesystem to check...
Incorrect offsets 13898 13882
ERROR: cannot open file system

Also, "btrfs restore -Dv /dev/sdb /tmp" outputs some of the files on the=
 filesystem but not all of them. I'm not sure if this is limited to the =
files on that physical disk, or if there's a bigger issue with the files=
ystem. I'm not sure what the best approach from here is, so any advice w=
ould be great.
