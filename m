Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab2LSQEY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 11:04:24 -0500
Date: Wed, 19 Dec 2012 17:04:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Bug: trying to create reflink on different device results in
 empty file
Message-ID: <20121219160422.GO14116@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50C7B0A3.7040408@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50C7B0A3.7040408@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 11, 2012 at 11:16:03PM +0100, Koen De Wit wrote:
> When trying to create a clone (reflink) of a file on a different device,
> you'll get this error:
>     Invalid cross-device link
> 
> However, an empty file is created on the target location. An invalid clone
> operation should not result in the creation of a file.

The clone operation inside btrfs needs 2 files already open (ie. it
works with file descriptors, not with filenames), the empty file exists
prior to the ioctl call.  So the file should be removed by 'cp' (or
whoever calls the clone ioctl) because they know if it makes sense to
delete the file or not.

david
