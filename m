Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B98C64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 19:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43F3A20666
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 19:40:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bC8kjZmo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43F3A20666
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbeJCCZ3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Oct 2018 22:25:29 -0400
Received: from mail-ua1-f45.google.com ([209.85.222.45]:39779 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbeJCCZ3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2018 22:25:29 -0400
Received: by mail-ua1-f45.google.com with SMTP id g18-v6so1186978uam.6
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2018 12:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=S9wbk5BNP0lxBvMqf8Gxx6qDDoMsBhe+vhQ8/+xXC6s=;
        b=bC8kjZmo7s6zcq9m5YAwwBs52qQQcDiCwaUIoK5bwmVf8a+74SSEZDFyYxKN/6ZqcO
         7mvKshM+juxflHOkqvemTVemuv6GG3C0QqhM0IlBKunoJNcS3Zt7oWADaHBNV/gUq5eO
         UrVZGXLj8C8PN28I40QqVS7HhkYX9wBAmqcIEg1DrZhHVrPE8oj/9iO2fKm2ZKwLCCOl
         Qc6drT42vwzzXrWkxv4G3CSQNSowVnJQ6zA+3cpfGRhc3sLTic2Xp/p0kHjowFW/h6Lq
         uCD/moCbgQ9f8k7K66x2t+hXj3TKEM+FjDY7oBx6Rk1J3BMfrAH1j853QRofgTvSEEXJ
         907A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=S9wbk5BNP0lxBvMqf8Gxx6qDDoMsBhe+vhQ8/+xXC6s=;
        b=ZWpT78oQ0D73+CmGIv3au/MmCuFt6f5WShlwyw7MWd1q+dkBgceCpxu6ygs5LtEjyc
         TH8t07/bv/+EsKXpCePkXIu+UsEDz6cYBWOeuIwn9JpWqOIMPd6TZAzAf0nswOL/bo62
         U5iXLjdNp7IfJHfmQE4y/m4m8Jp/wICYH/jWjkcdQKeBB//c06d76cHEH6SxedAR+CZ8
         qlyMYjCAFFUzclgTuJrBa0xhlLIDs8g0Hxq2rakNhPTwyQCWj0mDY0Lrs7Ia/TPxhWWw
         bLWM0JrCzorPfQOERkghtjw14F1uVhB0UJhAQAeTa132HB4N3BNDitDWkhQyiwxSSw5c
         eMdg==
X-Gm-Message-State: ABuFfog5Fp4Z5JQRSVIsfepWOdxyRIt6s0BLVI9th9OaRlBVDrxHu+Zf
        mcMR8ydTVQ4TfOoA2iwUvaDnaMrSL6zv3K7E948AFg==
X-Google-Smtp-Source: ACcGV639CuLRNlELMibeU9EzOAZu2GF5hne02z2hyu5s7I2G64Pa3PjW5WiCRmUH6bBOU/KXq/YcGnCKY1qmkvw5C14=
X-Received: by 2002:a9f:3044:: with SMTP id i4-v6mr7574939uab.100.1538509230778;
 Tue, 02 Oct 2018 12:40:30 -0700 (PDT)
MIME-Version: 1.0
References: <87a7obowwn.fsf@lausen.nl> <87pnws7usa.fsf@lausen.nl>
In-Reply-To: <87pnws7usa.fsf@lausen.nl>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 2 Oct 2018 20:40:19 +0100
Message-ID: <CAL3q7H5MbO41q-t-gGNYQuVG6dqfajbGLeZYLOOJyspuJuVFqg@mail.gmail.com>
Subject: Re: btrfs send receive ERROR: chown failed: No such file or directory
To:     leonard@lausen.nl
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 2, 2018 at 7:02 AM Leonard Lausen <leonard@lausen.nl> wrote:
>
> Hello,
>
> does anyone have an idea about below issue? It is a severe issue as it
> renders btrfs send / receive dysfunctional and it is not clear if there
> may be a data corruption issue hiding in the current send / receive
> code.
>
> Thank you.
>
> Best regards
> Leonard
>
> Leonard Lausen <leonard@lausen.nl> writes:
> > Hello!
> >
> > I observe the following issue with btrfs send | btrfs receive in a setu=
p
> > with 2 machines and 3 btrfs file-systems. All machines run Linux 4.18.9=
.
> > Machine 1 runs btrfs-progs 4.17.1, machine 2 runs btrfs-progs 4.17 (via
> > https://packages.debian.org/stretch-backports/btrfs-progs).
> >
> > 1) Machine 1 takes regular snapshots and sends them to machine 2. btrfs
> >    btrfs send ... | ssh user@machine2 "btrfs receive /path1"
> > 2) Machine 2 backups all subvolumes stored at /path1 to a second
> >    independent btrfs filesystem. Let /path1/rootsnapshot be the first
> >    snapshot stored at /path1 (ie. it has no Parent UUID). Let
> >    /path1/incrementalsnapshot be a snapshot that has /path1/rootsnapsho=
t
> >    as a parent. Then
> >    btrfs send -v /path1/rootsnapshot | btrfs receive /path2
> >    works without issues, but
> >    btrfs send -v -p /path1/rootsnapshot /path1/incrementalsnapshot | bt=
rfs receive /path2

-v is useless. Use -vv, which will dump all commands.

> >    fails as follows:
> >    ERROR: chown o257-4639416-0 failed: No such file or directory
> >
> > No error is shown in dmesg. /path1 and /path2 denote two independent
> > btrfs filesystems.
> >
> > Note that there was no issue with transferring incrementalsnapshot from
> > machine 1 to machine 2. No error is shown in dmesg.
> >
> > Best regards
> > Leonard



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
