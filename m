Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbcEKNgw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 09:36:52 -0400
Date: Wed, 11 May 2016 15:36:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, vegard.nossum@oracle.com, dsterba@suse.com
Subject: Re: [PATCH 2/3] Btrfs-progs: add three more valid checks for
 superblock
Message-ID: <20160511133629.GD29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462213135-29678-1-git-send-email-bo.li.liu@oracle.com>
 <1462213135-29678-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462213135-29678-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 02, 2016 at 11:18:54AM -0700, Liu Bo wrote:
> This adds valid checks for super_total_bytes, super_bytes_used and
> super_stripesize.
> 
> Since these checks are made after superblock finishes checksum
>  checking, this also adds a notice of "superblock checksum match but..".
> 
> This also replaces different kinds of printf with helper error() and
> warning().

"This patch also does something completely different" is a good sign for
patch splitting. I'll do that now but please keep that in mind next
time.
