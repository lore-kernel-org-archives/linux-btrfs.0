Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 185-6-29-55-rev.logitus.pl ([185.6.29.55]:36203 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaJQIzV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 04:55:21 -0400
Date: Fri, 17 Oct 2014 10:54:51 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: unexplainable corruptions 3.17.0
Message-ID: <20141017085448.GA1050018@mother.pipebreaker.pl>
References: <20141016091726.GA582640@mother.pipebreaker.pl>
 <20141017080202.GA3604@localhost.localdomain>
 <20141017081009.GC582640@mother.pipebreaker.pl>
 <20141017082935.GC3604@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141017082935.GC3604@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 17, 2014 at 04:29:36PM +0800, Liu Bo wrote:
> On Fri, Oct 17, 2014 at 10:10:09AM +0200, Tomasz Torcz wrote:
> > On Fri, Oct 17, 2014 at 04:02:03PM +0800, Liu Bo wrote:
> > > >   Recently I've observed some corruptions to systemd's journal
> > > > files which are somewhat puzzling. This is especially worrying
> > > > as this is btrfs raid1 setup and I expected auto-healing.
> > > > read(4, 0x1001000, 65536)               = -1 EIO (Input/output error)
> 
> Well..I don't know exactly what's the cause, but as the file is NOCOW, it writes
> data in place, have you experienced a hard reboot or something recently?
 
  Nothing like that.  Server is on an UPS, there were couple normal shutdowns
this year (few kernel upgrades).

> And any message in dmesg log while getting EIO by reading the file?

  Nothing in dmesg, no btrfs messages, no SCSI/SATA errors, nothing. That's
why I find those corruptions mysterious.
  Maybe there is some way to inspect internal btrfs state and find out what
causing the problems?  Or maybe this is related to patch mentioned in this thread?

-- 
Tomasz Torcz               "Never underestimate the bandwidth of a station
xmpp: zdzichubg@chrome.pl    wagon filled with backup tapes." -- Jim Gray

