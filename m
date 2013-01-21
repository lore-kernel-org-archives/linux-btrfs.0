Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab3AUNB3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 08:01:29 -0500
Date: Mon, 21 Jan 2013 14:01:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Gene Czarcinski <gene@czarc.net>, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 6/6] Btrfs-progs: detect if the disk we are formatting is
 a ssd
Message-ID: <20130121130122.GH19967@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358618781-26629-1-git-send-email-gene@czarc.net>
 <1358618781-26629-7-git-send-email-gene@czarc.net>
 <50FB0CA1.4070204@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FB0CA1.4070204@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 19, 2013 at 11:14:09PM +0200, Brendan Hide wrote:
> On 2013/01/19 08:06 PM, Gene Czarcinski wrote:
> >Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> >Signed-off-by: Gene Czarcinski <gene@czarc.net>
> >---
> >-values are raid0, raid1, raid10 or single.
> >+values are raid0, raid1, raid10, single or dup.  Single device will have dup
> >+set by default except in the case of SSDs which will default to single.  This is
> >+because SSDs can remap blocks internally so duplicate blocks could end up in the
> >+same erase block which negates the benefits of doing metadata duplication.
> Can't help but suggest that a "NO_DEDUP" command could be added to the SATA
> Transport Protocol/SCSI Command set. Not sure where to submit that idea ...
> :-/

You might get your answer from lkml, fsdevel or linux-scsi.

david
