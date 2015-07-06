Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924AbbGFXH1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jul 2015 19:07:27 -0400
Date: Mon, 6 Jul 2015 16:07:25 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Mordechay Kaganer <mkaganer@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: running duperemove but no free space gain
Message-ID: <20150706230725.GG7507@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <CA+xOVSO2Cd1aYxAnA_Aq32oBTiMTbuo1YQo2cqEY_5WONQV=qA@mail.gmail.com>
 <20150706223404.GF7507@wotan.suse.de>
 <CA+xOVSNrX4yT=+0Xre8qpRrsA=+Nu0w5+fUa0oAbvXf0CFr35w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+xOVSNrX4yT=+0Xre8qpRrsA=+Nu0w5+fUa0oAbvXf0CFr35w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 07, 2015 at 02:03:06AM +0300, Mordechay Kaganer wrote:
> 
> Checked some more pairs, most extents appear as "shared". In some
> cases there is "last encoded" not shared extent with length 4096.
> 
> Since i use snapshots, may shared also mean "shared between snapshots"?

Yes I forgot about that but in your case almost everything will be reported
shared. Btw, I have to leave my office now but will get to the rest of your e-mail
later.

--
Mark Fasheh
