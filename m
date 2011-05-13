From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] btrfs: quasi-round-robin for chunk allocation
Date: Fri, 13 May 2011 14:56:41 +0200
Message-ID: <20110513125641.GS12709@twin.jikos.cz>
References: <1297188212-23212-1-git-send-email-sensille@gmx.net>
 <4DA33D99.3050506@gmx.net>
 <1302543930-sup-5927@think>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arne Jansen <sensille@gmx.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	josef <josef@redhat.com>, miaox <miaox@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302543930-sup-5927@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Apr 11, 2011 at 01:46:33PM -0400, Chris Mason wrote:
> My big complaint about this patch is that it is a feature fix mixed in
> with a huge cleanup.  It's hard to differentiate between the two.  Could
> you please separate it out so we can review them independently?

I agree that changes should go separated by cleanups and fixes, but
after going through the main patch, I do not see a way how to do it. New
version does not leave much from the previous code and structuring, and
the allocation strategy looks clear from the new version.

The comments I've posted today to V3 contain pure cleanups, yes they
could be separated, but there are very few of them and touch the new
version in some cases anyway. I do not see much sense to send them
separately.


HTH,
david
