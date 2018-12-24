Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D64C64E75
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 17:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61985217D6
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 17:21:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mailmag.net header.i=@mailmag.net header.b="4v1QERiD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbeLXRVV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Dec 2018 12:21:21 -0500
Received: from mail.mailmag.net ([5.135.159.181]:55796 "EHLO mail.mailmag.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbeLXRVQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Dec 2018 12:21:16 -0500
Received: from authenticated-user (mail.mailmag.net [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mailmag.net (Postfix) with ESMTPSA id A62E5EC051B
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Dec 2018 09:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailmag.net; s=mail;
        t=1545672074; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=tDW9zvmlBqvNig86RfgpFTPPtcaUN+3i/43KE4hfn4c=;
        b=4v1QERiDlpl+z2D44RAV2LMgdnb5fBtHyIA+VXsWSPgT8BVpGk5xDwVP1C9A789kqK7hJh
        W884p6mI0KlEHEh9fu10jvQ5iZDYG/dUJJXKZilBucOdtLhxt9AyT/7KwpZCxMwSRjTHUY
        R7PqZxldgEm0pCFScBqg8kBwSEaizMo=
MIME-Version: 1.0
Date:   Mon, 24 Dec 2018 17:21:14 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From:   joshua@mailmag.net
Message-ID: <96d61222666591a99b9b9f0c42bf4d5f@mailmag.net>
Subject: btrfs fi usage -T shows unallocated column as total in drive, not
 total available to btrfs
To:     "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=mailmag.net;
        s=mail; t=1545672074; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=tDW9zvmlBqvNig86RfgpFTPPtcaUN+3i/43KE4hfn4c=;
        b=pxK5gkb///uRizWN0ioFDsiCbHourf9R+2ebcuDkZ6Q/a0ohQQX4uT5Nkp64Uk65AxJeO3
        ibrDcsSJouULsZ51jTk+ug4neikPLuuE8QpO+ZT+Vy1ULWklygqk5fFjnlfK1e/76grHsn
        kOUpGaAN0jYakP2fCdPB7TKIHQuKVOI=
ARC-Seal: i=1; s=mail; d=mailmag.net; t=1545672074; a=rsa-sha256; cv=none;
        b=ZkWjn3lh2o1BY1w6RTBzjhFDUFtdQqvAcT+KW+q9gvuZFY2lVBTkFttwnwl+ktzsZO6Dzz
        2DrBgiSdqmhKh3TE0tYCMOyynGfszaUQtt6/m2WroMz1IRY92nMIR38PiqzV1fg92v/GSZ
        OWK4hQ5EDA96PzcznnMsMAXRGSNdc3s=
ARC-Authentication-Results: i=1;
        mail.mailmag.net;
        auth=pass smtp.auth=joshua@mailmag.net smtp.mailfrom=joshua@mailmag.net
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I generally use this command to check my drive usage: `btrfs fi usage -T =
/mnt/data` But this time=0Ait didn't give me useful information:=0A=0AI d=
ecided to begin replacing a few of my drives with larger drives, so I cou=
ld remove a lot of my=0Asmaller drives. I ran this command:=0AOverall:=0A=
Device size: 67.31TiB=0ADevice allocated: 41.73TiB=0ADevice unallocated: =
25.58TiB=0ADevice missing: 0.00B=0AUsed: 41.69TiB=0AFree (estimated): 12.=
81TiB (min: 12.81TiB)=0AData ratio: 2.00=0AMetadata ratio: 2.00=0AGlobal =
reserve: 512.00MiB (used: 0.00B)=0A=0AData Metadata System=0AId Path RAID=
1 RAID1 RAID1 Unallocated=0A-- -------- -------- -------- -------- ------=
-----=0A4 /dev/sda 2.57TiB 3.00GiB - 164.52GiB=0A{-snip-}=0A=0AI then sta=
rted the replace with this command: `btrfs replace start 4 /dev/sdu /mnt/=
data`=0AEverything went well, so I checked again:=0Aroot@CENTAUR:~# btrfs=
 fi usage -T /mnt/data=0AOverall:=0ADevice size: 67.31TiB=0ADevice alloca=
ted: 41.73TiB=0ADevice unallocated: 25.58TiB=0ADevice missing: 0.00B=0AUs=
ed: 41.69TiB=0AFree (estimated): 12.81TiB (min: 12.81TiB)=0AData ratio: 2=
.00=0AMetadata ratio: 2.00=0AGlobal reserve: 512.00MiB (used: 0.00B)=0A=
=0AData Metadata System=0AId Path RAID1 RAID1 RAID1 Unallocated=0A-- ----=
---- -------- -------- -------- -----------=0A4 /dev/sdu 2.57TiB 3.00GiB =
- 6.53TiB=0A{-snip-}=0A=0AFor a brief moment I was confused, and ran this=
 command to double-check:=0Aroot@CENTAUR:~# btrfs fi sh=0ALabel: 'DATA' u=
uid: ddafe51b-e1e8-4f4b-bcca-057f53b59a8d=0ATotal devices 17 FS bytes use=
d 20.84TiB=0A{-snip-}=0Adevid 4 size 2.73TiB used 2.57TiB path /dev/sdu=
=0A{-snip-}=0A=0AOh right, I have to run resize! So I run resize, and eve=
rything works exactly as expected.=0A=0AHowever, shouldn't `btrfs fi usag=
e -T` only report the usable space in the unallocated column?=0A`btrfs fi=
 sh` only reports the available space correctly.=0APerhaps there is a rea=
son for this behavior? If not, it's a little confusing, and should really=
 be=0Abrought into line with `btrfs fi sh` IMO.=0A=0AFor reference, here =
is what I ran afterwards:=0A=0Aroot@CENTAUR:~# btrfs fi resize 4:max /mnt=
/data=0AResize '/mnt/data' of '4:max'=0Aroot@CENTAUR:~# btrfs fi sh=0ALab=
el: 'DATA' uuid: ddafe51b-e1e8-4f4b-bcca-057f53b59a8d=0ATotal devices 17 =
FS bytes used 20.84TiB=0A{-snip-}=0Adevid 4 size 9.10TiB used 2.57TiB pat=
h /dev/sdu=0A{-snip-}=0A=0Aroot@CENTAUR:~# btrfs fi usage -T /mnt/data=0A=
Overall:=0ADevice size: 73.68TiB=0ADevice allocated: 41.73TiB=0ADevice un=
allocated: 31.95TiB=0ADevice missing: 0.00B=0AUsed: 41.69TiB=0AFree (esti=
mated): 15.99TiB (min: 15.99TiB)=0AData ratio: 2.00=0AMetadata ratio: 2.0=
0=0AGlobal reserve: 512.00MiB (used: 0.00B)=0A=0AData Metadata System=0AI=
d Path RAID1 RAID1 RAID1 Unallocated=0A-- -------- -------- -------- ----=
---- -----------=0A4 /dev/sdu 2.57TiB 3.00GiB - 6.53TiB=0A{-snip-}=0A=0AS=
o everything is as I expect it to be afterwards- All ready to begin remov=
ing multiple drives.
