Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2867C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 04:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91F36218D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 04:36:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lW5TTLqH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfDXEf6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 00:35:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33850 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfDXEf5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 00:35:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id r186so3640056wmf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2019 21:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F7LVN98ofi2DrZGH31zutwhlw838Nn4J/plpoiu2OSY=;
        b=lW5TTLqHT4ekZfVddlXB/5ypUncaTqV1vJeDy/+fNeNov6p0R8zgv5Or6tY7b0Y5Xf
         Dhu3E/urxqwWkuP1Y4+DrlIgb3Osc1BmqmEahwKKJz25EOqIGLrJggdQLA/6iHBnNz/7
         cvMor79vRUybZyVcst/WJXmd5NxSDW02zgjl2ZR14MGNqq0+iLcSo8mZiTEnEnfukfi9
         e+lfrh3aMzkMhiKrV61CazJ+ArUkfQ2LO+rjpFn0Ag4cBxgb2DhmFOnMPHR7/AU04rGK
         w0aOnh4sHeEBG99wklP+tV2l3CB8+M6ezL5Kqv5whRZioXF8xZyRYkAg47Lp7IVMgQvH
         +EhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F7LVN98ofi2DrZGH31zutwhlw838Nn4J/plpoiu2OSY=;
        b=ul/w/+vo9QcIvTHaGYuvB7OsL0FsS+ckp80ZyzBbumoPM2wvYF+oXjf8p49GHYagoC
         nL3WqApBq85pxeygqobEl/G2YdDS+EdNM/YqQJO9Xnrlju27EonTm/zyno8lXGKmAqmw
         cmq1pXhn6mgCFKKiwfXtjaLoFw1E6cZPFI4Y1LK5NgYVZn5o1drbdwhod0pdeqY2eRoK
         ECWUDwK/43N8ZBfFaXo/aUp8pu1DtxiMmx2Fv5ft5rxpxFQf+JpvdAMimdXDNJN1uC2w
         CnNwI9oP+Bh8FnTeaII5eknGEMiVhfwXEH2uaqGru/v1dDQgiWH7bVrRsyUiZX3OoWNm
         gtOQ==
X-Gm-Message-State: APjAAAWrnv029rWAOrQ5fmloUe0rRljXSHq+neYd/91WY4w54KnbRr2B
        pOfZsjuqrgDxbE2IjQ1prehsZg9bqxiWrq7/XaXkn+e3
X-Google-Smtp-Source: APXvYqxKVQayC3czEcJh05/ifA1hNKddWknSk1X+xhm9zvIg5nyMscGCOlndmyrVz6C3FKpOOfcbaSsGFnB4/+OmAUU=
X-Received: by 2002:a05:600c:2309:: with SMTP id 9mr4948158wmo.52.1556080556090;
 Tue, 23 Apr 2019 21:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>
 <476a657f-ae87-38ab-47b0-1bd410092621@automatix.de>
In-Reply-To: <476a657f-ae87-38ab-47b0-1bd410092621@automatix.de>
From:   Nathan Dehnel <ncdehnel@gmail.com>
Date:   Tue, 23 Apr 2019 23:35:43 -0500
Message-ID: <CAEEhgEszTyzFKJOV=OF+0b=H_putWMGcACW3bo2j4x-Pt1dhkw@mail.gmail.com>
Subject: Re: reading/writing btrfs volume regularly freezes system
To:     Juergen Sauer <juergen.sauer@automatix.de>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

>Could you please post the output of "uname -a" ?
Linux gentooserver 4.19.27-gentoo-r1 #1 SMP PREEMPT Tue Apr 2 01:01:13
CDT 2019 x86_64 Intel(R) Xeon(R) CPU E5-1620 v3 @ 3.50GHz GenuineIntel
GNU/Linux

>The means disable "kyber" scheduler, wihch is default after 4.18.x or
so, and reactivate cfq, bfq or deadline or noop scheduler. If your
problems are solved it would be a great idea to upgrade the kernel.
It says CONFIG_DEFAULT_IOSCHED=3D"cfq".

On Tue, Apr 23, 2019 at 2:29 AM Juergen Sauer
<juergen.sauer@automatix.de> wrote:
>
> Am 22.04.19 um 22:37 schrieb Nathan Dehnel:
> > I have a raid10 volume that frequently locks up when I try to write to
> > it or delete things. Any command that touches it will hang (and can't
> > be killed) and I have to start a new ssh session to get into the
> > computer again. Nothing fixes it besides a reboot, and the volume will
> > fail to unmount while the computer is shutting down.
> >
> > [  302.360912] sysrq: SysRq : Show Blocked State
> > [  302.360951]   task                        PC stack   pid father
> > [  302.360987] btrfs-transacti D    0  2187      2 0x80000000
> > [  302.360993] Call Trace:
> [...]
>
> Nathan,
> I presume you are using a kernel before 4.19.8 and after 4.0.9.x.
> Your Post does not mention the kernel version, you use.
> Could you please post the output of "uname -a" ?
>
> During the rework of the kernel scheduler (multi queue schechduler) by
> the kernel team around Linus, there were huge modification done, which
> effected nearly all filesystems. Those rewritings caused data loss in
> ext4, complete crashes in xfs and so on.
>
> I was hit by this issue on BTRFS, so your description was somewhat a
> dejavu for me.
>
>
> Your can try to use the old mono-queued schedulers in an interim kernel,
> or you may upgrade to an recent kernel.
>
> The means disable "kyber" scheduler, wihch is default after 4.18.x or
> so, and reactivate cfq, bfq or deadline or noop scheduler. If your
> problems are solved it would be a great idea to upgrade the kernel.
>
> We use BTRFS as raid5 (not advised, experimaental), but we use it with
> kernel 5.x in arch linux.
>
> Even the multi device code is under heavy development,
> BTRFS likes the most recent kernels!
>
>
>
> mit freundlichen Gr=C3=BC=C3=9Fen
> J=C3=BCrgen Sauer
