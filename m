Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757945Ab3BGAIP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Feb 2013 19:08:15 -0500
Date: Thu, 7 Feb 2013 01:08:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: [PATCH 2/2, RFC] btrfs-progs: overhaul mkfs.btrfs -r option
Message-ID: <20130207000812.GE12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <510831DC.4070709@redhat.com>
 <510833E4.6080609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <510833E4.6080609@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 29, 2013 at 02:41:08PM -0600, Eric Sandeen wrote:
> The manpage for the "-r" option simply says that
> it will copy the path specified to -r into the newly
> made filesystem.
> 
> There's not a lot of reason to treat that option as differently
> as it is now - today it ignores discard, fs size, and mixed
> options, for example.  It also failed to check whether the
> target device was mounted before proceeding.  Etc...
> 
> Rework things so that we really follow the same paths whether
> or not -r is specified, but with one special case for -r:
> 
> * If the device does not exist, it will be created as
>   a regular file of the minimum size to hold the -r path,
>   or of size specified by the -b option.
> 
> This also changes a little behavior; it does not pre-fill
> the new file with zeros, but allows it to be sparse, and does
> not truncate an existing device file.  If you want to start
> with an empty file, just don't point it at an existing
> file...

Fixes numerous bugs and I find the changes in behaviour sane and
reasonable. A quick test failed for me when the image file does not
exist:

$ rm image
$ ./mkfs.btrfs -r . image
...
not enough free space
add_file_items failed
unable to traverse_directory
Making image is aborted.
ret = -1
mkfs.btrfs: mkfs.c:1533: main: Assertion `!(ret)' failed.

seems that the estimated size is not sufficient.

'du' on the directory (without the image itself) gives me 59M, the image
after failed mkfs has 102M, and it's empty when I try to mount it. Using
the progs .git directory (18M) as sourcedir also failed, but it worked
with man/ subdirectory (94K).

david
