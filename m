Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab3CJPTE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 11:19:04 -0400
Date: Sun, 10 Mar 2013 16:19:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/14] btrfs-progs: more Coverity cleanups
Message-ID: <20130310151900.GA5645@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 04, 2013 at 04:39:50PM -0600, Eric Sandeen wrote:
> This gets the coverity issue count down to 33.  Before Zach started this
> process, we were over 150, IIRC.  So it's almost to the point where the
> scans will be manageable going forward.
> 
> Not a lot of real bugfixes here, but a bit better error handling in
> places.  I sent out 2 dumb patches  (elsewhere) on Friday, though,
> so feel free to take a close & skeptical look at these ;)

Thanks, pulled them in (minus 04 and V2 for 12 and 14).

david
