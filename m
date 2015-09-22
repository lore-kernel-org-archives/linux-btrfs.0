Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbbIVPId (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 11:08:33 -0400
Date: Tue, 22 Sep 2015 17:07:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 00/14] Yet Another In-band(online) deduplication
 implement
Message-ID: <20150922150737.GP12815@suse.cz>
Reply-To: dsterba@suse.cz
References: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150728145021.GI6306@twin.jikos.cz>
 <55BF15DF.9080805@cn.fujitsu.com>
 <20150827091407.GB11834@suse.cz>
 <55E3AA39.1060109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55E3AA39.1060109@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 31, 2015 at 09:13:29AM +0800, Qu Wenruo wrote:
> > That's the wrong interface to use for such actions.
> >
> But IMHO, deduplication is much like compression, we only need to 
> execution extra hook to handle data at run_delalloc_range().

It is, but the filesystem-wide compression already shows its
limitations. Eg. it's not possible to set the compression on a
per-subvolume (or at least per-subvolume-mount [*]) basis, it's not possible
to select the compression method for a given file or directory.

Next, changing the status of dedup via remount is quite a heavy
operation. Remount has to sync the whole filesystem, while this is not
strictly necessary for changes in the dedup parameters.

The ioctl, if designed well, can be ready for future enhancements and we
can fine-tune the dedup engine in ways that we do not forsee right now.
I really don't want to see the mount options grow that way.

> And even better than compression, inline dedup won't even cause any 
> format change.
> So I'd prefer to use mount option other than introduce a new ioctl 
> interface.

Yeah, no change in the format makes it just a matter of selecting the
right interface to manage dedup.

(I don't remember if there were other points that I wrote back then when
Liu Bo sent his in-band dedup patches and wanted to use the mount
options as well.)


[*] I do have a POC for that, mostly working and will submit at least
    for RFC
