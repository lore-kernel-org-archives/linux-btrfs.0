Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257AbaAWRrv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 12:47:51 -0500
Date: Thu, 23 Jan 2014 18:47:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/5] Add support for object properties
Message-ID: <20140123174749.GP6498@suse.cz>
Reply-To: dsterba@suse.cz
References: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
 <20131123005243.GK5007@twin.jikos.cz>
 <CAL3q7H6P5eDSui4pN0aeVtKPGctLqCqXShKMcPmBQZBfECkcXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6P5eDSui4pN0aeVtKPGctLqCqXShKMcPmBQZBfECkcXQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 07, 2014 at 11:51:08AM +0000, Filipe David Manana wrote:
> There seems to be a lot of details for this feature, and many other
> projects (such as those you point on the wiki) would benefit from
> properties.
> It might be hard to get all requirements at once, so I think it might
> be better to start simple, but in a way that doesn't prevent adding
> the more advanced requirements later.

Absolutely, that's why I'm trying to gather all potential future
requirements and usecases now so we don't become surpristed later.
Although it's detailed, there are groups that are covered by saying
eg.  "this is per-device, stored here, accessed trhough this xattr".
If the proposal is able to give such answers, then it's what I'm
expecting at this phase.

> As for the xattrs namespace: yes, we can capture the "btrfs."
> namespace. hfsplus does this, it captures the "osx." namespace.
> See my reply to Hugo about this on this thread:
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/29972

JFYI, there's a discussion on fsdevel about replacing the existing file
attributes ioctl with something else, xattr's are considered as the
UI/storage, so it would need some coordination to be consistent with
whatever gets decided.

> My work so far, for the kernel side, was all about inode (and
> subvolume) properties. Haven't considered properties for devices so
> far.

I hope it's clear that I'm not asking about implementing all the
properties from the beginning. I's fine that you're focused on inode
props, get the things working so we have something tangible to play
with. If the device props are not forgottent to add to some high-level
xattr namespace, I'm satisfied.

> By using xattrs, while simplifying the storage and not
> touching/extending the on-disk format, it will always have some impact
> on performance - they take leaf space, hence btrees will be larger
> than before.

Not all of the props need to end up as a xattr, we can still use the
existing inode->flags field that's used for the file attributes, there
are 11 bits occupied, plenty of room to add more where it would make
sense.  The rest shall be in xattr items.

> I think we need to clearly define what are the initial requirements,
> start with a simple approach, always thinking on how to extend/refine
> it later without the need for breaking backwards compatibility later
> of course.

Well, I think once the xattr naming scheme is set it won't be changed or
refined. I'm expecting only specific properties appended. Eg. if you
propose btrfs.compression as an inode property, then it's a no-go to
move it to btrfs.fs.compression once a whole-filesystem gains persistent
option, and refine again when somebody like me comes and says that any
*.compression should really be a napespace that groups all
compression-related options.
