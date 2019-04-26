Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9067BC43218
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 18:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF974208CA
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 18:11:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=inflaton.co.jp header.i=@inflaton.co.jp header.b="UdHeutzD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfDZSL4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 14:11:56 -0400
Received: from mailgw1-54.conoha.ne.jp ([163.44.187.54]:43037 "EHLO
        mailgw1.conoha.ne.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbfDZSL4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 14:11:56 -0400
Received: from mail1.conoha.ne.jp (unknown [172.16.42.13])
        by mailgw1.conoha.ne.jp (Postfix) with ESMTP id 93B0A180135719;
        Sat, 27 Apr 2019 03:11:53 +0900 (JST)
Received: from hydrangea (p191169-ipngn6801hodogaya.kanagawa.ocn.ne.jp [124.87.185.169])
        by mail1.conoha.ne.jp (Postfix) with ESMTPSA id 71045200B798E;
        Sat, 27 Apr 2019 03:11:53 +0900 (JST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail1.conoha.ne.jp 71045200B798E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inflaton.co.jp;
        s=default; t=1556302313;
        bh=2tkYgKwWE4aoP7KMll7raJ3z6nqK49Qbi4vAslyMYNw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UdHeutzDcEboXGoC9s3PevfMi0UwXJOliOReHPwZFFFY8CuoBmW7/ND8SuUbO5qT+
         W3VISUSRy8+kaBy5+afsU7mwAgQBvsc3JPV+y+w69F13v4Ac6R82Y403QioruatkjT
         7CwO6mJzCK+iVZhn74bJ0zmhRhLr1Ke5PXmJT8ah3jZqMFAnLFbYecaPwsRLtp49lE
         H+9OVmRZZLUZ0sEFF7vgvVAP7/sJbVb/zCeChMi24wH6i798KD6M87uuAyjY9KBAzC
         VMMTkjqjQ9pi+AUaUNfmN3Esp5WwzpMdwekBSbMmC6qT/vR2qj140a+fXHhgtOI+KM
         PhaK2zLN5/WNw==
Date:   Sat, 27 Apr 2019 03:12:25 +0900
From:   MASAKI Haruka <reasonset@inflaton.co.jp>
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Some file lost when send back snapshot.
Message-ID: <20190427031225.7f04d7bb@hydrangea>
In-Reply-To: <efad3130-e13d-2649-556e-6e932e5a4dc6@gmail.com>
References: <20190425223457.5a7dfd20@hydrangea>
        <aa5623ca-e1c2-4499-75ee-be818acf3333@gmail.com>
        <20190426135027.62dcaa31@hydrangea>
        <efad3130-e13d-2649-556e-6e932e5a4dc6@gmail.com>
Organization: Inflaton, Inc.
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> You have two subvolumes with the same received_uuid. Is the content of
> these subvolumes the same? Is "missing" file present in both subvolumes?

No, each subvolume name (190312-010100, 190315-001000) is timestamp.
These snapshot volumes were created by job scheduler on original (already l=
ost) volume, so 190315-001000 is modified from 190312-010100.

190315-001000 has lost file,
% ls /HySlave/190315-001000/local/pub/media/sound/notmusic_in_CD/
Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  kid-mem=
ories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala

but 190312-010100 doesn't.
% ls /HySlave/190312-010100/local/pub/media/sound/notmusic_in_CD/
Little_My_Maid  el_louis  firstkiss  gakuensai  infinity-kid  kid-memories-=
off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala




On Fri, 26 Apr 2019 20:30:07 +0300
Andrei Borzenkov <arvidjaar@gmail.com> wrote:

> 26.04.2019 7:50, MASAKI Haruka =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > Thank you for your reply.
> >=20
> > # What does
> >=20
> > @Host A ("lily" master, new volume)
> > aki@lily /mnt % socat TCP-LISTEN:25500 STDOUT | sudo btrfs receive -vv =
.=20
> >=20
> > @Host B ("daisy" backup, having volumes)
> > aki@daisy /HySlave % sudo btrfs send -v 190315-001000 | socat STDIN TCP=
:lily.local:25500=20
> >=20
> > ( ...Transfared 11TB... )
> >=20
> > @Host A
> > aki@lily /mnt % sudo btrfs subvolume snapshot 190315-001000 world
> > Create a snapshot of '190315-001000' in './world'
> > aki@lily /mnt % sudo btrfs subvolume snapshot -r world back1
> > Create a readonly snapshot of 'world' in './back1'
> >=20
> > @Host A
> > aki@lily /mnt % sudo btrfs send -vv -p 190315-001000 back1 | socat STDI=
N tcp-connect:192.168.1.17:25555
> > At subvol back1
> > BTRFS_IOC_SEND returned 0
> > joining genl thread
> >=20
> > @Host B
> > root@daisy /HySlave # socat TCP-LISTEN:25555 STDOUT | btrfs receive -vv=
 .
> > At snapshot back1
> > receiving snapshot back1 uuid=3D32dda1a2-07bd-684f-b773-c5b4cd5f29c1, c=
transid=3D2658 parent_uuid=3D9c10b77f-74fb-f94a-9a24-3c6d30c00ca2, parent_c=
transid=3D2658
> > BTRFS_IOC_SET_RECEIVED_SUBVOL uuid=3D32dda1a2-07bd-684f-b773-c5b4cd5f29=
c1, stransid=3D2658
> >=20
> > # Host A current
> >=20
> > aki@lily /mnt % ls
> > 190315-001000  back1  back2  world
> > aki@lily /mnt % sudo btrfs sub li -Rqu .
> > ID 258 gen 2698 top level 5 parent_uuid -                              =
      received_uuid 9c10b77f-74fb-f94a-9a24-3c6d30c00ca2 uuid bc90d05c-7430=
-7b42-b683-702d906bb993 path 190315-001000
> > ID 2139 gen 2696 top level 5 parent_uuid bc90d05c-7430-7b42-b683-702d90=
6bb993 received_uuid -                                    uuid 23c5fede-a33=
8-d14a-afcd-677db2e97637 path world
> > ID 2140 gen 2660 top level 5 parent_uuid 23c5fede-a338-d14a-afcd-677db2=
e97637 received_uuid -                                    uuid 32dda1a2-07b=
d-684f-b773-c5b4cd5f29c1 path back1
> > ID 2142 gen 2672 top level 5 parent_uuid 23c5fede-a338-d14a-afcd-677db2=
e97637 received_uuid -                                    uuid a8e3e041-c1f=
c-e443-9baf-ab481ae32b8b path back2
> >=20
> >=20
> > # Host B current
> >=20
> > aki@daisy /HySlave % pwd
> > /HySlave
> > aki@daisy /HySlave % ls
> > 190312-010100  190315-001000  back1  back2
> > [aki@daisy HySlave]$ sudo btrfs sub li -Rqu .
> > ID 256 gen 36238 top level 5 parent_uuid -                             =
       received_uuid -                                    uuid 4e42555d-a71=
5-0e47-bd0e-85d6eb8911e0 path slave
> > ID 259 gen 35116 top level 256 parent_uuid -                           =
         received_uuid 9c10b77f-74fb-f94a-9a24-3c6d30c00ca2 uuid 4a91d585-a=
b25-0c49-b183-ae951b5377e1 path 190312-010100
> > ID 3059 gen 7273 top level 256 parent_uuid 4a91d585-ab25-0c49-b183-ae95=
1b5377e1 received_uuid 9c10b77f-74fb-f94a-9a24-3c6d30c00ca2 uuid 114cd74f-8=
0d8-af44-a9d0-fd8ce3c991b4 path 190315-001000
>=20
> You have two subvolumes with the same received_uuid. Is the content of
> these subvolumes the same? Is "missing" file present in both subvolumes?
>=20
> > ID 3072 gen 35112 top level 256 parent_uuid 4a91d585-ab25-0c49-b183-ae9=
51b5377e1 received_uuid 32dda1a2-07bd-684f-b773-c5b4cd5f29c1 uuid fe7281d1-=
8b3e-8f46-a0b4-cdc52a1bb7aa path back1
> > ID 3073 gen 36236 top level 256 parent_uuid 4a91d585-ab25-0c49-b183-ae9=
51b5377e1 received_uuid a8e3e041-c1fc-e443-9baf-ab481ae32b8b uuid 65206183-=
f20d-4648-83ab-e0485b16f7af path back2
> >=20
> > # Files missing
> >=20
> > aki@daisy /HySlave % ls /HySlave/190315-001000/local/pub/media/sound/no=
tmusic_in_CD=20
> > Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  kid=
-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >=20
> > aki@daisy /HySlave % ls /HySlave/back1/local/pub/media/sound/notmusic_i=
n_CD
> > Little_My_Maid  el_louis  firstkiss  gakuensai  infinity-kid  kid-memor=
ies-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >=20
> > aki@lily /mnt % ls /mnt/190315-001000/local/pub/media/sound/notmusic_in=
_CD
> > Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  kid=
-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >=20
> > ki@lily /mnt % ls /mnt/back1/local/pub/media/sound/notmusic_in_CD      =
 =20
> > Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  kid=
-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >=20
> > aki@lily /mnt % ls /mnt/world/local/pub/media/sound/notmusic_in_CD=20
> > Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  kid=
-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> >=20
> >=20
> > SMEE is missing.
> >=20
> >=20
> >=20
> >=20
> > Thanks.
> >=20
> >=20
> > On Thu, 25 Apr 2019 20:55:59 +0300
> > Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> >=20
> >> 25.04.2019 16:34, MASAKI Haruka =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>  [...] =20
> >>
> >> Please show
> >>
> >> 1. Full protocol of commands you executed (commands and their output),
> >> e.g. captured using script.
> >> 2. Commands used to determine missing files on both source and receive
> >> sides.
> >> 3. Listing of subvolumes on both source and receive sides with
> >>
> >> btrfs sub li -Rqu /mount/point
> >>
> >>  [...] =20
> >>
>=20
