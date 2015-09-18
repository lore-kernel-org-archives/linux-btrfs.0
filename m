Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:63031 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbbIRIc3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 04:32:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 18 Sep 2015 10:32:24 +0200
From: Gert Menke <gert@menke.ac>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS as image store for KVM?
In-Reply-To: <pan$270e2$4b4f9ec6$a323af50$ada695ce@cox.net>
References: <55F88ECC.1040604@menke.ac>
 <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net> <55FAFEB8.6030404@menke.ac>
 <CAJCQCtR_3eiWWmpJHC9RT4EJOzUb_AmrQkkm0X4R0OE4FYUHMQ@mail.gmail.com>
 <pan$270e2$4b4f9ec6$a323af50$ada695ce@cox.net>
Message-ID: <73be0409eccd402c1e0d0dece8a2751b@durkon.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 2015-09-18 04:00, schrieb Duncan:
> Some users have ameliorated that by scheduling weekly or monthly btrfs
> defrag, reporting that cow1 issues with temporary snapshots build up 
> slow
> enough that the scheduled defrag effectively eliminates the otherwise
> growing problem, but it's still an additional complication to have to
> configure and administer, longer term.

This makes me think if maybe btrfs+bcache, combined with scheduled 
defrag, could work reasonably well for me. The disk images should not 
get too big, though, I suppose, because then the defrag might take 
longer than desired.

Gert
