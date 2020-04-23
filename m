Return-Path: <SRS0=Tw2U=6H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C30C2BA19
	for <linux-btrfs@archiver.kernel.org>; Thu, 23 Apr 2020 06:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC99214AF
	for <linux-btrfs@archiver.kernel.org>; Thu, 23 Apr 2020 06:45:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="EF9zwzXp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgDWGp2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 02:45:28 -0400
Received: from lists.nic.cz ([217.31.204.67]:48052 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgDWGp2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Apr 2020 02:45:28 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 538E1141357;
        Thu, 23 Apr 2020 08:45:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1587624326; bh=/PcD3tg0VT8rpqDZb/DwBImC7BKWUEdivatN5l55dL4=;
        h=Date:From:To;
        b=EF9zwzXpX/AVephQXga0Hn40K02c3RbmGt1ISn4D9RWVamksZ6AEs1aQYB+jQ1pPR
         RGEsEzlMG1RVoKtxMF/URHqZn2oOtaHiyAlP85QkJS/RCykt18mTJcTTzDefm51QuV
         G3+ZniRhbDIIwakeAMf7qIsgm0eeY+6gvoUvui8E=
Date:   Thu, 23 Apr 2020 08:45:25 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: when does btrfs create sparse extents?
Message-ID: <20200423084525.6885e978@nic.cz>
In-Reply-To: <9f96fe0c-cbe5-12c8-67f5-2981c9273c5d@gmail.com>
References: <20200422205209.0e2efd53@nic.cz>
        <9f96fe0c-cbe5-12c8-67f5-2981c9273c5d@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.101.4 at mail
X-Virus-Status: Clean
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 23 Apr 2020 08:57:59 +0300
Andrei Borzenkov <arvidjaar@gmail.com> wrote:

> 22.04.2020 21:52, Marek Behun =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > Hello,
> >=20
> > there was a bug fixed recently in U-Boot's btrfs driver - the driver
> > failed to read files with sparse extents. This causes that sometimes
> > device failes to boot Linux, since the kernel fails to load from
> > storage.
> >  =20
>=20
> Do you mean that kernel image (vmlinuz?) had holes? Or there were some
> other files that caused U-Boot to fail?

Kernel image (non-compressed Image for arm64) had ~200 PAGE_SIZEd
all-zero blocks.
