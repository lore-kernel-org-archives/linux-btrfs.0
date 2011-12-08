From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs switches to using mostly one thread
Date: Thu, 8 Dec 2011 10:32:01 -0500
Message-ID: <20111208153201.GJ8971@shiny>
References: <jbqkib$v1g$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jbqkib$v1g$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 08, 2011 at 03:19:38PM +0000, Jeremy Sanders wrote:
> Hi - I'm trying out btrfs again, and I see the same old bug in kernel 3.1.4 
> (Fedora 16, x86_64, dual-core), where after a few hours of writing, it 
> switches from writing with several threads to writing with one:

Ok, I'll try to reproduce this here.  Could you please do a sysrq-t, I'd
like to see what the other delalloc-writers are doing.

-chris
