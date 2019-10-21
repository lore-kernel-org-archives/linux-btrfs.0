Return-Path: <SRS0=SF3a=YO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A2BCA9EAF
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 299B420679
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:59:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=tuhh.de header.i=@tuhh.de header.b="BjPDX5OG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfJUM7m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:59:42 -0400
Received: from smtp1.rz.tu-harburg.de ([134.28.205.38]:40644 "EHLO
        smtp1.rz.tu-harburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfJUM7m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Oct 2019 08:59:42 -0400
Received: from mail.tu-harburg.de (mail4.rz.tu-harburg.de [134.28.202.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.tuhh.de", Issuer "DFN-Verein Global Issuing CA" (verified OK))
        by smtp1.rz.tu-harburg.de (Postfix) with ESMTPS id 46xcDC3QL4zxSB;
        Mon, 21 Oct 2019 14:59:39 +0200 (CEST)
Received: from mailspring.rz.tuhh.de (mailspring.rz.tuhh.de [134.28.202.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cmz7792@KERBEROS.TU-HARBURG.DE)
        by mail.tu-harburg.de (Postfix) with ESMTPSA id 46xcDC0lMszJrC4;
        Mon, 21 Oct 2019 14:59:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuhh.de; s=x2019-43;
        t=1571662779; bh=pPpki8yV3MUddp/25/qdWqaawME9g3HSUb40nCG62B0=;
        h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Type:Content-Transfer-Encoding;
        b=BjPDX5OGbIwfkIsqpeg6K7Lqj1spd3p6IWzV8IRYGaCQcpjbJjkIxc9Vw/H2gZZ1L
         kLtTcxbRQwKLO7CTftg6WPVftntM0BJBz2oZHzOMYJWCFGnyTCACnHsSqpBmYNtSpH
         bJ6WlnW/zjQFM7LqdTvpciTcGQ2fvxQfm/HxyCSw=
Date:   Mon, 21 Oct 2019 14:59:37 +0200
From:   Merlin =?UTF-8?B?QsO8Z2U=?= <merlin.buege@tuhh.de>
To:     David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2] btrfs-progs: small fixes/cleanup in Documentation
Message-ID: <20191021145937.4d56cd8d.merlin.buege@tuhh.de>
In-Reply-To: <20191021123050.GF3001@twin.jikos.cz>
References: <20191017045006.130378-1-merlin.buege@tuhh.de>
        <20191018161433.148176-1-merlin.buege@tuhh.de>
        <20191018182331.1786ee9f.merlin.buege@tuhh.de>
        <20191021123050.GF3001@twin.jikos.cz>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On Mon, 21 Oct 2019 14:30:50 +0200
David Sterba <dsterba@suse.cz> wrote:
...
> I've merged the patch as-is, thank. The 'ditto' spelling is probably
> more widely used in english texts. 'dtto' is in sources and thus not
> visible to wide audience so we can live with that.

Thank you!

--=20
Merlin B=C3=BCge
