From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] a couple of i_nlink fixes in btrfs
Date: Mon, 21 Mar 2011 05:17:25 +0000
Message-ID: <20110321051725.GS22723@ZenIV.linux.org.uk>
References: <20110304171353.GU22723@ZenIV.linux.org.uk>
 <1299517070-sup-1687@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299517070-sup-1687@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 07, 2011 at 11:58:13AM -0500, Chris Mason wrote:

> Thanks, these both look good but I'll test here as well.  Are you
> planning on pushing for .38?

No, but .39 would be nice ;-)  Do you want that to go through btrfs tree
or through vfs one?
