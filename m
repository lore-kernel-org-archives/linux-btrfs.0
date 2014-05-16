Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbaEPRYz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 13:24:55 -0400
Date: Fri, 16 May 2014 19:24:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: dsterba@suse.cz, kreijack@inwind.it,
        linux-btrfs <linux-btrfs@vger.kernel.org>, jshubin@redhat.com
Subject: Re: PATCH V3] mkfs.btrfs: allow UUID specification at mkfs time
Message-ID: <20140516172453.GE6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5372C457.3000706@redhat.com>
 <53738D29.7020405@redhat.com>
 <5373AA3B.5000100@redhat.com>
 <5373E864.4040807@libero.it>
 <5373E908.4040800@redhat.com>
 <20140515173940.GS6917@twin.jikos.cz>
 <5374FF30.5080708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5374FF30.5080708@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 15, 2014 at 12:53:52PM -0500, Eric Sandeen wrote:
> So, in my testing, I found that re-mkfsing a device with the same UUID lead
> to weird & distant segfaults in other bits of code.  Probably due to the
> uuid cache?  </handwave> - I didn't dig into it, because ...

Ok, something that needs more debugging, the uuid/blkid cache is a good
guess I think.

> ... people didn't want to be able to create duplicate UUIDs, so I figured
> the outright rejection of that was a trivial way to solve it ...
> 
> And like I mentioned, if you really want to recreate the same UUID, you
> can mkfs twice.  It doesn't take long.  ;)
> 
> I dunno, maybe that's too lame.  For a feature that upstream development
> doesn't really seem to want, I'm not sure how much more effort I should
> put into it?

Well, your patch allows to create a filesytem with a given UUID in the
safe case.

There are workarounds if the UUID is not unique for the same fs (run
twice, or wipefs first).

That's enough for me to integrate the V3 patch and we can address
creating duplicate UUIDs separately once we can make it work correctly.
