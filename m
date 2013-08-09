Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758045Ab3HIOKl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 10:10:41 -0400
Date: Fri, 9 Aug 2013 16:10:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs-progs: mark static & remove unused from
 non-kernel code
Message-ID: <20130809141039.GK5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52019C6D.9050308@redhat.com>
 <52019D5F.3070301@redhat.com>
 <5201C3CC.8000303@redhat.com>
 <5201FD1D.7030200@giantdisaster.de>
 <52026525.8030004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52026525.8030004@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 07, 2013 at 10:17:57AM -0500, Eric Sandeen wrote:
> And isn't it still a mistake?  I think it used to be that subvol_uuid_search_init()
> would allocate the memory which must be freed, but that's no longer the case,
> right?  So under what circumstances is it correct to call
> subvol_uuid_search_add() which frees those pointers?

Looks like the memory management is internal to the subvol_uuid*
functions, now _init does not allocate and I don't see why _add should
call free. All users of subvol_uuid_search() free the memory themselves
(in current code).

Seems that subvol_uuid_search_add was exported without any concern that
it could be part of the library interface.

We don't have library ABI versioning in place, so I suggest to keep the
function there for compatibility with current code (though I'm not aware
of any external users of the _add function), but drop th free() calls
and put a "don't use" comment.

david
