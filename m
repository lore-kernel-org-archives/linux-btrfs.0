Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:40972 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195Ab2JVUq7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 16:46:59 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: device delete, error removing device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20121022195002.GB25498@carfax.org.uk>
Date: Mon, 22 Oct 2012 14:46:57 -0600
Message-Id: <20E50CC9-765A-443F-B797-0A52AC8C713F@colorremedies.com>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <50857C8F.9030401@gmail.com> <E9CD3D97-968D-4475-A699-95D803210DF1@colorremedies.com> <20121022195002.GB25498@carfax.org.uk>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 22, 2012, at 1:50 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
>   Yes, the automatic single -> RAID-0 upgrade was fixed. If you
> haven't run a balance on (at least) the metadata after adding the new
> device, then you won't get the DUP -> RAID-1 upgrade on metadata. (I
> can tell you haven't run the balance, because you still have the empty
> single metadata chunk).

I think it will be common for a balance of either type to not occur to most users. So if there's a way to automatically get a metadata only balance, such that metadata goes from dup to raid1, that would be nice.


>> What is the likelihood of a mkfs.btrfs 2+ device change in the
>> default data profile from raid0 to single?
> 
>   Non-zero. I think it mostly just wants someone to write the patch,
> and then beat off any resulting bikeshedding. :)

I'm curious of the negatives of -d single by default. Maybe this warrants a separate thread for discussion? As for the ensuing input for additional features once going down that path, the only one I'm coming up with is already mentioned above. Simple make options or additional steps go away for "most" people - whoever they are.

Chris Murphy