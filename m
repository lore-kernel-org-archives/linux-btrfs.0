Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122AbcG1MZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 08:25:00 -0400
Date: Thu, 28 Jul 2016 14:24:39 +0200
From: David Sterba <dsterba@suse.cz>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Anatoly Pugachev <matorola@gmail.com>, dsterba@suse.cz,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        debian-sparc <debian-sparc@lists.debian.org>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
Message-ID: <20160728122439.GW30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <20160727195609.GN30795@twin.jikos.cz>
 <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
 <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2016 at 02:09:03PM +0200, John Paul Adrian Glaubitz wrote:
> Hi David!
> 
> On 07/28/2016 01:58 PM, Anatoly Pugachev wrote:
> >> Can you please test with the current 'devel' branch? Fixed by the patch
> >> "btrfs-progs: fix unaligned access calculating raid56 data" (depends on
> >> another patch in devel). Thanks.
> 
> Are you sure you pushed these changes? I don't see them in the devel branch [1].

Oh shame, of course not. Now pushed.
