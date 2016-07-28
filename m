Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:35402 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932163AbcG1MJH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 08:09:07 -0400
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: Anatoly Pugachev <matorola@gmail.com>, dsterba@suse.cz
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <20160727195609.GN30795@twin.jikos.cz> <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        debian-sparc <debian-sparc@lists.debian.org>
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Message-ID: <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de>
Date: Thu, 28 Jul 2016 14:09:03 +0200
MIME-Version: 1.0
In-Reply-To: <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David!

On 07/28/2016 01:58 PM, Anatoly Pugachev wrote:
>> Can you please test with the current 'devel' branch? Fixed by the patch
>> "btrfs-progs: fix unaligned access calculating raid56 data" (depends on
>> another patch in devel). Thanks.

Are you sure you pushed these changes? I don't see them in the devel branch [1].

Adrian

> [1] http://repo.or.cz/btrfs-progs-unstable/devel.git/shortlog/refs/heads/devel

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
