Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33384 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbcE2SdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 14:33:07 -0400
Received: by mail-oi0-f65.google.com with SMTP id m198so21902794oig.0
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 11:33:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <574B2EE6.6080402@applied-asynchrony.com>
References: <nh9p2p$cns$1@ger.gmane.org>
	<pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
	<20160516010524.7e208f96@jupiter.sol.kaishome.de>
	<nhedk2$dpq$1@ger.gmane.org>
	<0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
	<20160517203335.5ff99a05@jupiter.sol.kaishome.de>
	<nhir96$8n4$1@ger.gmane.org>
	<20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
	<e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
	<CAPmG0jYi+gCO3Ps4Xi1ahE4qoqMt6ZmLMrxT_URDHdaA_cZCLg@mail.gmail.com>
	<1c1358af-4549-618a-c408-b93832d33225@gmail.com>
	<nhnfu8$igq$1@ger.gmane.org>
	<9bde1aa8-fac5-34c4-dffc-0bf15d86c008@gmail.com>
	<574A8AFF.7020606@gmail.com>
	<CAJCQCtRnLekmARtLNySDofJah12CpKO0VpKygwf7NfQJzS8URg@mail.gmail.com>
	<574B2EE6.6080402@applied-asynchrony.com>
Date: Sun, 29 May 2016 12:33:06 -0600
Message-ID: <CAJCQCtQpCkTP0uPc9TTLn0S+pQpLsAgBodKZvsYKm9vTuFv=Kg@mail.gmail.com>
Subject: Re: Hot data tracking / hybrid storage
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 29, 2016 at 12:03 PM, Holger Hoffstätte
<holger@applied-asynchrony.com> wrote:
> On 05/29/16 19:53, Chris Murphy wrote:
>> But I'm skeptical of bcache using a hidden area historically for the
>> bootloader, to put its device metadata. I didn't realize that was the
>> case. Imagine if LVM were to stuff metadata into the MBR gap, or
>> mdadm. Egads.
>
> On the matter of bcache in general this seems noteworthy:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=4d1034eb7c2f5e32d48ddc4dfce0f1a723d28667
>
> bummer..

Well it doesn't mean no one will take it, just that no one has taken
it yet. But the future of SSD caching may only be with LVM.

-- 
Chris Murphy
