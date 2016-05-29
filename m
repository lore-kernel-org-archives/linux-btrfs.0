Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:40228 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbcE2SDV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 14:03:21 -0400
Received: from tux.wizards.de (p4FF5801B.dip0.t-ipconnect.de [79.245.128.27])
	by mail02.iobjects.de (Postfix) with ESMTPSA id A2AFB4160166
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 20:03:18 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 2A31411C01E1
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 20:03:18 +0200 (CEST)
Subject: Re: Hot data tracking / hybrid storage
References: <nh9p2p$cns$1@ger.gmane.org>
 <pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
 <20160516010524.7e208f96@jupiter.sol.kaishome.de>
 <nhedk2$dpq$1@ger.gmane.org> <0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
 <20160517203335.5ff99a05@jupiter.sol.kaishome.de>
 <nhir96$8n4$1@ger.gmane.org>
 <20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
 <e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
 <CAPmG0jYi+gCO3Ps4Xi1ahE4qoqMt6ZmLMrxT_URDHdaA_cZCLg@mail.gmail.com>
 <1c1358af-4549-618a-c408-b93832d33225@gmail.com> <nhnfu8$igq$1@ger.gmane.org>
 <9bde1aa8-fac5-34c4-dffc-0bf15d86c008@gmail.com> <574A8AFF.7020606@gmail.com>
 <CAJCQCtRnLekmARtLNySDofJah12CpKO0VpKygwf7NfQJzS8URg@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <574B2EE6.6080402@applied-asynchrony.com>
Date: Sun, 29 May 2016 20:03:18 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRnLekmARtLNySDofJah12CpKO0VpKygwf7NfQJzS8URg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/29/16 19:53, Chris Murphy wrote:
> But I'm skeptical of bcache using a hidden area historically for the
> bootloader, to put its device metadata. I didn't realize that was the
> case. Imagine if LVM were to stuff metadata into the MBR gap, or
> mdadm. Egads.

On the matter of bcache in general this seems noteworthy:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=4d1034eb7c2f5e32d48ddc4dfce0f1a723d28667

bummer..

Holger

