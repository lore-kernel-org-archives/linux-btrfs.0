Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FE4C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 10:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1C0820856
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 10:24:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="yJOhwpZg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbfCZKYR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 06:24:17 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:26972 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731430AbfCZKYQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 06:24:16 -0400
Date:   Tue, 26 Mar 2019 10:24:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1553595851;
        bh=Q7OxGCqS1Tq07VCDChFMhTz+gHswBqORVuINwgnHaAo=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=yJOhwpZgL0i3lGduFn5EzmNAlTQ/MkVJ4ZZZsoh+gMgeSmFu19lsRVmo4f3n0+x2H
         DHyPSngvgYtAIiGYM4EFDitwCVJe4buTSXj9n2SxRm+X+2odl74+2TcPRAik5usRGo
         1N8BWb4h3Te4uxNTN5PtsZL2ao+y4IJ7roysl3qk=
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
From:   berodual_xyz <berodual_xyz@protonmail.com>
Cc:     Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Reply-To: berodual_xyz <berodual_xyz@protonmail.com>
Subject: =?UTF-8?Q?Re:_backup_uuid=5Ftree_generation_not_consistent_across_multi_d?=
 =?UTF-8?Q?evice_(raid0)_btrfs_-_won=C2=B4t_mount?=
Message-ID: <j90OHVlIntkt3OHfCO0q8JaXXpDB-cDjDHuKXxuu6gQ64-FYSSZ4YuTU5bZnbfre7XWiymFCF9ZgK9RZ-5ljjEoOqZJtYDcjLad4zLF1Axs=@protonmail.com>
In-Reply-To: <cc557b84-602c-8b2e-33f9-3c6d56578631@gmx.com>
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com>
 <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
 <QXHERo-tRpJm0-hY7ZotKSeF7CfsqeoH0XAf-wmRRsbzVuNWv6BTb9Q2xLQ_KgLlJNQJNSjGK9xlYcqv6QP3kKpFsvtyN0CBex5bFTCjiNE=@protonmail.com>
 <cc557b84-602c-8b2e-33f9-3c6d56578631@gmx.com>
Feedback-ID: I1q2L7VvFsdXESkLE1a2aLBALpN2HWsXO5F205qEARYXtg94zW3HdiV9HI52kzHEEqfcUdbqlfVMVRPA6rJltg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Mount messages below.

Thanks for your input, Qu!

##
[42763.884134] BTRFS info (device sdd): disabling free space tree
[42763.884138] BTRFS info (device sdd): force clearing of disk cache
[42763.884140] BTRFS info (device sdd): has skinny extents
[42763.885207] BTRFS error (device sdd): parent transid verify failed on 10=
48576 wanted 60234 found 60230
[42763.885263] BTRFS error (device sdd): failed to read chunk root
[42763.900922] BTRFS error (device sdd): open_ctree failed
##




Sent with ProtonMail Secure Email.

=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Tuesday, 26. March 2019 10:21, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> On 2019/3/26 =E4=B8=8B=E5=8D=884:52, berodual_xyz wrote:
>
> > Thank you both for your input.
> > see below.
> >
> > > > You sda and sdb are at gen 60233 while sdd and sde are at gen 60234=
.
> > > > It's possible to allow kernel to manually assemble its device list =
using
> > > > "device=3D" mount option.
> > > > Since you're using RAID6, it's possible to recover using 2 devices =
only,
> > > > but in that case you need "degraded" mount option.
> > >
> > > He has btrfs raid0 profile on top of hardware RAID6 devices.
> >
> > Correct, my FS is a "raid0" across four hardware-raid based raid6 devic=
es. The underlying devices of the raid controller are fine, same as the vol=
umes themselves.
>
> Then there is not much we can do.
>
> The super blocks shows all your 4 devices are in 2 different states.
> (older generation with dirt log, newer generation without log).
>
> This means some writes didn't reach all devices.
>
> > Only corruption seems to be on the btrfs side.
>
> Please provide the kernel message when trying to mount the fs.
>
> > Does your tip regarding mounting by explicitly specifying the devices s=
till make sense?
>
> Not really. For RAID0 case, it doesn't make much sense.
>
> > Will this figure out automatically which generation to use?
>
> You could try, as all the mount option is making btrfs completely RO (no
> log replay), so it should be pretty safe.
>
> > I am at the moment in the process of using "btrfs restore" to pull more=
 data from the filesystem without making any further changes.
> > After that I am happy to continue testing, and will happily test your m=
entioned "skip_bg" patch - but if you think that there is some other way to=
 mount (just for recovery purpose - read only is fine!) while having differ=
ent gens on the devices, I highly appreciate it.
>
> With mounting failure dmesg, it should be pretty easy to determine
> whether my skip_bg will work.
>
> Thanks,
> Qu
>
> > Thanks Qu and Andrei!

