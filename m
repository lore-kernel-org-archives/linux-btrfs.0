Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0041C2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 20:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EE6A2081B
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 20:44:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j1jxHiZ9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EE6A2081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbeJaFjh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 01:39:37 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:40141 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbeJaFjg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 01:39:36 -0400
Received: by mail-qt1-f172.google.com with SMTP id k12so9359654qtf.7
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 13:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x2owRFwb4pijynvgHJgNLj9fxQy/6b4o1DVDOPEJbhg=;
        b=j1jxHiZ9nU3W7c78sY3XOynioaaoSHbn05ji7xYTOXThMVKJ6EA5NchDarmlXFJCeu
         Andlwl9MiuZg2wSgpDcpjHi+Q/xev/3gcKn3exisx0ZTBG612wXBXE6wQ3buQRptzhMC
         v3bP6QVe3FtjKzVFOVGb96WdXw9fbBK906uBTWh2/iXFmRZ192ncxKRWHvx9OYmTB9yT
         /csUWTyA4wI3Wpv1jnMyrxLvMoh67Q+e8vyZTuTvv5pLHe7yF6cdNOlzkq+NWTMBDWUK
         jUSF8aAsjKCZsZC3cQacatjtw3/I0M5jcn+rQjqULiHT3mn37aZ9DcSUIiTw7T7Ntnsx
         qiDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x2owRFwb4pijynvgHJgNLj9fxQy/6b4o1DVDOPEJbhg=;
        b=pNP+gk3L2u15ERpoCTrwu4OpgBleQoSmwmaHC92QJZWWy+3jjLKKbyfZCK+FYMPSHn
         /6Gu3nJJ+BhDI3eddTzFv3Q6jfwzrseEB/bf7/H6jxw323HVi1K6VYCwnKGfH9GOhDnY
         y5aDysGTAVEte/9eNR0qgH8MMArD/4qbRjDB3ArSdIGMMRmGYymxSAsV/v8OYGwXdy7H
         KQwdCXvJsK05gPZ7Kgrgcz+FrcY6HB6QyCrpxCMF+xjujCrQvR2V/UtsF+Utd6+A91Lv
         gc7FNKlqd5qJMYEPXNp8cSEHdMnN0kVx3ySSSwbE82z4ODCLILA86OMaX8o8ofXu9FPQ
         UsJw==
X-Gm-Message-State: AGRZ1gIPNicaUuJM7JSXbY76WLrJrTjKGvi9vh5EafugculETT7KeVii
        P06K9j8lfX4jt8CsOwwyOU1qpKBXCoP8PxuJa4lA4aJT
X-Google-Smtp-Source: AJdET5faQ/dretVT+5+b5uZYAuD1IaZ1NyvDWKlVWfLygLR02yK5o/HvR8gNLNJFLKjv74bC9JDc8V8Y3rh/acAX8Sg=
X-Received: by 2002:ac8:6bce:: with SMTP id b14-v6mr252265qtt.25.1540932273873;
 Tue, 30 Oct 2018 13:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAJzMQG2xPu7vy60qDjip+u93=3GU0v_ZXE9h8t_Tj1Vf6f5EnA@mail.gmail.com>
 <CAJCQCtTTBOdK5Z=7SDb8W+q7Px+kyLb6hAo06piw=zxDYtrSgA@mail.gmail.com>
In-Reply-To: <CAJCQCtTTBOdK5Z=7SDb8W+q7Px+kyLb6hAo06piw=zxDYtrSgA@mail.gmail.com>
From:   Barbet Alain <alian123soleil@gmail.com>
Date:   Tue, 30 Oct 2018 21:44:18 +0100
Message-ID: <CAJzMQG2mAfux8+ij9KqeOfmfN0b-_6kHzh3dwoofYExNk0KiAw@mail.gmail.com>
Subject: Re: Where is my disk space ?
To:     lists@colorremedies.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks for answer !
alian@alian:~>  sudo btrfs sub list -ta /
[sudo] Mot de passe de root :
ID      gen     top level       path
--      ---     ---------       ----
257     79379   5               <FS_TREE>/@
258     79386   257             @/var
259     79000   257             @/usr/local
260     79376   257             @/tmp
261     79001   257             @/srv
262     79062   257             @/root
263     79001   257             @/opt
264     78898   257             @/boot/grub2/x86_64-efi
265     78933   257             @/boot/grub2/i386-pc

Yes it's opensuse, but I don't see any snapper config enable.
For memory, I use docker that full my disk, I remove subvolume, but
it's look like something is missing somewhere.
Le mar. 30 oct. 2018 =C3=A0 19:01, Chris Murphy <lists@colorremedies.com> a=
 =C3=A9crit :
>
> On Tue, Oct 30, 2018 at 9:17 AM, Barbet Alain <alian123soleil@gmail.com> =
wrote:
> > Hi,
> > I experienced disk out of space issue:
> > alian:~ # df -h
> > Filesystem      Size  Used Avail Use% Mounted on
> > devtmpfs        7.8G     0  7.8G   0% /dev
> > tmpfs           7.8G   47M  7.8G   1% /dev/shm
> > tmpfs           7.8G   18M  7.8G   1% /run
> > tmpfs           7.8G     0  7.8G   0% /sys/fs/cgroup
> > /dev/sda6        41G   35G  5.1G  88% /
> > /dev/sda6        41G   35G  5.1G  88% /var
> > /dev/sda6        41G   35G  5.1G  88% /root
> > /dev/sda6        41G   35G  5.1G  88% /srv
> > /dev/sda6        41G   35G  5.1G  88% /opt
> > /dev/sda6        41G   35G  5.1G  88% /boot/grub2/i386-pc
> > /dev/sda6        41G   35G  5.1G  88% /usr/local
> > /dev/sda6        41G   35G  5.1G  88% /tmp
> > /dev/sda6        41G   35G  5.1G  88% /boot/grub2/x86_64-efi
> > /dev/sda7       424G  200G  225G  48% /home
> >
> >
> > It say I use 35Go / 41. But I have only 5,8Go of data:
> > alian:~ # btrfs fi du -s /
> >      Total   Exclusive  Set shared  Filename
> >    5.84GiB     5.84GiB       0.00B  /
> > alian:/ # du -h --exclude ./home --max-depth=3D0
> > 6.2G    .
>
> I suspect there are snapshots taking up space that are no located in
> the search path starting at /
>
> What do you get for:
>
> $ sudo btrfs sub list -ta /
>
> Is this an openSUSE system? If snapper is enabled, you'll need to ask
> it to delete some of the snapshots to free up space rather than doing
> it with btrfs user space tools.
>
>
>
>
> > alian:/ # btrfs fi df /
> > Data, single: total=3D35.00GiB, used=3D34.18GiB
> > System, DUP: total=3D32.00MiB, used=3D16.00KiB
> > Metadata, DUP: total=3D384.00MiB, used=3D216.75MiB
> > GlobalReserve, single: total=3D22.05MiB, used=3D0.00B
> >
> > I try to run btrfs balance multiple time with various parameters but
> > it doesn't change anything nor trying btrf check in single user mode.
> >
> > Where is my 30 Go missing ?
>
>
>
> --
> Chris Murphy
