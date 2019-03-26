Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5F2C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 08:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29C4A20856
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 08:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="OxmaJgFt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbfCZIxh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 04:53:37 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:32137 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730569AbfCZIxh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 04:53:37 -0400
Date:   Tue, 26 Mar 2019 08:53:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1553590415;
        bh=yl8TKUuIxZff3An/Lvzc9235Ai4QzURnY5JcdydQt4Q=;
        h=Date:To:From:Reply-To:Subject:In-Reply-To:References:Feedback-ID:
         From;
        b=OxmaJgFtK6EjJ7lWx1YgoZWBomn5d+t6YrWnwWw8km36BryXHNAm6X7ANCKcZxVHp
         aCAfj3fDfqrgMrFjksXKu6W+XNCdt8lyJ1vSlKHFs2aXArsIUGdn2B1EKxeCSoSqXU
         J7K0LCCbvD4m3JP+1p7xFVL0BE7RMD0cUEVgqd5w=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   berodual_xyz <berodual_xyz@protonmail.com>
Reply-To: berodual_xyz <berodual_xyz@protonmail.com>
Subject: =?UTF-8?Q?Re:_backup_uuid=5Ftree_generation_not_consistent_across_multi_d?=
 =?UTF-8?Q?evice_(raid0)_btrfs_-_won=C2=B4t_mount?=
Message-ID: <Ss8NQpM2qm6Kzxyf91owWX6RXcTEwUybuYNqNusRfZXsTGQCijU0lGrRDTMsTU7ExQP3b1XZPqzXDVPgOJei71X-EbdWUvpRzPMixHWUkWs=@protonmail.com>
In-Reply-To: <QXHERo-tRpJm0-hY7ZotKSeF7CfsqeoH0XAf-wmRRsbzVuNWv6BTb9Q2xLQ_KgLlJNQJNSjGK9xlYcqv6QP3kKpFsvtyN0CBex5bFTCjiNE=@protonmail.com>
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com>
 <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
 <QXHERo-tRpJm0-hY7ZotKSeF7CfsqeoH0XAf-wmRRsbzVuNWv6BTb9Q2xLQ_KgLlJNQJNSjGK9xlYcqv6QP3kKpFsvtyN0CBex5bFTCjiNE=@protonmail.com>
Feedback-ID: I1q2L7VvFsdXESkLE1a2aLBALpN2HWsXO5F205qEARYXtg94zW3HdiV9HI52kzHEEqfcUdbqlfVMVRPA6rJltg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thank you both for your input.

see below.

> > You sda and sdb are at gen 60233 while sdd and sde are at gen 60234.
> > It's possible to allow kernel to manually assemble its device list usin=
g
> > "device=3D" mount option.
> > Since you're using RAID6, it's possible to recover using 2 devices only=
,
> > but in that case you need "degraded" mount option.
>
> He has btrfs raid0 profile on top of hardware RAID6 devices.

Correct, my FS is a "raid0" across four hardware-raid based raid6 devices. =
The underlying devices of the raid controller are fine, same as the volumes=
 themselves.

Only corruption seems to be on the btrfs side.

Does your tip regarding mounting by explicitly specifying the devices still=
 make sense? Will this figure out automatically which generation to use?

I am at the moment in the process of using "btrfs restore" to pull more dat=
a from the filesystem without making any further changes.

After that I am happy to continue testing, and will happily test your menti=
oned "skip_bg" patch - but if you think that there is some other way to mou=
nt (just for recovery purpose - read only is fine!) while having different =
gens on the devices, I highly appreciate it.

Thanks Qu and Andrei!
