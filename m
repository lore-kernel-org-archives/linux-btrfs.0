Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537Ab3DXXjC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 19:39:02 -0400
Date: Thu, 25 Apr 2013 01:38:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Rich Turner <rturner@storix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: query btrfs creation options
Message-ID: <20130424233859.GH16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <517839C2.7060905@storix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <517839C2.7060905@storix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 24, 2013 at 01:00:02PM -0700, Rich Turner wrote:
> i am looking for a way to query btrfs filesystems for all options used to
> create the filesystem (i.e. data, leafsize, label, metadata, nodesize,
> sectorsize) in an effort to be able to record this information and be able
> to recreate the filesystem with the same attributes if necessary.

the 'file' utility is able to give you the leaf/node/sector numbers

$ file -s /dev/sda5
/dev/sda5: BTRFS Filesystem sectorsize 4096, nodesize 4096, leafsize 4096)

I don't have the label set, but it is printed if set.

The raid profiles can be obtained from 'btrfs fi df', this should be
enough to recreate the fs.

> i see there is a feature request for creating an api/library that may
> provide this functionality, but i am unable to find any suitable userspace
> command that provides the information.

'file' parses the superblock directly, but we could enhance the
ioctl BTRFS_IOC_FS_INFO to get it in an api-friendly way.

david
