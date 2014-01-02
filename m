Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbaABQVU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 11:21:20 -0500
Date: Thu, 2 Jan 2014 17:21:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: unlinked orphans.
Message-ID: <20140102162118.GN6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1387780037.66690.YahooMailNeo@web162601.mail.bf1.yahoo.com>
 <1C54B604-CF9A-4DDB-9437-BA0B5C05D20D@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1C54B604-CF9A-4DDB-9437-BA0B5C05D20D@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 23, 2013 at 10:16:33AM -0700, Chris Murphy wrote:
> 
> On Dec 22, 2013, at 11:27 PM, Nacho Man <nacho2874@yahoo.com> wrote:
> 
> > Hello,
> > I ran dmesg and saw a bunch of these:
> > [564421.874063] BTRFS debug (device sda2): unlinked 32 orphans
> 
> I sometimes see a similar message (minus debug and device), but it
> occurs on every boot (rootfs is on Btrfs) and is persistent. If I
> temporarily add mount option recovery, then they get cleaned up.
> Expected?

Yes.  The orphan files are cleaned during mount, so you could see it
during boot. There might be orphaned yet uncleaned files left on the
filesystem after a normal umount.

I don't see how could -o recovery, affect that without any real recovery
conditions, it's probably a coincidence that the messages do not appear.


david
