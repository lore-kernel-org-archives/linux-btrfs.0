Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758808AbcBYJ0H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 04:26:07 -0500
Date: Thu, 25 Feb 2016 10:25:56 +0100
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.de>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] btrfs-progs: add 'du' command
Message-ID: <20160225092556.GH23746@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1453326567-20454-1-git-send-email-mfasheh@suse.de>
 <1453326567-20454-3-git-send-email-mfasheh@suse.de>
 <CALJXSJoatg4G8YnJxk=oRJzS2vJXyJoWceNFeEZqoK_7vfdbPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CALJXSJoatg4G8YnJxk=oRJzS2vJXyJoWceNFeEZqoK_7vfdbPw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2016 at 03:57:51AM -0500, Jérôme Poulin wrote:
> On Wed, Jan 20, 2016 at 4:49 PM, Mark Fasheh <mfasheh@suse.de> wrote:
> > 'btrfs du' differs from regular du in that it will work to resolve which
> > blocks are shared between files in its list. This gives the user a more
> > accurate bytecount from which they can make decisions regarding management
> > of their file space.
> 
> 
> Would it be a good idea for this new du to show the compressed file size too?

Yes, we're ware of the demand for that. IMO it's not necessary for the
initial implementation.

> It was not made by me but I know I had this patch lying around, it
> also does not compile right now but I could give it an update. The
> wiki says this patch was "not merged yet" but I have no idea why it
> was not since it was working correctly 2 years ago on my machine.

The patch looks familiar to me. The ioctl for compressed size approach
was abandoned in favor of extending FIEMAP. For the purposes of 'fi du'
we'll probably use the SEARCH_TREE ioctl and iterate the extents
manually.
