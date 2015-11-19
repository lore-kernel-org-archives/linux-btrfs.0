Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gourmet.spamgourmet.com ([216.75.62.102]:57894 "EHLO
	gourmet8.spamgourmet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759222AbbKST05 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 14:26:57 -0500
Received: from spamgourmet by gourmet7.spamgourmet.com with local (Exim 4.80)
	(envelope-from <linux-btrfs.tebulin@xoxy.net>)
	id 1ZzUrA-0005sF-J1
	for linux-btrfs@vger.kernel.org; Thu, 19 Nov 2015 19:26:56 +0000
From: linux-btrfs.tebulin@xoxy.net
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk> <564E085C.3060208@gmail.com>
 <20151119182850.GE24333@carfax.org.uk> <564E18B9.2020509@gmail.com>
 <20151119185645.GF24333@carfax.org.uk>
Message-ID: <564E227C.9000909@gmail.com>
Date: Thu, 19 Nov 2015 20:26:52 +0100
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
In-Reply-To: <20151119185645.GF24333@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This explanation helped a lot. Got it now!

Thank you!

>    You start with a load of unused space -- that's the "total" for
> each device in btrfs fi show. That space is allocated to specific
> usages as the FS needs it. The allocated space is the "used" in btrfs
> fi show for each device.
> 
>    Then we switch to looking at btrfs fi df. The "total" values are
> the amount of the *allocated* space given to each type of storage.
> Within those, actual stuff is stored (like your files), which is the
> "used" value for each kind of storage.
> 
>    If you've ever played SimCity, the allocation process is like
> zoning -- you say what kind of thing can go on the space, but it's not
> actually used until something gets built on it.
> 
>    The problem you hit is when everything has been allocated, and
> there's a need for more metadata space (usually), and there's lots of
> unused data space. The balance operation moves some things around so
> that some of the unused data allocation can be freed up, giving the FS
> the ability to allocate more metadata space.


