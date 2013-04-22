Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab3DVPWF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 11:22:05 -0400
Date: Mon, 22 Apr 2013 17:22:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2] btrfs: move leak debug code to functions
Message-ID: <20130422152203.GQ16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <517387F8.506@redhat.com>
 <5174C82D.1080901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5174C82D.1080901@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 22, 2013 at 12:18:37AM -0500, Eric Sandeen wrote:
> There was a time when sprinkling #ifdefs around was
> bad form.   We can clean up the code a bit by moving
> the leak-list adds/removes into functions and make things
> more readable.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: remove extra semicolons on no-op #defines,
> thanks Roger!
> 
> p.s. maybe _debug_ should be in the function names?
> *shrug* 

I agree with that, makes things clear in the code, one does not need to
look into that function.

The leak_list members of extent_state and extent_buffer are present even
without LEAK_DEBUG and are taking space, I'd like to see them moved
under an #ifdef, but as the define is now local to the .c file this
would need to add eg. a CONFIG_ option or a comment that describes how
it should be used.

Bug I'm fine with changing just the function names right now, the rest
is optional and nice to have.

Reviewed-by: David Sterba <dsterba@suse.cz>
