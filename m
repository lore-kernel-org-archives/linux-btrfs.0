Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:59672 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab2ITLFS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 07:05:18 -0400
Date: Thu, 20 Sep 2012 13:05:04 +0200
From: David Sterba <dave@jikos.cz>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: make space to keep default mount options
Message-ID: <20120920110504.GG17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5057CDA7.3090201@jp.fujitsu.com>
 <5057CE50.1050706@jp.fujitsu.com>
 <20120918121035.GZ17430@twin.jikos.cz>
 <505982DD.8030408@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505982DD.8030408@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2012 at 05:31:25PM +0900, Hidetoshi Seto wrote:
> >>  
> >> +	info->mount_opt = info->super_copy->default_mount_opt;
> > 
> > the options have to respect some priority, eg. when I set default
> > options to a filesystem, but mount with a different set, I expect that
> > the explicit flags apply and override the defaults.
> > 
> > I don't remember if this was discussed in the mailinglist or on IRC
> > only, should be easy to dig up if needed.
> 
> At least I don't know whether this was already disscussed or not.

For the subset you've selected, whole-fs default options, I now think we
don't need it, the discussions we had were about option precedence for
per -file, -subvolume, -fs, -mount. At the time of mount only per-mount
and per-fs need to sort their precedence. Any per-file option has to be
evaluated at a specific time eg. when new data are written in case of
compression.

> Now my code gives priority to the default options, and it would not
> be so difficult in case if we have opposing options like "ssd" vs
> "nossd", and "space_cache" vs "no_space_cache"...

Yep, that's what I expect to temporarily disable a specific option, eg.
the space_cache. For that purpose the full set of options with their
no- counterparts would make sense from the usability POV (although there
may be exceptions).

> Or we could use the default options only if there is no options
> specified when it is being mount, but it will make the default
> options useless.

You mean in case of a simple

  mount /dev/ice /mnt

?

This seems like a limited use of the defaults and may be confusing.


david
