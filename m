Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab3HARQk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 13:16:40 -0400
Date: Thu, 1 Aug 2013 19:16:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: tim <tim@klingt.org>, linux-btrfs@vger.kernel.org
Subject: Re: [3.10.3] kernel BUG at fs/btrfs/ctree.c:3000
Message-ID: <20130801171638.GZ24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <ktavc5$htm$1@ger.gmane.org>
 <20130731133500.GB2372@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130731133500.GB2372@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 09:35:00AM -0400, Josef Bacik wrote:
> On Wed, Jul 31, 2013 at 02:19:25PM +0200, tim wrote:
> > running btrfs on kernel 3.10.3, i got the following two backtraces,
> > first an info about a hung task and a kernel bug.
> > 
> > are these known issues?

That's a crash that appears very rarely and we were not able to
reproduce it

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg21476.html
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg21476.html

> Well that's not good, can you file a bugzilla with this at bugzilla.kernel.org?
> Make sure the component is set to btrfs.  Run btrfsck on your device and attach
> the output to the bug as well.  Thanks,

IIRC fsck did not report anything, the changes were only in memory
(but we'd like the fsck log anyway). I think we're only left to print
more debugging information and wait when it happens again.

david
