Return-Path: <SRS0=+tro=YL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0FCCA9EA0
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Oct 2019 14:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBF0D21852
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Oct 2019 14:56:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=tuhh.de header.i=@tuhh.de header.b="HGu6Qy9f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408535AbfJRO4s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Oct 2019 10:56:48 -0400
Received: from smtp1.rz.tu-harburg.de ([134.28.205.38]:35328 "EHLO
        smtp1.rz.tu-harburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393933AbfJRO4r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Oct 2019 10:56:47 -0400
Received: from mail.tu-harburg.de (mail4.rz.tu-harburg.de [134.28.202.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.tuhh.de", Issuer "DFN-Verein Global Issuing CA" (verified OK))
        by smtp1.rz.tu-harburg.de (Postfix) with ESMTPS id 46vpyj0ZT5zxSh;
        Fri, 18 Oct 2019 16:56:45 +0200 (CEST)
Received: from mailspring.rz.tuhh.de (mailspring.rz.tuhh.de [134.28.202.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cmz7792@KERBEROS.TU-HARBURG.DE)
        by mail.tu-harburg.de (Postfix) with ESMTPSA id 46vpyh24QrzJrC3;
        Fri, 18 Oct 2019 16:56:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuhh.de; s=x2019-42;
        t=1571410605; bh=CKpiEM1iyls9HlxCrCwSjlkgFlyQtLmssMtZrhJrnNQ=;
        h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Type:Content-Transfer-Encoding;
        b=HGu6Qy9fJc1C9Z5xpAhGr4Q01i69xw6IwOdngDoYsPtD0sh2a0Xx7qXgSjrTnd+7u
         uFWXyns6ZG66UpqV6TeMujID8zClze8VW9Evv6OZJuP/QF6k4KcoCq5qIWrtPU5uIo
         MnhT1BQFSsy260rcm0bVeFSls8+xuG4UVdgenjsI=
Date:   Fri, 18 Oct 2019 16:56:43 +0200
From:   Merlin =?UTF-8?B?QsO8Z2U=?= <merlin.buege@tuhh.de>
To:     David Sterba <dsterba@suse.cz>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: small fixes/cleanup in Documentation
Message-ID: <20191018165643.05f79ff6.merlin.buege@tuhh.de>
In-Reply-To: <20191018120745.GB3001@twin.jikos.cz>
References: <20191017045006.130378-1-merlin.buege@tuhh.de>
        <1201273d-8051-b65a-51bc-6e4c12cff7f2@suse.com>
        <20191017111805.GE2751@twin.jikos.cz>
        <20191017164731.48111095.merlin.buege@tuhh.de>
        <20191018120745.GB3001@twin.jikos.cz>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On Fri, 18 Oct 2019 14:07:45 +0200
David Sterba <dsterba@suse.cz> wrote:
...
> > Q: How would I go about updating the patch? Just completely resend it
> > to the mailing list from scratch so a new thread gets created, or
> > replying to the existing one? =20
>=20
> Replying to the same would be better in this case. If you don't have
> more updates to the docs resending is not necessary, unless you want to
> exercise sending patches by mail.

Thanks for your explanation.

--=20
Merlin B=C3=BCge
