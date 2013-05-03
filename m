Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37595 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091Ab3ECUhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 16:37:43 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 6D1369A0420
	for <linux-btrfs@vger.kernel.org>; Fri,  3 May 2013 14:37:43 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, David Sterba <dsterba@suse.cz>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130503203344.GE12414@localhost.localdomain>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1367242681-8835-1-git-send-email-dsterba@suse.cz>
 <20130503203344.GE12414@localhost.localdomain>
Message-ID: <20130503203741.5844.76366@localhost.localdomain>
Subject: Re: [PATCH] btrfs: use only memmove_extent_buffer and simplify the helpers
Date: Fri, 3 May 2013 16:37:41 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Josef Bacik (2013-05-03 16:33:44)
> On Mon, Apr 29, 2013 at 07:38:01AM -0600, David Sterba wrote:
> > After commit a65917156e34594 ("Btrfs: stop using highmem for
> > extent_buffers") we don't need to call kmap_atomic anymore and can
> > reduce the move_pages helper to a simple memmove.
> > 
> > There's only one caller of memcpy_extent_buffer, we can use the
> > memmove_ variant here.
> > 
> 
> This makes -l 64k blow the hell up, just try generic/001.  I'm kicking this
> patch out.  Thanks,

Sorry Dave, I only now remember having this same problem the last time I
tried to get rid of memcpy.

-chris

