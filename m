Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:18084 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030305Ab3HIOjb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 10:39:31 -0400
Message-ID: <5204FF1F.5070602@giantdisaster.de>
Date: Fri, 09 Aug 2013 16:39:27 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs-progs: mark static & remove unused from non-kernel
 code
References: <52019C6D.9050308@redhat.com> <52019D5F.3070301@redhat.com> <5201C3CC.8000303@redhat.com> <5201FD1D.7030200@giantdisaster.de> <52026525.8030004@redhat.com> <20130809141039.GK5284@twin.jikos.cz>
In-Reply-To: <20130809141039.GK5284@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 9 Aug 2013 16:10:39 +0200, David Sterba wrote:
> On Wed, Aug 07, 2013 at 10:17:57AM -0500, Eric Sandeen wrote:
>> And isn't it still a mistake?  I think it used to be that subvol_uuid_search_init()
>> would allocate the memory which must be freed, but that's no longer the case,
>> right?  So under what circumstances is it correct to call
>> subvol_uuid_search_add() which frees those pointers?
> 
> Looks like the memory management is internal to the subvol_uuid*
> functions, now _init does not allocate and I don't see why _add should
> call free. All users of subvol_uuid_search() free the memory themselves
> (in current code).
> 
> Seems that subvol_uuid_search_add was exported without any concern that
> it could be part of the library interface.
> 
> We don't have library ABI versioning in place, so I suggest to keep the
> function there for compatibility with current code (though I'm not aware
> of any external users of the _add function), but drop th free() calls
> and put a "don't use" comment.
> 

Callers of the subvol_uuid interface (like Btrfs receive) allocate the
memory for newly created items (this is the case after receiving a
subvolume) and add them to the database with the _add function. _add()
stores the pointer and the caller mustn't free() the item. This was/is
the interface.

We don't have this database anymore, we don't keep the items that are
added. Since it was not allowed to call free() for items that have been
added, _add() must call free() now.
