Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbcD0Wmd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 18:42:33 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 15536ABDD
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 22:42:30 +0000 (UTC)
Date: Thu, 28 Apr 2016 00:42:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/8] btrfs: uapi migration for user-visible API components
Message-ID: <20160427224220.GP29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459541670-4097-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 04:14:22PM -0400, Jeff Mahoney wrote:
> The only part of this set that isn't just a direct cut-and-paste is
> the last one which converts u8 and u64 values to __u8 and __u64 since
> the former aren't exported via include/uapi.
> 
> The goal is that everything required to use the btrfs ioctls for a
> particular kernel release should be made available by exporting the uapi
> headers for that release.
> 
> I intend to use these for the strace ioctl decoding patch I've been
> working on so that I don't need to duplicate of the definitions in the
> code I send upstream as the final version of the patch.  Prior to this
> patchset, I had to duplicate nearly 100 defines and several structures --
> and that's without doing any item decoding at all.
> 
> I do expect there might be some discussion here. :)

I think this is a good refactoring, although my first reaction was not
like that. Having the defines in the same directory is convenient, as
searching is just *.[ch], but that's something I can live without. The
other choice was to duplicate the defines yet another time, and this
would be 3rd place, when counting btrfs-progs.

As Josef and Bo seem to be fine with that as well, I'll put it to a
branch and schedule for 4.7.
