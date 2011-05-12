From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: very poor read / write performance compared to other FS's?
Date: Thu, 12 May 2011 16:34:22 -0700
Message-ID: <20110512233422.GI17822@wotan.suse.de>
References: <BANLkTinRa9TdVOAaMt9_gcR2xDhbDWVJcA@mail.gmail.com>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Marek Fstump <marekfstump@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTinRa9TdVOAaMt9_gcR2xDhbDWVJcA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2011 at 11:33:35PM +0100, Marek Fstump wrote:
> I am very interested in using BTRFS for my solution but in basic tests
> it seems to be very poor on read and write performance.  I am
> surprised by this so suspect that maybe I am doing something
> incorrectly or that there are updates I should be using, but I am not
> sure how I update BTRFS on SLES11

Hey Marek, just fyi that the btrfs version in sles11 sp1 is old (by btrfs
standards :). That's not surprising of course as btrfs isn't supported yet
in any enterprise distributions. My guess is that you should see better
results with a more recent kernel.
	--Mark

--
Mark Fasheh
