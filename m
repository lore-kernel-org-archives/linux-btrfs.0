Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53378 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbaHVNPp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 09:15:45 -0400
Date: Fri, 22 Aug 2014 06:15:42 -0700
From: Marc MERLIN <marc@merlins.org>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: Shriramana Sharma <samjnaa@gmail.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Significance of high number of mails on this list?
Message-ID: <20140822131542.GN3875@merlins.org>
References: <CAH-HCWVZPNkc7ycsL4jH0i6niVU3nqZiB2MLD6CfP85FckAg7g@mail.gmail.com>
 <2217061.yFV10mnZWq@merkaba>
 <CAH-HCWVxOA+NBD5ON_D2Np2mC6+PC=n5QCCc410pQC04X7VnxA@mail.gmail.com>
 <53F6E9B7.1040701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F6E9B7.1040701@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 22, 2014 at 09:56:55AM +0300, Konstantinos Skarlatos wrote:
> I would stay with rsync for a while, because there is always the
> possibility of a bug that corrupts both your primary filesystem and
> your backup one, or send propagating corruption from one filesystem
> to another (Or maybe I am too paranoid, it would be good if we could
> have the opinion of a btrfs developer on this)

btrfs send will not corrupt your primary filesystem, it takes a read
only subvolume and sends its data somewhere else.
At worst, it can (and has in the fact) create incorrect data on the
destination, and I've never seen a single report of it actually
corrupting the destination filesystem (the destination subvolume can
correct incorrect data, but that wouldn't corrupt the existing data on
the destination).

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
