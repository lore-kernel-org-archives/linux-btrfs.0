Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39615 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab2JaPk7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 11:40:59 -0400
Date: Wed, 31 Oct 2012 08:40:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: Sander <sander@humilis.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Need help mounting laptop corrupted root btrfs. Kernel BUG at fs/btrfs/volumes.c:3707 - FIXED
Message-ID: <20121031154056.GE3290@merlins.org>
References: <E1TTCzR-0001nz-1p@gandalfthegreat.merlins.org> <20121030144914.GA18659@merlins.org> <20121029154713.GF8019@merlins.org> <B19885DE-6AED-4B8B-B1CA-891878B43C8C@colorremedies.com> <20121029174802.GB7796@merlins.org> <20121030154608.GA19231@merlins.org> <20121031092440.GA31209@panda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121031092440.GA31209@panda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 31, 2012 at 10:24:40AM +0100, Sander wrote:
> Marc MERLIN wrote (ao):
> > What happened is that my SSD is craping out and failing to write after
> > a certain number of uptime hours.
> 
> What model ssd is that if I may ask?

I had my first one, Crucial C300 just die with all my data about 3 months
later.
I spent 2-3 weeks trying to get acceptable performance (i.e. faster than a
HD) off 2 samsung 830s (you might remember some spam from me here about them
when I thought it might be an issue with btrfs initially).
Now, I have an OCZ Vertex 4.

That said, it's working fine again for now after I went back to kernel 3.5.3 
(down from 3.6.3). It hasn't been long enough to say for sure, but there is
a remote possibility that changes in 3.6 actually caused my drive to freeze
after several hours of use.
When that happened (3 times), 2 of those times, btrfs did not manage to
write all its data before access was cutoff, and I got the bug I reported
here, which in turn crashes any kernel you try to mount the FS with.
Cleaning the log manually fixed it both times so far.

For now, I'll stick with 3.5.3 for a while to make sure my drive is actually
ok (it seems to be afterall), and once I'm happy that it's the case, I'll go
back to 3.6.3 with serial console remote logging and try to capture the full
sata failure I got with 3.6.3.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
