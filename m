Return-Path: <SRS0=mU8m=PA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929DAC43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 12:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E6D721849
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 12:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=web.de header.i=@web.de header.b="jvqe8KrR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbeLWMq4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Dec 2018 07:46:56 -0500
Received: from mout.web.de ([212.227.15.4]:48293 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbeLWMq4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Dec 2018 07:46:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1545569213;
        bh=WOgFVljh42OsJ3mFLz6FlAe9ga/5IMhw2s9Hgdz5HVQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=jvqe8KrRF74682ac/l+1n5LuX4sPBFUDVGCR/pq81Q3o/YkbS8GdDmd7N1pkwIFKY
         2d1ThSByKGfbJnfdjKUIDW43vkSDTMj62y1dXSkn4LD1ijrOqf4mtIbjVJ8YbR9AaL
         zfFnflp31awJDN9n8QGjwBzO6VN8zlZGrQqET1Iw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [94.79.184.225] ([94.79.184.225]) by web-mail.web.de
 (3c-app-webde-bs12.server.lan [172.19.170.12]) (via HTTP); Sun, 23 Dec 2018
 13:46:53 +0100
MIME-Version: 1.0
Message-ID: <trinity-d2464fff-db28-4205-9fe2-db6d5e1879ea-1545569213648@3c-app-webde-bs12>
From:   c.monty@web.de
To:     "Andrei Borzenkov" <arvidjaar@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Aw: Re: Defining quota on /home
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 23 Dec 2018 13:46:53 +0100
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
X-Provags-ID: V03:K1:fAcyGtOfphBe+mCmQjP3dVIRJf6IK//8esOwFhyvwGatb4lRyFtBo51s8zM5G1ZjwTwc3
 2zfpp7hc45ocEJ+jn+1C7qEW9bL79zOF2A+iARys+PEp3Xeg3bboI5IqxhD8ZGYNvmbfb/wot3vo
 EABW+gPq3H+TRJoEU0QxbgBfrKY2PFmSHweb5lN5b7e7fURsv7BaHB3i7Ewkxoif4veiAuYseZaT
 LtnZxDv7TIMqqzkeQp2KRlGHqISvl8hyD2STp8V/pit+6yGH74BiqWH1yYu2pO+I8IUGsmbDlqFd
 u8=
X-UI-Out-Filterresults: notjunk:1;V03:K0:KwG029qSaNY=:HtouMcp+M7kZMQExSUCEvB
 oU6WjdN5d+Cw3h94UGGKipthlVzEd1broFW92SW6PAK6T9aUP2es1UweK/fOFjEAZngPfU65N
 KnuhppJiRjr7CEItbUJf/NYx4rzY7P8f0gh5a+0qbq77eNWsvHF2EEFiY6OIJkL7+RxDCrPCf
 lRCZQM6DPRUmQNbI+tRzSSRVUqL/mALi3AXhkKbylkH3nRDKbMB67E0QQxHynBTnbutDxv6EB
 K/yCDRC8fro4+SfyZjxq3qy63NrUYk6Q8wjl170j2rqBwAgPSk7imoFun+9mE9cJDfOGfwlrH
 zwbap84drJ9VAeUvz0AZ5ZIWbdwgL+FbDV3J0HM66ohvy09HmM6XAaJK39U3CnYRy5OdMAtCs
 zAce4i7wMo7P1yvZpLms/n/C9Jlo9V87i9ikSu8kNohjjHzuBAJJD9rHwvm3yq7i1NN0cnH2+
 04rhjwckr9ALLgmWev4qKCPHgt4scVhNgO/6DQGPlXsa3xISYYeDHeSgiFyVfUhr2EM6TUIsU
 d2kYcD6c6eybD0JFm9FTwtCFcXt6/ZF5YgxRe8ait3uy45k47ZivDl+AhOvPkaJ+g==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



I'm sorry=2E
Of course the line
0/279 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1=2E79GiB =C2=A0 =C2=A0 =C2=A01=2E79GiB =
=C2=A0 =C2=A0150=2E00GiB =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
is correct=2E

The issue is with this line:
255/279 =C2=A0 =C2=A0 =C2=A0 1=2E79GiB =C2=A0 =C2=A0 =C2=A01=2E79GiB =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 none =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
I didn't define a quota like this=2E

THX
=C2=A0

Gesendet:=C2=A0Samstag, 22=2E Dezember 2018 um 05:07 Uhr
Von:=C2=A0"Andrei Borzenkov" <arvidjaar@gmail=2Ecom>
An:=C2=A0c=2Emonty@web=2Ede, linux-btrfs@vger=2Ekernel=2Eorg
Betreff:=C2=A0Re: Defining quota on /home
21=2E12=2E2018 17:22, c=2Emonty@web=2Ede =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> Hi,
> =C2=A0
> I have defined a quota on home with these steps:
> 1=2E=C2=A0btrfs quota enable /home
> 2=2E=C2=A0btrfs qgroup limit 150G /home
> =C2=A0
> Now I can verify the corresponding setting:
> btrfs qgroup show -reF /home
> WARNING: Qgroup data inconsistent, rescan recommended
> qgroupid =C2=A0 =C2=A0 =C2=A0 =C2=A0 rfer =C2=A0 =C2=A0 =C2=A0 =C2=A0 ex=
cl =C2=A0 =C2=A0 max_rfer =C2=A0 =C2=A0 max_excl
> -------- =C2=A0 =C2=A0 =C2=A0 =C2=A0 ---- =C2=A0 =C2=A0 =C2=A0 =C2=A0 --=
-- =C2=A0 =C2=A0 -------- =C2=A0 =C2=A0 --------
> 0/279 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1=2E79GiB =C2=A0 =C2=A0 =C2=A01=2E79Gi=
B =C2=A0 =C2=A0150=2E00GiB =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
> 255/279 =C2=A0 =C2=A0 =C2=A0 1=2E79GiB =C2=A0 =C2=A0 =C2=A01=2E79GiB =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 none =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
> =C2=A0
> However I don't understand the line with qgroupid 0/279?!?
> =C2=A0

This is default quota group created automatically for each subvolume=2E Or
do you mean 255/279?

> I have created another quota earlier for /var/log, and there's no second=
 line in output of=C2=A0btrfs qgroup show:
> btrfs qgroup show -reF /var/log
> WARNING: Qgroup data inconsistent, rescan recommended
> qgroupid =C2=A0 =C2=A0 =C2=A0 =C2=A0 rfer =C2=A0 =C2=A0 =C2=A0 =C2=A0 ex=
cl =C2=A0 =C2=A0 max_rfer =C2=A0 =C2=A0 max_excl
> -------- =C2=A0 =C2=A0 =C2=A0 =C2=A0 ---- =C2=A0 =C2=A0 =C2=A0 =C2=A0 --=
-- =C2=A0 =C2=A0 -------- =C2=A0 =C2=A0 --------
> 0/275 =C2=A0 =C2=A0 =C2=A0 =C2=A056=2E52MiB =C2=A0 =C2=A0 56=2E52MiB =C2=
=A0 =C2=A0 =C2=A05=2E00GiB =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
> =C2=A0
> The following subvolumes do exist:
> =C2=A0btrfs su li /
> ID 257 gen 134 top level 5 path @
> ID 258 gen 36271 top level 257 path @/=2Esnapshots
> ID 259 gen 36312 top level 258 path @/=2Esnapshots/1/snapshot
> ID 260 gen 33772 top level 257 path @/boot/grub2/i386-pc
> ID 261 gen 33772 top level 257 path @/boot/grub2/x86_64-efi
> ID 262 gen 36311 top level 257 path @/opt
> ID 263 gen 33772 top level 257 path @/srv
> ID 264 gen 36312 top level 257 path @/tmp
> ID 265 gen 35961 top level 257 path @/usr/local
> ID 266 gen 36310 top level 257 path @/var/cache
> ID 267 gen 33772 top level 257 path @/var/crash
> ID 268 gen 33772 top level 257 path @/var/lib/libvirt/images
> ID 269 gen 33772 top level 257 path @/var/lib/machines
> ID 270 gen 33772 top level 257 path @/var/lib/mailman
> ID 271 gen 33772 top level 257 path @/var/lib/mariadb
> ID 272 gen 33772 top level 257 path @/var/lib/mysql
> ID 273 gen 33772 top level 257 path @/var/lib/named
> ID 274 gen 33772 top level 257 path @/var/lib/pgsql
> ID 275 gen 36312 top level 257 path @/var/log
> ID 276 gen 33772 top level 257 path @/var/opt
> ID 277 gen 36312 top level 257 path @/var/spool
> ID 278 gen 36309 top level 257 path @/var/tmp
> ID 279 gen 36311 top level 257 path @/home
> ID 280 gen 36311 top level 257 path @/usr/sap
> ID 308 gen 17373 top level 258 path @/=2Esnapshots/19/snapshot
> ID 309 gen 17373 top level 258 path @/=2Esnapshots/20/snapshot
> ID 315 gen 17373 top level 258 path @/=2Esnapshots/25/snapshot
> =C2=A0
> This is the additional information demanded when asking a support questi=
on:
>
> lvevm117:~ # uname -a
> Linux lvevm117 4=2E4=2E162-94=2E72-default #1 SMP Mon Nov 12 18:57:45 UT=
C 2018 (9de753f) x86_64 x86_64 x86_64 GNU/Linux
> =C2=A0
> lvevm117:~ # btrfs --version
> btrfs-progs v4=2E5=2E3+20160729
> =C2=A0
> lvevm117:~ # btrfs fi show
> Label: none =C2=A0uuid: fbe2e4f1-2ccd-44df-bc35-790c5e019d66
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Total devices 1 FS bytes used 8=2E78GiB
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 devid =C2=A0 =C2=A01 size 198=2E84GiB used 2=
3=2E07GiB path /dev/sda3
> =C2=A0
> lvevm117:~ # btrfs fi df /
> Data, single: total=3D20=2E01GiB, used=3D8=2E37GiB
> System, DUP: total=3D32=2E00MiB, used=3D16=2E00KiB
> Metadata, DUP: total=3D1=2E50GiB, used=3D414=2E19MiB
> GlobalReserve, single: total=3D27=2E38MiB, used=3D0=2E00B
> =C2=A0
> =C2=A0
> THX
>
=C2=A0
