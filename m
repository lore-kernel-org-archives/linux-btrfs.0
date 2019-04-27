Return-Path: <SRS0=CP9i=S5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641A9C43218
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Apr 2019 05:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCA792087C
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Apr 2019 05:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=inflaton.co.jp header.i=@inflaton.co.jp header.b="k5tgcxjO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfD0FuZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Apr 2019 01:50:25 -0400
Received: from mailgw1-50.conoha.ne.jp ([163.44.187.50]:48036 "EHLO
        mailgw1.conoha.ne.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726005AbfD0FuZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Apr 2019 01:50:25 -0400
Received: from mail1.conoha.ne.jp (unknown [172.16.42.13])
        by mailgw1.conoha.ne.jp (Postfix) with ESMTP id 3B116180135FE6;
        Sat, 27 Apr 2019 14:50:21 +0900 (JST)
Received: from hydrangea (p191169-ipngn6801hodogaya.kanagawa.ocn.ne.jp [124.87.185.169])
        by mail1.conoha.ne.jp (Postfix) with ESMTPSA id 1B0A9200B798E;
        Sat, 27 Apr 2019 14:50:20 +0900 (JST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail1.conoha.ne.jp 1B0A9200B798E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inflaton.co.jp;
        s=default; t=1556344221;
        bh=2XfKozJLMVetDKlXyS19obVzptOHiSTObnQUlrq64OA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k5tgcxjOxlpanxOT2SYQadDtu/pZDv2dfoDUMg7vKXEMH/sF5aQA1mHlFhvfLmCi4
         3/yA6F3GzF5dp5+BlGVYVzK9wt6uoA60FTua41tZVeyd/ROT53wNO6DdFJ8Ck74h/q
         fsRqaWFyAuKZc/eqA/ncC9gqMukx9viZsroGv0SsEGddOGsLAHWFy4+34AJkBZEDXp
         CL2V5eRfZngvMTG2KCncO6k9bCBDWIfRxX9tRNCwxxjAS2CDwOsloIMor3R77qDNds
         AZ/lZFR3kZOn5QLM30juzhUS6iXCyeDCzFZ/sQDCSE/wYyY9Vfx3fC//ByIGKKR4VV
         tZb8VPGjjlZZg==
Date:   Sat, 27 Apr 2019 14:50:53 +0900
From:   MASAKI Haruka <reasonset@inflaton.co.jp>
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Some file lost when send back snapshot.
Message-ID: <20190427145053.250bda47@hydrangea>
In-Reply-To: <8cdd6929-b768-795c-162f-cf41e8b94029@gmail.com>
References: <20190425223457.5a7dfd20@hydrangea>
        <aa5623ca-e1c2-4499-75ee-be818acf3333@gmail.com>
        <20190426135027.62dcaa31@hydrangea>
        <efad3130-e13d-2649-556e-6e932e5a4dc6@gmail.com>
        <20190427031225.7f04d7bb@hydrangea>
        <8cdd6929-b768-795c-162f-cf41e8b94029@gmail.com>
Organization: Inflaton, Inc.
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, 26 Apr 2019 21:27:52 +0300
Andrei Borzenkov <arvidjaar@gmail.com> wrote:

> 26.04.2019 21:12, MASAKI Haruka =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >> You have two subvolumes with the same received_uuid. Is the content of
> >> these subvolumes the same? Is "missing" file present in both subvolume=
s?
> >=20
> > No, each subvolume name (190312-010100, 190315-001000) is timestamp.
> > These snapshot volumes were created by job scheduler on original (alrea=
dy lost) volume, so 190315-001000 is modified from 190312-010100.
> >=20
>=20
> Which is your problem. Two subvolumes with the same received_uuid are
> expected to have exactly the same content (received_uuid can be viewed
> as dataset UUID). You send incremental stream against base uuid
> 9c10b77f-74fb-f94a-9a24-3c6d30c00ca2; on receiving side btrfs receive
> looks for matching base subvolume and happens to pick 190312-010100.
>=20
> There were patches to automatically remove received_uuid when subvolume
> is changed to read-write. I do not know whether they were applied.
>=20
> btrfs send/receive expects subvolumes to remain read-only. As soon as
> you start fiddling with read-only status you already lost. btrfs should
> have never allowed to change read-only into read-write in the first place.
>=20

Thanks it was solved!

I remember change attributes on original volume.

I deleted 190312-010100 and send back1, it's OK.
I learned that shouldn't change subvolume read-only to read-write.

Thank you very much!!!



> > 190315-001000 has lost file,
> > % ls /HySlave/190315-001000/local/pub/media/sound/notmusic_in_CD/
> > Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  kid=
-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >=20
> > but 190312-010100 doesn't.
> > % ls /HySlave/190312-010100/local/pub/media/sound/notmusic_in_CD/
> > Little_My_Maid  el_louis  firstkiss  gakuensai  infinity-kid  kid-memor=
ies-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >=20
> >=20
> >=20
> >=20
> > On Fri, 26 Apr 2019 20:30:07 +0300
> > Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> >=20
> >> 26.04.2019 7:50, MASAKI Haruka =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>> Thank you for your reply.
> >>>
> >>> # What does
> >>>
> >>> @Host A ("lily" master, new volume)
> >>> aki@lily /mnt % socat TCP-LISTEN:25500 STDOUT | sudo btrfs receive -v=
v .=20
> >>>
> >>> @Host B ("daisy" backup, having volumes)
> >>> aki@daisy /HySlave % sudo btrfs send -v 190315-001000 | socat STDIN T=
CP:lily.local:25500=20
> >>>
> >>> ( ...Transfared 11TB... )
> >>>
> >>> @Host A
> >>> aki@lily /mnt % sudo btrfs subvolume snapshot 190315-001000 world
> >>> Create a snapshot of '190315-001000' in './world'
> >>> aki@lily /mnt % sudo btrfs subvolume snapshot -r world back1
> >>> Create a readonly snapshot of 'world' in './back1'
> >>>
> >>> @Host A
> >>> aki@lily /mnt % sudo btrfs send -vv -p 190315-001000 back1 | socat ST=
DIN tcp-connect:192.168.1.17:25555
> >>> At subvol back1
> >>> BTRFS_IOC_SEND returned 0
> >>> joining genl thread
> >>>
> >>> @Host B
> >>> root@daisy /HySlave # socat TCP-LISTEN:25555 STDOUT | btrfs receive -=
vv .
> >>> At snapshot back1
> >>> receiving snapshot back1 uuid=3D32dda1a2-07bd-684f-b773-c5b4cd5f29c1,=
 ctransid=3D2658 parent_uuid=3D9c10b77f-74fb-f94a-9a24-3c6d30c00ca2, parent=
_ctransid=3D2658
> >>> BTRFS_IOC_SET_RECEIVED_SUBVOL uuid=3D32dda1a2-07bd-684f-b773-c5b4cd5f=
29c1, stransid=3D2658
> >>>
> >>> # Host A current
> >>>
> >>> aki@lily /mnt % ls
> >>> 190315-001000  back1  back2  world
> >>> aki@lily /mnt % sudo btrfs sub li -Rqu .
> >>> ID 258 gen 2698 top level 5 parent_uuid -                            =
        received_uuid 9c10b77f-74fb-f94a-9a24-3c6d30c00ca2 uuid bc90d05c-74=
30-7b42-b683-702d906bb993 path 190315-001000
> >>> ID 2139 gen 2696 top level 5 parent_uuid bc90d05c-7430-7b42-b683-702d=
906bb993 received_uuid -                                    uuid 23c5fede-a=
338-d14a-afcd-677db2e97637 path world
> >>> ID 2140 gen 2660 top level 5 parent_uuid 23c5fede-a338-d14a-afcd-677d=
b2e97637 received_uuid -                                    uuid 32dda1a2-0=
7bd-684f-b773-c5b4cd5f29c1 path back1
> >>> ID 2142 gen 2672 top level 5 parent_uuid 23c5fede-a338-d14a-afcd-677d=
b2e97637 received_uuid -                                    uuid a8e3e041-c=
1fc-e443-9baf-ab481ae32b8b path back2
> >>>
> >>>
> >>> # Host B current
> >>>
> >>> aki@daisy /HySlave % pwd
> >>> /HySlave
> >>> aki@daisy /HySlave % ls
> >>> 190312-010100  190315-001000  back1  back2
> >>> [aki@daisy HySlave]$ sudo btrfs sub li -Rqu .
> >>> ID 256 gen 36238 top level 5 parent_uuid -                           =
         received_uuid -                                    uuid 4e42555d-a=
715-0e47-bd0e-85d6eb8911e0 path slave
> >>> ID 259 gen 35116 top level 256 parent_uuid -                         =
           received_uuid 9c10b77f-74fb-f94a-9a24-3c6d30c00ca2 uuid 4a91d585=
-ab25-0c49-b183-ae951b5377e1 path 190312-010100
> >>> ID 3059 gen 7273 top level 256 parent_uuid 4a91d585-ab25-0c49-b183-ae=
951b5377e1 received_uuid 9c10b77f-74fb-f94a-9a24-3c6d30c00ca2 uuid 114cd74f=
-80d8-af44-a9d0-fd8ce3c991b4 path 190315-001000
> >>
> >> You have two subvolumes with the same received_uuid. Is the content of
> >> these subvolumes the same? Is "missing" file present in both subvolume=
s?
> >>
> >>> ID 3072 gen 35112 top level 256 parent_uuid 4a91d585-ab25-0c49-b183-a=
e951b5377e1 received_uuid 32dda1a2-07bd-684f-b773-c5b4cd5f29c1 uuid fe7281d=
1-8b3e-8f46-a0b4-cdc52a1bb7aa path back1
> >>> ID 3073 gen 36236 top level 256 parent_uuid 4a91d585-ab25-0c49-b183-a=
e951b5377e1 received_uuid a8e3e041-c1fc-e443-9baf-ab481ae32b8b uuid 6520618=
3-f20d-4648-83ab-e0485b16f7af path back2
> >>>
> >>> # Files missing
> >>>
> >>> aki@daisy /HySlave % ls /HySlave/190315-001000/local/pub/media/sound/=
notmusic_in_CD=20
> >>> Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  k=
id-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >>>
> >>> aki@daisy /HySlave % ls /HySlave/back1/local/pub/media/sound/notmusic=
_in_CD
> >>> Little_My_Maid  el_louis  firstkiss  gakuensai  infinity-kid  kid-mem=
ories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >>>
> >>> aki@lily /mnt % ls /mnt/190315-001000/local/pub/media/sound/notmusic_=
in_CD
> >>> Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  k=
id-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >>>
> >>> ki@lily /mnt % ls /mnt/back1/local/pub/media/sound/notmusic_in_CD    =
   =20
> >>> Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  k=
id-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >>>
> >>> aki@lily /mnt % ls /mnt/world/local/pub/media/sound/notmusic_in_CD=20
> >>> Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  k=
id-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >>>
> >>>
> >>> SMEE is missing.
> >>>
> >>>
> >>>
> >>>
> >>> Thanks.
> >>>
> >>>
> >>> On Thu, 25 Apr 2019 20:55:59 +0300
> >>> Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> >>>
> >>>> 25.04.2019 16:34, MASAKI Haruka =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>>  [...] =20
> >>>>
> >>>> Please show
> >>>>
> >>>> 1. Full protocol of commands you executed (commands and their output=
),
> >>>> e.g. captured using script.
> >>>> 2. Commands used to determine missing files on both source and recei=
ve
> >>>> sides.
> >>>> 3. Listing of subvolumes on both source and receive sides with
> >>>>
> >>>> btrfs sub li -Rqu /mount/point
> >>>>
> >>>>  [...] =20
> >>>>
> >>
>=20
