Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46107 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161432Ab3FUQUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 12:20:25 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9B8BA7C0693
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 10:20:24 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>, Zach Brown <zab@redhat.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <51C41318.8070703@giantdisaster.de>
CC: <linux-btrfs@vger.kernel.org>
References: <cover.1371749051.git.sbehrens@giantdisaster.de>
 <ef484aa41751485fc6301ce78b5e3cddaa3f9a52.1371749051.git.sbehrens@giantdisaster.de>
 <20130620194704.GC32674@lenny.home.zabbo.net>
 <51C41318.8070703@giantdisaster.de>
Message-ID: <20130621162022.4477.20734@localhost.localdomain>
Subject: Re: [PATCH v5 1/8] Btrfs: introduce a tree for items that map UUIDs to
 something
Date: Fri, 21 Jun 2013 12:20:22 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Stefan Behrens (2013-06-21 04:47:20)
> On Thu, 20 Jun 2013 12:47:04 -0700, Zach Brown wrote:
> > 
> >> +/* for items that use the BTRFS_UUID_KEY */
> >> +#define BTRFS_UUID_ITEM_TYPE_SUBVOL 0 /* for UUIDs assigned to subvols */
> >> +#define BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL        1 /* for UUIDs assigned to
> >> +                                               * received subvols */
> >> +
> >> +/* a sequence of such items is stored under the BTRFS_UUID_KEY */
> >> +struct btrfs_uuid_item {
> >> +    __le16 type;    /* refer to BTRFS_UUID_ITEM_TYPE* defines above */
> >> +    __le32 len;     /* number of following 64bit values */
> >> +    __le64 subid[0];        /* sequence of subids */
> >> +} __attribute__ ((__packed__));
> >> +
> > 
> > [...]
> > 
> >>  /*
> >> + * Stores items that allow to quickly map UUIDs to something else.
> >> + * These items are part of the filesystem UUID tree.
> >> + * The key is built like this:
> >> + * (UUID_upper_64_bits, BTRFS_UUID_KEY, UUID_lower_64_bits).
> >> + */
> >> +#if BTRFS_UUID_SIZE != 16
> >> +#error "UUID items require BTRFS_UUID_SIZE == 16!"
> >> +#endif
> >> +#define BTRFS_UUID_KEY      251
> > 
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

I've been thinking about this, and while I clearly did not have this use
of uuids in mind originally, they have become a key part of the FS.  They
deserve their own bits in the type field.

I know this is not an easy thing to redo, but long term it really looks
worth it to me.

-chris
