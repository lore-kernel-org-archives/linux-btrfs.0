Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40756 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbaBJN71 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 08:59:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCrOO-0007TB-0j
	for linux-btrfs@vger.kernel.org; Mon, 10 Feb 2014 14:59:24 +0100
Received: from 212.44.20.129.ip.redstone-isp.net ([212.44.20.129])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 14:59:24 +0100
Received: from frank by 212.44.20.129.ip.redstone-isp.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 14:59:24 +0100
To: linux-btrfs@vger.kernel.org
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
Subject: Re: btrfs send runs out of memory and file handles
Date: Mon, 10 Feb 2014 13:59:07 +0000
Message-ID: <52F8DB2B.6090902@kingswood-consulting.co.uk>
References: <52F8D406.7000207@kingswood-consulting.co.uk> <20140210134748.GI6490@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <20140210134748.GI6490@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/02/14 13:47, Hugo Mills wrote:
> On Mon, Feb 10, 2014 at 01:28:38PM +0000, Frank Kingswood wrote:
>>
>> I'm attempting to back up a btrfs subvolume
 >> [...]
>> Doing so runs out of file descriptors on the sending machine (having
>> over 100k files open) and eventually runs out of memory and gets
>> killed by the OOM killer.
>
>     This sounds like a known bug, and I think it was fixed in 3.13.
> What kernel version are you using?

This is on 3.12.5.
I can build and install 3.13.2 and test it again.

Frank


