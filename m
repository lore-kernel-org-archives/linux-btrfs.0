From: David Sterba <dave@jikos.cz>
Subject: Re: Where can I find symlink's target?
Date: Tue, 1 Nov 2011 16:56:29 +0100
Message-ID: <20111101155629.GG12759@twin.jikos.cz>
References: <edb53b9dd6dcf054485278225f6ee728@joachim-neu.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: email@joachim-neu.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <edb53b9dd6dcf054485278225f6ee728@joachim-neu.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 02:29:50PM +0000, email@joachim-neu.de wrote:
> I'm taking a look at the B-tree level of btrfs. I have a dir item which 
> is a symlink and I'm wondering where I can get the symlink's target 
> from.

The symlink target is stored as inline data, inside the leaf, see
btrfs_symlink how it's constructed.

> I hope anyone can tell me? Is there a bloody technical documentation of 
> btrfs somewhere out there that can answer me questions like this?

Nope, I wish there were. Some bits were at the wiki.


david
