Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab3IROPC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 10:15:02 -0400
Date: Wed, 18 Sep 2013 16:14:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clmason@fusionio.com
Subject: Re: [patch 1/9] btrfs: add ioctls to query/change feature bits online
Message-ID: <20130918141459.GA6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130916181910.799140428@suse.com>
 <20130916182017.776301648@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130916182017.776301648@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 16, 2013 at 02:19:11PM -0400, Jeff Mahoney wrote:
> There are some feature bits that require no offline setup and can
> be enabled online. I've only reviewed extended irefs, but there will
> probably be more.

Each feature bit being set online has to be treated separately regarding
safety of the data in flight.

You can set extended irefs online, there's only one place where the bit
is checked (if the hadlink count overflows the leaf), it's ok to set the
bit anytime before or after and it will not break anything.

Skinny metadata bit is checked all over the place and I'm not sure it's
ok to set it on after some portion of data has been processed in the
non-skinny mode.

'default_subvol', lzo are ok, the rest depends on mkfs and can't be
modified online at all.

So, for skinny metadata it's most likely required to set the bit in a
delayed manner and schedule it eg. to post-commit time.

The sysfs and ioctl interface looks ok to me.


david
