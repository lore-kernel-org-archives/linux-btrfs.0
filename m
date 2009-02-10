From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] start work on delete snapshot code
Date: Mon, 09 Feb 2009 20:09:08 -0500
Message-ID: <1234228148.17365.34.camel@think.oraclecorp.com>
References: <1234224453-4227-1-git-send-email-aaron@merfinllc.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Aaron Straus <aaron@merfinllc.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234224453-4227-1-git-send-email-aaron@merfinllc.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-02-09 at 16:07 -0800, Aaron Straus wrote:
> This is far from complete and in particular it *doesn't* take the necessary
> locks at all i.e. please don't use this yet outside of testing.  This patch is
> more of a request for help with regards to the locking.
> 

Sorry to say that I won't have time to read through this in the morning,
but this is a pretty hefty task for a first patch.  Thanks for taking it
on and posting this work!

-chris


