Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:44624 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379Ab3GWR0D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 13:26:03 -0400
Received: by mail-we0-f176.google.com with SMTP id q56so1182177wes.35
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 10:26:01 -0700 (PDT)
Message-ID: <51EEBCA7.3080802@gmail.com>
Date: Tue, 23 Jul 2013 19:25:59 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Rick van Rein <rick@vanrein.org>
CC: linux-btrfs@vger.kernel.org, cwillu@cwillu.com,
        Mark Fasheh <mfasheh@suse.de>
Subject: Re: Manual deduplication would be useful
References: <3DF45F2F-A56D-4302-AB84-31A6A3084A39@vanrein.org>
In-Reply-To: <3DF45F2F-A56D-4302-AB84-31A6A3084A39@vanrein.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Hello,
> 
> For over a year now, I've been experimenting with stacked filesystems
> as a way to save on resources.  A basic OS layer is shared among
> Containers, each of which stacks a layer with modifications on top of
> it.  This approach means that Containers share buffer cache and
> loaded executables.  Concrete technology choices aside, the result is
> rock-solid and the efficiency improvements are incredible, as
> documented here:
> 
> http://rickywiki.vanrein.org/doku.php?id=openvz-aufs
> 
> One problem with this setup is updating software.  In lieu of
> stacking-support in package managers, it is necessary to do this on a
> per-Container basis, meaning that each installs their own versions,
> including overwrites of the basic OS layer.  Deduplication could
> remedy this, but the generic mechanism is known from ZFS to be fairly
> inefficient.
> 
> Interestingly however, this particular use case demonstrates that a
> much simpler deduplication mechanism than normally considered could
> be useful.  It would suffice if the filesystem could check on manual
> hints, or stack-specifying hints, to see if overlaid files share the
> same file contents; when they do, deduplication could commence.  This
> saves searching through the entire filesystem for every file or block
> written.  It might also mean that the actual stacking is not needed,
> but instead a basic OS could be cloned to form a new basic install,
> and kept around for this hint processing.
> 
> I'm not sure if this should ideally be implemented inside the
> stacking approach (where it would be
> stacking-implementation-specific) or in the filesystem (for which it
> might be too far off the main purpose) but I thought it wouldn't hurt
> to start a discussion on it, given that (1) filesystems nowadays
> service multiple instances, (2) filesystems like Btrfs are based on
> COW, and (3) deduplication is a goal but the generic mechanism could
> use some efficiency improvements.
> 
> I hope having seen this approach is useful to you!

Have a look at bedup[1] (disclaimer: I wrote it).  The normal mode
does incremental scans, and there's also a subcommand for
deduplicating files that you already know are identical:
  bedup dedup-files

The implementation in master uses a clone ioctl.  Here is Mark
Fasheh's latest patch series to implement a dedup ioctl[2]; it
also comes with a command to work on listed files
(btrfs-extent-same in [3]).

[1] https://github.com/g2p/bedup
[2] http://comments.gmane.org/gmane.comp.file-systems.btrfs/26310/
[3] https://github.com/markfasheh/duperemove
