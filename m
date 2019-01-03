Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C875C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 14:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F3C2208E3
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 14:33:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="eQEvIbzf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731053AbfACOdD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 09:33:03 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:50632 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbfACOdD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 09:33:03 -0500
Date:   Thu, 03 Jan 2019 14:32:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1546525980;
        bh=rQHclIU9oYJY9ygt4qUUgesRG/p//7KUbTzRTGjN+PI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=eQEvIbzfkhxbQvlYhy986SMRJ8/Y1PKFFTajGpUI24EH/1hEKPJScqf/Yc5dh7peT
         vc8Xq+1RdLwQaS6OP9iZAG8Gf9bCxkIzWdSbH1RpriXdjkJiogXjV02BBC0DV0Pq3k
         JBvcyfDNdrTHOb5aDhZP0Yv9SdQe8rz3yI8Y2fv8=
To:     Andrea Gelmini <andrea.gelmini@gelma.net>
From:   b11g <b11g@protonmail.com>
Cc:     Tomasz Chmielewski <tch@virtall.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Reply-To: b11g <b11g@protonmail.com>
Subject: Re: BTRFS corruption: open_ctree failed
Message-ID: <3bVsFicVvIyBXxe3CYYCVF_P99BjDh_iNNQpUHxA9gZMJJgG-0K5ttWn_JwQwvFrUBfHONWyp7ZQz6PkQpX2XdcnzzOSIxazRVQch0uCGYw=@protonmail.com>
In-Reply-To: <20190103072740.GA64625@glet>
References: <155a0e09f60a0605802c459a6e119b36@virtall.com>
 <20190103072740.GA64625@glet>
Feedback-ID: lUBa-WV0uAwkWs2PxUY-pUV2q6-Zuux_EqKTuYphP-Kxh3RnAJZOoHLvsXpeqqAZQFobD_IfHjSMoVPhuYTmhg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I heard of the ext4 bug, but I didn't check my kernel more carefully - cont=
rarily to what I reported previously, my kernel version was 4.14.79, NOT 4.=
19.12 (I think I installed the latter, but the system was still pending a r=
eboot). I am sorry if this caused confusion.

AFAIK, those are the flags used in the NixOS kernel:
https://github.com/NixOS/nixpkgs/blob/0396345b79436f54920f7eb651ab42acf2eb7=
973/pkgs/os-specific/linux/kernel/common-config.nix
I did not find references to "elevator" nor "scsi_mod.use_blk_mq" there or =
in the boot command line.

-b11g

=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Thursday, 3 January 2019 08:27, Andrea Gelmini <andrea.gelmini@gelma.net=
> wrote:

> On Thu, Jan 03, 2019 at 11:52:05AM +0900, Tomasz Chmielewski wrote:
>
> > Did you use 4.19.x kernels earlier than 4.19.8?
> > They had a bug which would corrupt filesystems (mostly ext4 users would=
 be
> > reporting it, but I saw it with other filesystems, like xfs and btrfs, =
too):
>
> Well, just for the record, it triggers when you have
> scsi devices using elevator=3Dnone over blkmq.
>
> And it's not a default/usual configuration.
>
> So, b11g, can you check please if the NixOS kernel is compiled with these=
 flags?
> And/or if they have something like:
> scsi_mod.use_blk_mq=3D1
> in the boot command line?
>
> Ciao,
> Gelma
