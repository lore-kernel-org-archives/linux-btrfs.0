From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] sleeping function called from atomic context
Date: Fri, 4 May 2012 09:25:36 -0400
Message-ID: <20120504132536.GA25477@shiny>
References: <4FA3AD0B.7040500@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs List <linux-btrfs@vger.kernel.org>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA3AD0B.7040500@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 04, 2012 at 12:18:51PM +0200, Stefan Behrens wrote:
> Looks like after "btrfs read error corrected" of chunk tree block while
> reading the chunk tree in open_ctree(), we stay in atomic state (in
> 3.4-rc5).

I'm having a hard time reproducing this here.  Do you have lockdep on?
It might tell us which lock we're leaving around.

-chris
