Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47499 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751201AbcJCQ1v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Oct 2016 12:27:51 -0400
Date: Mon, 3 Oct 2016 18:27:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Commit 'synchronize incompat feature bits with sysfs files'
 still missing in for-next?
Message-ID: <20161003162749.GC6576@suse.cz>
Reply-To: dsterba@suse.cz
References: <57D7E442.2010400@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <57D7E442.2010400@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 13, 2016 at 01:34:26PM +0200, Holger Hoffstätte wrote:
> 
> I've noticed that the 4.5-rc commit 14e46e04:
> 'btrfs: synchronize incompat feature bits with sysfs files' [1]
> was reverted later in [2], but despite fixes to protect sysfs
> with locks & exorcise GFP_NOFS in favor of GFP_KERNEL it was
> never reinstated - neither for 4.5-final, nor later..and it's
> been quite a while since then. Is this still valid?
> 
> I ask because I've just noticed I've had this in my tree since
> forever, but have never encountered a problem during balance -
> probably because of all the other fixes.

I spent sime time trying to fix it but got lost in sysfs. Supposedly,
the attribute group functions should provide all what's needed, ie.
define a set of attributes, visibility callback. Calling an update will,
in theory and my expectations, refresh the values and files. It does
not. IIRC it was never meant to work like that, so it would have to be
worked around or new sysfs helpers adde or I don't know what else.
Working with sysfs code is sometimes painful, but I'm about to return to
adding the free-space-tree bits someday.
