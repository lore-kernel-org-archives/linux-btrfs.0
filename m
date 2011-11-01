From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH 15/21] Btrfs: recover restripe on mount
Date: Tue, 01 Nov 2011 11:57:32 +0100
Message-ID: <4EAFD09C.7040205@gmx.net>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com> <1314129722-31601-16-git-send-email-idryomov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-16-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 23.08.2011 22:01, Ilya Dryomov wrote:
> On mount, if restripe item is found, resume restripe in a separate
> kernel thread.
> 
> Try to be smart to continue roughly where previous balance (or convert)
> was interrupted.  For chunk types that were being converted to some
> profile we turn on soft convert, in case of a simple balance we turn on
> usage filter and relocate only less-than-90%-full chunks of that type.
> These are just heuristics but they help quite a bit, and can be improved
> in future.
> 

Instead of trying to find out where you left off, can't you just save a
pointer in your restripe_item every time a chunk finished?
