Return-Path: <SRS0=cIUr=O6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FROM,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048D9C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Dec 2018 14:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1EA92190A
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Dec 2018 14:27:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="qLlKwN4F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbeLUO1q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Dec 2018 09:27:46 -0500
Received: from mout.web.de ([217.72.192.78]:36271 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730556AbeLUO1p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Dec 2018 09:27:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1545402464;
        bh=lAL8sFho2CvT9kl9kkoqN+V1HiBoZdIaN8FyIKW6wWY=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=qLlKwN4FmMFrGEgN8iLUm/h0N4jWDkz6sYaJnP8Ug0XA30zRiCKYArFgivMrYBN1r
         RW2ZyElF00BIT6TZuixx45/8UOfbnbe4AMS+A/LAOQejbmIjXv0860a5S1nUpuTBjJ
         cuVPcQL+5yy2Z3zZWjxXR7gOoKLuVUE8t8fr/fPQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [94.79.184.225] ([94.79.184.225]) by web-mail.web.de
 (3c-app-webde-bap30.server.lan [172.19.172.30]) (via HTTP); Fri, 21 Dec
 2018 15:22:42 +0100
MIME-Version: 1.0
Message-ID: <trinity-ec0de399-18af-4184-bd8d-364ffa41afd3-1545402162344@3c-app-webde-bap30>
From:   c.monty@web.de
To:     linux-btrfs@vger.kernel.org
Subject: Defining quota on /home
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 21 Dec 2018 15:22:42 +0100
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
X-Provags-ID: V03:K1:gT0xGnRgsC4mgkCi7QV0Re/7dP18gGH43ArvSvSxDQWYVLLI2BWjhD/zYuKF4JQ0fgeDk
 7uF+XrsONe3r+gU7P0lcUO2URnE6uaw+9DBFS4R7nSBlSHNbOMSGC3pdZBHMARd+WicT9lJbOH+L
 YYBcibVAFhI4hb+1xPN+KEH9Dbz+OEZMTWllCLcMuFLuiWM2BVhHLhQRDjiYLadL0cdDWkVQ9MI7
 hOjpcxHzVsrcZ/Wv0r4msQQQpbn1HbMZ20aaAt0juvILd4bZLg41TdoE6QIDuK27I4Q5nVX0PGsf
 uA=
X-UI-Out-Filterresults: notjunk:1;V03:K0:0zFB6Wh00RY=:Q+mAAi77wu9PJrCH8rHQ9l
 kf8BZTeIlQmYGKTsEP1bX9h9rEJkJfOY/ytPV0uCbKPkEoe2F/x8ao7hooCEegPpd7YOokUEs
 gy3EbnqrRLKseA1giDPTdGZ+YZDBUILaLIrttiVPIKNEv9jqHoXrHVngnMK26v8Cvft/Ir63R
 iTs7D2N9A/qMm5l4q/M8jMnjY3iwdZRJRF+Z/EofqdmxAr7+2/5Q8FBs2MXiaEO3po+M/rc0K
 7c4Yjp23+uBdLcPsUX8v4em/cjcsQuCpvugOXTlfsdkbGOcv2Exs0XO9HWUOEd58OZf1Ms31c
 awwidc9BDmYo2c09l2AarwGgny28qdmG1xF0mVpC7iLhFzc8BL3EQYZsJjjjjxBACGoFxyQr+
 e9HZHUELD/tkC+h7KDtwPDUv7NuXTQAyeSYHpuaJnVZ3Xscv+yPDVNq7nJlflMBgk2WxEDorE
 PH6TGPlYbIShA6Dv0pegQBYJp7SSx1T1X/LatuWXcHuVhZvh/I+UC4gwyR3qjX/Yo1NlZL2mt
 PqGNhbXWNi5P6wdmJZPpjVuosQQyUgzFCByctQBO6rBpW8sXidcnoLPiWrxQm2NOw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,
=C2=A0
I have defined a quota on home with these steps:
1=2E=C2=A0btrfs quota enable /home
2=2E=C2=A0btrfs qgroup limit 150G /home
=C2=A0
Now I can verify the corresponding setting:
btrfs qgroup show -reF /home
WARNING: Qgroup data inconsistent, rescan recommended
qgroupid =C2=A0 =C2=A0 =C2=A0 =C2=A0 rfer =C2=A0 =C2=A0 =C2=A0 =C2=A0 excl=
 =C2=A0 =C2=A0 max_rfer =C2=A0 =C2=A0 max_excl
-------- =C2=A0 =C2=A0 =C2=A0 =C2=A0 ---- =C2=A0 =C2=A0 =C2=A0 =C2=A0 ----=
 =C2=A0 =C2=A0 -------- =C2=A0 =C2=A0 --------
0/279 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1=2E79GiB =C2=A0 =C2=A0 =C2=A01=2E79GiB =
=C2=A0 =C2=A0150=2E00GiB =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
255/279 =C2=A0 =C2=A0 =C2=A0 1=2E79GiB =C2=A0 =C2=A0 =C2=A01=2E79GiB =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 none =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
=C2=A0
However I don't understand the line with qgroupid 0/279?!?
=C2=A0
I have created another quota earlier for /var/log, and there's no second l=
ine in output of=C2=A0btrfs qgroup show:
btrfs qgroup show -reF /var/log
WARNING: Qgroup data inconsistent, rescan recommended
qgroupid =C2=A0 =C2=A0 =C2=A0 =C2=A0 rfer =C2=A0 =C2=A0 =C2=A0 =C2=A0 excl=
 =C2=A0 =C2=A0 max_rfer =C2=A0 =C2=A0 max_excl
-------- =C2=A0 =C2=A0 =C2=A0 =C2=A0 ---- =C2=A0 =C2=A0 =C2=A0 =C2=A0 ----=
 =C2=A0 =C2=A0 -------- =C2=A0 =C2=A0 --------
0/275 =C2=A0 =C2=A0 =C2=A0 =C2=A056=2E52MiB =C2=A0 =C2=A0 56=2E52MiB =C2=
=A0 =C2=A0 =C2=A05=2E00GiB =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
=C2=A0
The following subvolumes do exist:
=C2=A0btrfs su li /
ID 257 gen 134 top level 5 path @
ID 258 gen 36271 top level 257 path @/=2Esnapshots
ID 259 gen 36312 top level 258 path @/=2Esnapshots/1/snapshot
ID 260 gen 33772 top level 257 path @/boot/grub2/i386-pc
ID 261 gen 33772 top level 257 path @/boot/grub2/x86_64-efi
ID 262 gen 36311 top level 257 path @/opt
ID 263 gen 33772 top level 257 path @/srv
ID 264 gen 36312 top level 257 path @/tmp
ID 265 gen 35961 top level 257 path @/usr/local
ID 266 gen 36310 top level 257 path @/var/cache
ID 267 gen 33772 top level 257 path @/var/crash
ID 268 gen 33772 top level 257 path @/var/lib/libvirt/images
ID 269 gen 33772 top level 257 path @/var/lib/machines
ID 270 gen 33772 top level 257 path @/var/lib/mailman
ID 271 gen 33772 top level 257 path @/var/lib/mariadb
ID 272 gen 33772 top level 257 path @/var/lib/mysql
ID 273 gen 33772 top level 257 path @/var/lib/named
ID 274 gen 33772 top level 257 path @/var/lib/pgsql
ID 275 gen 36312 top level 257 path @/var/log
ID 276 gen 33772 top level 257 path @/var/opt
ID 277 gen 36312 top level 257 path @/var/spool
ID 278 gen 36309 top level 257 path @/var/tmp
ID 279 gen 36311 top level 257 path @/home
ID 280 gen 36311 top level 257 path @/usr/sap
ID 308 gen 17373 top level 258 path @/=2Esnapshots/19/snapshot
ID 309 gen 17373 top level 258 path @/=2Esnapshots/20/snapshot
ID 315 gen 17373 top level 258 path @/=2Esnapshots/25/snapshot
=C2=A0
This is the additional information demanded when asking a support question=
:

lvevm117:~ # uname -a
Linux lvevm117 4=2E4=2E162-94=2E72-default #1 SMP Mon Nov 12 18:57:45 UTC =
2018 (9de753f) x86_64 x86_64 x86_64 GNU/Linux
=C2=A0
lvevm117:~ # btrfs --version
btrfs-progs v4=2E5=2E3+20160729
=C2=A0
lvevm117:~ # btrfs fi show
Label: none =C2=A0uuid: fbe2e4f1-2ccd-44df-bc35-790c5e019d66
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Total devices 1 FS bytes used 8=2E78GiB
=C2=A0 =C2=A0 =C2=A0 =C2=A0 devid =C2=A0 =C2=A01 size 198=2E84GiB used 23=
=2E07GiB path /dev/sda3
=C2=A0
lvevm117:~ # btrfs fi df /
Data, single: total=3D20=2E01GiB, used=3D8=2E37GiB
System, DUP: total=3D32=2E00MiB, used=3D16=2E00KiB
Metadata, DUP: total=3D1=2E50GiB, used=3D414=2E19MiB
GlobalReserve, single: total=3D27=2E38MiB, used=3D0=2E00B
=C2=A0
=C2=A0
THX
