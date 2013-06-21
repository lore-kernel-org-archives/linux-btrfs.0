Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161432Ab3FUQLl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 12:11:41 -0400
Date: Fri, 21 Jun 2013 09:11:38 -0700
From: Zach Brown <zab@redhat.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 1/8] Btrfs: introduce a tree for items that map UUIDs
 to something
Message-ID: <20130621161138.GA25321@lenny.home.zabbo.net>
References: <cover.1371749051.git.sbehrens@giantdisaster.de>
 <ef484aa41751485fc6301ce78b5e3cddaa3f9a52.1371749051.git.sbehrens@giantdisaster.de>
 <20130620194704.GC32674@lenny.home.zabbo.net>
 <51C41318.8070703@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51C41318.8070703@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > Why do we need this btrfs_uuid_item structure?  Why not set the key type
> > to either _SUBVOL or _RECEIVED_SUBVOL instead of embedding structs with
> > those types under items with the constant BTRFS_UUID_KEY.  Then use the
> > item size to determine the number of u64 subids.  Then the item has a
> > simple array of u64s in the data which will be a lot easier to work
> > with.
> 
> Maintaining a 16 bit uuid_type field inside the item is done in order to
> avoid wasting type values for the key. The type field in the key has a
> width of 8 bits, so far 34 type values are defined in ctree.h.
> 
> As long as such items are in separated trees, their type value could be
> reused in the future when the 8 bit type field is exhausted.
> 
> There was some discussion in #btrfs about this topic on 2013-04-26.
> There are pros and cons. The uuid_type field in the item allows to use
> the uuid items generically outside of the uuid tree since it occupies
> only one type value in the 8 bit type field. On the other hand, if the 8
> bit type field in the key is exhausted, it saves lines of codes and
> avoids complexity to implement a common way to expand this field instead
> of implementing multiplexing layers at multiple places, although maybe
> with some added performance penalty.
> 
> Anybody else with an opinion for this topic?

Perhaps obviously, I'm strongly in favour of not rolling another layer
of indirection inside the items, especially when the code to implement
it is full of fragile pointer math.

> >> +	offset = (unsigned long)ptr;
> >> +	while (sub_item_len > 0) {
> >> +		u64 data;
> >> +
> >> +		read_extent_buffer(eb, &data, offset, sizeof(data));
> >> +		data = le64_to_cpu(data);
> >> +		if (data == subid) {
> >> +			ret = 0;
> >> +			break;
> >> +		}
> >> +		offset += sizeof(data);
> >> +		sub_item_len--;
> >> +	}
> > 
> > This could be cleaned up a bit by comparing an on-stack little-endian
> > input subid with each little-endian subid in the item with
> > memcmp_extent_buffer().
> 
> This would save some CPU cycles for the repeated le64_to_cpu() and for
> the memcpy(). The number of lines of code is equal for both ways.

Hmm?  It would be many fewer lines of code.

> read_extent_buffer() way is more straight forward and readable IMO.

> > How does this extension avoid the BUG when the leaf containing the item
> > doesn't have room for the new subid?
> 
> btrfs_extend_item() does not BUG() when you have called
> btrfs_search_slot() before with ins_len > 0.

Ah, got it.  Thanks.

- z
