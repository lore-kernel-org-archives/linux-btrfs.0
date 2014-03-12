Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:51609 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753037AbaCLQ7j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 12:59:39 -0400
Date: Wed, 12 Mar 2014 18:59:35 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: mkfs: let user known when forcing mixed
 metadata/data groups
Message-ID: <20140312165935.GA1557@localhost.localdomain>
References: <20140312134322.GA28005@localhost.localdomain>
 <20140312163614.GC6782@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20140312163614.GC6782@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 12, 2014 at 05:36:14PM +0100, David Sterba wrote:
> On Wed, Mar 12, 2014 at 03:43:24PM +0200, Rakesh Pandit wrote:
> > While formatting multiple devics (and user doesn't specify -M) if one
> > of them has block count or size less then 1 GiB, mkfs doesn't tell
> > user, on which one mixed metadata/data was forced. This patch updates
> > message to print device name.
> 
> I think we should fix the constraints what devices can be used together,
> mixing small and large ones works, but I don't think it's the usecase
> I'd recommend. And I'm not sure the mixed profile was intended for
> multiple devices at all.

Yes makes sense, thanks for review.

regards,
