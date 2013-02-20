Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:48527 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934944Ab3BTPhR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 10:37:17 -0500
Message-ID: <5124EDAB.5020003@giantdisaster.de>
Date: Wed, 20 Feb 2013 16:37:15 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to overwrite
 filesystem or partition table
References: <511D2D2B.8040804@redhat.com>
In-Reply-To: <511D2D2B.8040804@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 14 Feb 2013 12:30:03 -0600, Eric Sandeen wrote:
> The core of this is shamelessly stolen from xfsprogs.
> 
> Use blkid to detect an existing filesystem or partition
> table on any of the target devices.  If something is found,
> require the '-f' option to overwrite it, hopefully avoiding
> disaster due to mistyped devicenames, etc.
> 
> # mkfs.btrfs /dev/sda1
> 
> WARNING! - Btrfs v0.20-rc1-59-gd00279c-dirty IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> /dev/sda1 appears to contain an existing filesystem (xfs).
> Use the -f option to force overwrite.
> #
> 
> This does introduce a requirement on libblkid.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

This means that it is now required to change all occurrences of
"mkfs.btrfs" to "mkfs.btrfs -f" everywhere. Can't we first establish a
time period of 100 years where the -f option is tolerated and ignored,
and then in 2113 we require that the users add the -f option?

(Just had to do this string replacement everywhere, and had to add -f to
xfstest's _scratch_mkfs in common.rc as well). Sigh.

