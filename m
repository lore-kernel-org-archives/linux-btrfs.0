From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 05/12] btrfs: remove useless mutex lock/unlock sequences
Date: Fri, 29 Apr 2011 18:34:24 +0200
Message-ID: <20110429163424.GB12709@twin.jikos.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
 <b5fefb09811c22cd101a44ac753293af942087fc.1303398927.git.dsterba@suse.cz>
 <4DB513F6.6040503@jp.fujitsu.com>
 <1303733509-sup-4508@think>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	David Sterba <dsterba@suse.cz>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303733509-sup-4508@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 25, 2011 at 08:12:59AM -0400, Chris Mason wrote:
> > This code tests whether the mutex_lock can be acquired, and when the
> > mutex_lock can be taken, it try again.
> > So I think that it is not a meaningless code.
> 
> Correct, this code is waiting for the current lock holder to finish.
> It's not exactly pretty but it needs to stay.

Ok, I think it deserves a comment, will add it and resend.


david
