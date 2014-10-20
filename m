Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from okda.pipebreaker.pl ([176.56.236.173]:43274 "EHLO
	okda.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaJTTJj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 15:09:39 -0400
Received: from cl-79.waw-01.pl.sixxs.net
	([2001:6a0:200:4e::2] helo=mother.pipebreaker.pl ident=postfix)
	by okda.pipebreaker.pl with esmtps (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.80.1)
	(envelope-from <tomek@pipebreaker.pl>)
	id 1XgIKo-0005Ya-Gj
	for linux-btrfs@vger.kernel.org; Mon, 20 Oct 2014 21:09:38 +0200
Date: Mon, 20 Oct 2014 21:09:37 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: unexplainable corruptions 3.17.0
Message-ID: <20141020190937.GD2980@mother.pipebreaker.pl>
References: <20141017085448.GA1050018@mother.pipebreaker.pl>
 <1413550386.755.1@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413550386.755.1@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 17, 2014 at 08:53:06AM -0400, Chris Mason wrote:
> On Fri, Oct 17, 2014 at 4:54 AM, Tomasz Torcz <tomek@pipebreaker.pl> wrote:
> >On Fri, Oct 17, 2014 at 04:29:36PM +0800, Liu Bo wrote:
> >> On Fri, Oct 17, 2014 at 10:10:09AM +0200, Tomasz Torcz wrote:
> >> > On Fri, Oct 17, 2014 at 04:02:03PM +0800, Liu Bo wrote:
> >> > > >   Recently I've observed some corruptions to systemd's journal
> >> > > > files which are somewhat puzzling. This is especially worrying
> >> > > > as this is btrfs raid1 setup and I expected auto-healing.
> >> > > > read(4, 0x1001000, 65536)               = -1 EIO (Input/output
> >>error)
> >>
> >> Well..I don't know exactly what's the cause, but as the file is NOCOW,
> >>it writes
> >> data in place, have you experienced a hard reboot or something
> >>recently?
> >
> >  Nothing like that.  Server is on an UPS, there were couple normal
> >shutdowns
> >this year (few kernel upgrades).
> >
> >> And any message in dmesg log while getting EIO by reading the file?
> >
> >  Nothing in dmesg, no btrfs messages, no SCSI/SATA errors, nothing.
> >That's
> >why I find those corruptions mysterious.
> >  Maybe there is some way to inspect internal btrfs state and find out
> >what
> >causing the problems?  Or maybe this is related to patch mentioned in this
> >thread?
> 
> This sounds like the problem fixed with some patches to our extent mapping
> code  that went in with the merge window.  I've cherry picked a few for
> stable and I'm running them through tests now.  They are in my stable-3.17
> branch, and I'll send to Greg once Linus grabs the revert for the last one.
> 
> But, if you want to try that branch out, it may fix this EIO.  Otherwise
> we'll start sending you debugging.

  Good shot.  Fedora kernel maintainer was kind enough to include those patches
and build a kernel for F21.  With this kernel EIO is not showing and files
are readable.  Thanks!

-- 
Tomasz Torcz              ,,If you try to upissue this patchset I shall be seeking
xmpp: zdzichubg@chrome.pl   an IP-routable hand grenade.'' -- Andrew Morton (LKML)

