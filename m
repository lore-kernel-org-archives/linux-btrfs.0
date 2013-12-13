Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55577 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751554Ab3LMVaf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 16:30:35 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs-send-receive vs rsync for (incremental/full) backups
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131213203554.GP9738@carfax.org.uk>
Date: Fri, 13 Dec 2013 14:30:26 -0700
Cc: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Message-Id: <3D785BE5-E19C-4C32-8CF9-D10F106727D6@colorremedies.com>
References: <l8fo25$a4h$1@ger.gmane.org> <20131213203554.GP9738@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 13, 2013, at 1:35 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Fri, Dec 13, 2013 at 07:44:16PM +0000, Martin wrote:
>> OK... So for backing up across a local network to a second physical host...
>> 
>> Is btrfs-send-receive stable enough now to be used?
> 
>   It seems to be OK for me at the moment -- I'm not running it across
> a network (yet), but I am using it between different filesystems on
> the same host, using pipes.

Question. Are the source file system's checksums (and metadata) preserved in the send file? Or does the send file just contain data, and checksums are recomputed on receive? I'm curious if the send file can be stored on a non-checksumming file system, and yet have a means to verify the integrity of the files once received. Either the checksums in the send file being check during receive, or subsequent to receive completion by using scrub?

And yes I can confirm that send outputting to a file on a 2nd drive, and receiving it to yet another drive does work, and the source and destination subvolumes are the same in seemingly every way. I didn't separately rsync checksum compare the two subvolumes, however. That seems like possibly a good test. I also haven't tried doing it over a network.


Chris Murphy