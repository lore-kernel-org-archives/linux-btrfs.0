Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from okda.pipebreaker.pl ([176.56.236.173]:43276 "EHLO
	okda.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaJTTKg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 15:10:36 -0400
Received: from cl-79.waw-01.pl.sixxs.net
	([2001:6a0:200:4e::2] helo=mother.pipebreaker.pl ident=postfix)
	by okda.pipebreaker.pl with esmtps (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.80.1)
	(envelope-from <tomek@pipebreaker.pl>)
	id 1XgILi-0005Yf-U6
	for linux-btrfs@vger.kernel.org; Mon, 20 Oct 2014 21:10:34 +0200
Date: Mon, 20 Oct 2014 21:10:34 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: unexplainable corruptions 3.17.0
Message-ID: <20141020191034.GE2980@mother.pipebreaker.pl>
References: <20141016091726.GA582640@mother.pipebreaker.pl>
 <2103F075-0D7A-4BF7-AC3B-1A1C7A101E27@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2103F075-0D7A-4BF7-AC3B-1A1C7A101E27@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 17, 2014 at 11:01:51AM -0400, Chris Murphy wrote:
> 
> On Oct 16, 2014, at 5:17 AM, Tomasz Torcz <tomek@pipebreaker.pl> wrote:
> > 
> >  Broken files are in /var/log/journal directory. This directory
> > is set NOCOW with chattr, all the files within too.
> > 
> > Example of broken file:
> > system@0005057fe87730cf-6d3d85ed59bd70ae.journal~
> 
> What do you get for 'journalctl --verify' ? I'm curious if any journal files are considered corrupt by journalctl, and if there's parity between journalctl and dd_rescue when it comes to good/bad journals.

  journalctl "bus errors" on them.


-- 
Tomasz Torcz              ,,If you try to upissue this patchset I shall be seeking
xmpp: zdzichubg@chrome.pl   an IP-routable hand grenade.'' -- Andrew Morton (LKML)

