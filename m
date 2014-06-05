Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41760 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaFEOmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 10:42:16 -0400
From: Russell Coker <russell@coker.com.au>
To: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Using BTRFS on SSD now ?
Date: Fri, 06 Jun 2014 00:42:12 +1000
Message-ID: <1693566.Q9bXme5jtu@xev>
In-Reply-To: <2215647.hErg5R77lo@zafu>
References: <2215647.hErg5R77lo@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 5 Jun 2014 15:30:26 Swâmi Petaramesh wrote:
> I just received a new laptop with a Micron 256GB SSD, and I plan to install
> Fedora 20 onto it.
> 
> I'm considering either BTRFS or ext4 (over LUKS-encrypted LVM) for this
> machine, but I'm afraid BTRFS might generate too much writes and shorten the
> SSD lifespan... Or am I mistaken ?

http://etbe.coker.com.au/2014/04/27/swap-breaking-ssd/

I recently did some calculations based on the usage of workstations I run on 
SSD storage.  While the main focus of my post was swap and SSD I also did the 
calculations for the supposed life of SSDs and BTRFS filesystem use (all 
workstations in question run BTRFS).  My conclusion is that if the most 
conservative (pessimistic) claims about SSD life are correct then there's 
still nothing to worry about.

Also I think that laptops tend to have less use than workstations, so unless 
your laptop is your main desktop system it should get less disk use than a 
typical workstation.

http://etbe.coker.com.au/2014/05/12/btrfs-vs-lvm/

I don't believe that LVM offers any benefit if you use BTRFS.

> Is there any pro/cons currently, on a 3.14 kernel, about using BTRFS along
> with an SSD ?

Apart from BTRFS being new and still a bit buggy, not at all.

> Is there specific advice about leaf size, use of compression, snapshots,
> (auto-)defrag etc, that might be relevant especially for SSDs ?

SSDs being a lot faster than spinning media remove many of these issues.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

