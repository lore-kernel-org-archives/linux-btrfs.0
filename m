Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaENP1O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 11:27:14 -0400
Date: Wed, 14 May 2014 17:27:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>,
        jshubin@redhat.com
Subject: Re: [PATCH] mkfs.btrfs: allow UUID specification at mkfs time
Message-ID: <20140514152712.GM6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5372C457.3000706@redhat.com>
 <5373803E.9000406@libero.it>
 <5373808F.4020403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5373808F.4020403@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 14, 2014 at 09:41:19AM -0500, Eric Sandeen wrote:
> > I am not against this option; I am suggesting to add a explicit
> > warning to the user about the risk of doing that, both on the man
> > pages and into the program. The warning should say that this option
> > is only for testing. Better ask for a confirmation (even with an
> > undocumented switch like
> > '--I-know-that-I-am-doing-something-really-dangerous').
> 
> meh.  ext4 and xfs have had the ability to either set or change the
> UUID for years, and I've not heard of any horror stories.

Because these filesystems do not detect their devices by uuid, it's
mainly for the multi-device fs, but applies for single-device fs as well.
