Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_SBL,
	URIBL_SBL_A autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C924C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 15:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 669E820811
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 15:00:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rPopKCUT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfCNO77 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:59:59 -0400
Received: from mail-it1-f174.google.com ([209.85.166.174]:53457 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfCNO76 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 10:59:58 -0400
Received: by mail-it1-f174.google.com with SMTP id o76so1995635ita.3
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 07:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kuS1WEIDwlytfHPq/IodPttmotMK3rKegmtA1hChjbQ=;
        b=rPopKCUTRO11syUQ8f2CdhRZmb1t8OX5xQEaYpoVyF9llwXCs+IT1+TpgYtQY+NmOD
         BgAjboImZYBa2nHKrl17jUDgV1magTgH6tf/UUyHy6/vQTfOWOowdS3eNmRebtaV5qB4
         fugRRhfds76Qrg5uIBD3AVCjRUAtfU1pblYaa2PVS64YMzVJR7JbpwPbGlnlkqz3BS+i
         ZoTODkqbQtMau7rZUqTkq5CBizlebZlzSf4tSpXsf7m5ZWGu9Xu7tMhiFXWY+f9UnTiz
         9pkfxVypmxdvxDxQcBQrCA8u1nG1nPKq5HuurMOkKKGhCyaF3SPEEQzsYt4pNXa7LVJt
         TLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kuS1WEIDwlytfHPq/IodPttmotMK3rKegmtA1hChjbQ=;
        b=iTPa2+QV6nyaIEfJCVAE1fvbrXvVmQFltv013D7Dl+0dUc2eOycIBKJS862u5uMQLQ
         HxKT0eZEFhQVqwUV3cbClF++FBEpoJgB2+BljPmD6rGSUCJPCVXy9ymqHyoDrWz0rh5X
         198NfxxGU2zssk042FY22d/BcRQcoKSNMPMO1jkfrWuUrpxK6NODWGeRwS89zI6rr6sN
         zhzRqiSsy0wifhpmhSwFCJIIU6l4MWu1ZQj2/gPaT9H5Ox3zjNzagvOi+fgRQk7NHAb3
         HoZwEE1LoBiVKKpD738e0Zh7iIFnt9z9HsNrQLs2HcJKjay5VEsJMaWBZBazoaAZUyNH
         w8qA==
X-Gm-Message-State: APjAAAWetzqEx10Z6RXma0yQFxWxl1mp3rL1UfV1NFt5HAmNf396csGe
        tdns15MEeR+9De7WE3cy3azpZrD1cSkKhBqSGeekng==
X-Google-Smtp-Source: APXvYqxXkGAGX/tdnxV8bWjMjZGsVGB0nBDJFGz5qRH6C4uCOFH9++0xbAwUs3K+qyxA7aJHAC7uIcD0DksR+MJ+HEU=
X-Received: by 2002:a24:4a8f:: with SMTP id k137mr2234715itb.8.1552575597522;
 Thu, 14 Mar 2019 07:59:57 -0700 (PDT)
MIME-Version: 1.0
References: <7a713010-5db6-2627-2593-8e13092868b1@husak.pro>
In-Reply-To: <7a713010-5db6-2627-2593-8e13092868b1@husak.pro>
From:   Noah Massey <noah.massey@gmail.com>
Date:   Thu, 14 Mar 2019 10:59:21 -0400
Message-ID: <CADfjVrjFOMT9FG3t572vtCZzvRaia1d593fyNBMh2zV=FM12UA@mail.gmail.com>
Subject: Re: Balancing raid5 after adding another disk does not move/use any
 data on it
To:     =?UTF-8?B?SmFrdWIgSHVzw6Fr?= <jakub@husak.pro>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 13, 2019 at 6:13 PM Jakub Hus=C3=A1k <jakub@husak.pro> wrote:
>
> Sorry, fighting with this technology called "email" :)
>
>
> Hopefully better wrapped outputs:
>
> On 13. 03. 19 22:58, Jakub Hus=C3=A1k wrote:
>
>
> > Hi,
> >
> > I added another disk to my 3-disk raid5 and ran a balance command.
> > After few hours I looked to output of `fi usage` to see that no data
> > are being used on the new disk. I got the same result even when
> > balancing my raid5 data or metadata.
> >

Am I correct in rephrasing your issue into "balancing 3 copy raid5
does not rebalance into 4 copy raid5"? Because that was a surprising
result to me, but may be a spec that I wasn't aware of.

> >
> # btrfs filesystem usage   /mnt/data1
>
> Data,RAID5: Size:4.59TiB, Used:4.06TiB
>     /dev/mapper/crypt-sdb       2.29TiB
>     /dev/mapper/crypt-sdc       2.29TiB
>     /dev/mapper/crypt-sde       2.29TiB
>
> Metadata,RAID1: Size:158.00GiB, Used:29.43GiB
>     /dev/mapper/crypt-sdb      53.00GiB
>     /dev/mapper/crypt-sdc      53.00GiB
>     /dev/mapper/crypt-sdd     158.00GiB
>     /dev/mapper/crypt-sde      52.00GiB
