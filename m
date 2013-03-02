Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:53307 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3CBApT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 19:45:19 -0500
Date: Sat, 2 Mar 2013 01:45:02 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: Liu Bo <bo.li.liu@oracle.com>
cc: linux-btrfs@vger.kernel.org
Subject: Re: Changing allocation mode
In-Reply-To: <20130227012832.GB7028@liubo>
Message-ID: <alpine.DEB.2.02.1303020144341.8295@shack.dolda2000.com>
References: <alpine.DEB.2.02.1302230138220.8295@shack.dolda2000.com> <20130227012832.GB7028@liubo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 27 Feb 2013, Liu Bo wrote:
> On Sat, Feb 23, 2013 at 01:46:03AM +0100, Fredrik Tolf wrote:
>> If I were transferring the data to a new filesystem on mdraid, the
>> procedure I would use for that last portion of the data would be to
>> remove one disk only from either of the old mdraid mirror arrays
>> (putting that array in degraded mode), and then create a new mirror
>> in degraded mode with only that disk, add that mirror to the new
>> filesystem, expand it, copy the last data, and then delete the old
>> mirrors, moving the rest of the disks to the new filesystem.
>
> That sounds like using seed device, although seed disk is designed for another
> different purpose.

It does? I must admit I don't see quite how that would be applicable.

--

Fredrik Tolf
