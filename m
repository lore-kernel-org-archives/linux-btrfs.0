Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424F2C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 13:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92E1B2146F
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 13:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="pb8aQzmY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731844AbfC0NDd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 09:03:33 -0400
Received: from mail-40135.protonmail.ch ([185.70.40.135]:39782 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731730AbfC0NDd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 09:03:33 -0400
Date:   Wed, 27 Mar 2019 13:03:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1553691809;
        bh=iJ6F1+Da/68c/Fl7jFhEsLkosm+Z4uR9XE2ruzJgb+k=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=pb8aQzmYW1i6GWzMYsNZYNeX/C/VFq6b/5S+I6x6oo48RduiGzo8IDqibSC04uL3n
         ObSex65iY8+3BmXc55sdgjeVBwJapAwwuuQJoGfkIwS6ZHpJy/N0XJi5ect/argkya
         A2cjj9p05fLW6koGyREEMA7udD0ZKMkiCXG//Qus=
To:     Chris Murphy <lists@colorremedies.com>
From:   berodual_xyz <berodual_xyz@protonmail.com>
Cc:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Reply-To: berodual_xyz <berodual_xyz@protonmail.com>
Subject: =?UTF-8?Q?Re:_backup_uuid=5Ftree_generation_not_consistent_across_multi_d?=
 =?UTF-8?Q?evice_(raid0)_btrfs_-_won=C2=B4t_mount?=
Message-ID: <DCcsgRDYyXTQg-tb_c9lhjSkEpt42ZH7R--Ln36pZpkNgAiQr54J8xLiGURKXVYv5fuQrAZA8xSD65ykmwyjCmPJYwAnAQFCU1uQWlZo6H4=@protonmail.com>
In-Reply-To: <CAJCQCtTZ1iP6dxL+E0Q7Ssa_zEikqWVkZsqHO7H429E0yV67PA@mail.gmail.com>
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com>
 <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
 <CAJCQCtTqnqxvFJ3xwHiYFfWThqAL2apxqT=q0PJMv37UPCHGew@mail.gmail.com>
 <CAJCQCtTZ1iP6dxL+E0Q7Ssa_zEikqWVkZsqHO7H429E0yV67PA@mail.gmail.com>
Feedback-ID: I1q2L7VvFsdXESkLE1a2aLBALpN2HWsXO5F205qEARYXtg94zW3HdiV9HI52kzHEEqfcUdbqlfVMVRPA6rJltg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Dear Chris,

correct - the metadata profile was set to single (with the thought of conso=
lidating metadata updates to a smaller subset of disks instead of creating =
IO overhead between "data" operations and "metadata" updates).

It seems that "-o clear_cache" was used early on in an attempt to fix the r=
oot issue of not being able to mount the filesystem (which was potentially =
a race condition between systemd not having the devices active and the moun=
t process)

I saw the posts regarding clear_cache corrupting filesystems. Could this be=
 the case here?

"btrfs restore" has retrieved a lot of the files (but not all) and unfortun=
ately most of the seem corrupt after about 1G file length. Smaller files se=
em fine.

My questions now:

* what is the chance of "btrfs rescue" "chunk-recover" / "super-recover" / =
"zero-log" having a positive effect on the filesystem.

* what is the chance of "btrfs check --init-extent-tree" fixing the describ=
ed issues?

It would be really important to try and recover as much as possible from th=
e filesystem. The users have learned their lessons reg. backups (they had o=
ne but it was not up2date, so worthless) but obviously no one would have ex=
pected a filesystem to just go bang like this.

Thanks again everyone reading and replying!

Marcel


Sent with ProtonMail Secure Email.

=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Tuesday, March 26, 2019 6:51 PM, Chris Murphy <lists@colorremedies.com> =
wrote:

> On Tue, Mar 26, 2019 at 11:38 AM Chris Murphy lists@colorremedies.com wro=
te:
>
> > On Tue, Mar 26, 2019 at 12:44 AM Andrei Borzenkov arvidjaar@gmail.com w=
rote:
> >
> > > He has btrfs raid0 profile on top of hardware RAID6 devices.
> >
> > sys_chunk_array[2048]:
> > item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1048576)
> > length 4194304 owner 2 stripe_len 65536 type SYSTEM
> > io_align 4096 io_width 4096 sector_size 4096
> > num_stripes 1
> > Pretty sure the metadata profiles is "single". From the super, I can't
> > tell what profile the data block groups use.
>
> system chunk is on two devices:
> num_stripes 1 sub_stripes 0
> num_stripes 1 sub_stripes 1
>
> Maybe it is raid0, but I thought dump super explicitly shows the
> profile if it's not single. e.g. SYSTEM|DUP or SYSTEM|RAID1
>
> Only my single profile file systems lack a profile designation in the
> super. But I admit I have no raid0 file systems.
>
> -------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
--------------------------------------
>
> Chris Murphy


