Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:41924 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbcDCIjb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Apr 2016 04:39:31 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1amdZA-0002fm-La
	for linux-btrfs@vger.kernel.org; Sun, 03 Apr 2016 10:39:28 +0200
Date: Sun, 3 Apr 2016 10:39:28 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: bad metadata crossing stripe boundary
Message-ID: <20160403083928.GT9342@torres.zugschlus.de>
References: <56F7E65C.7020300@gmx.com>
 <20160328120203.1b8d79dc@jupiter.sol.kaishome.de>
 <56FC7E6D.8010805@cn.fujitsu.com>
 <56FC8C15.5060002@cn.fujitsu.com>
 <20160331210004.GZ9342@torres.zugschlus.de>
 <20160331231630.7b4ceda9@jupiter.sol.kaishome.de>
 <20160401055725.GA9342@torres.zugschlus.de>
 <20160402110353.10ae123a@jupiter.sol.kaishome.de>
 <20160402094432.GQ9342@torres.zugschlus.de>
 <20160402203117.4d815f13@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160402203117.4d815f13@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 02, 2016 at 08:31:17PM +0200, Kai Krakow wrote:
> Am Sat, 2 Apr 2016 11:44:32 +0200
> schrieb Marc Haber <mh+linux-btrfs@zugschlus.de>:
> 
> > On Sat, Apr 02, 2016 at 11:03:53AM +0200, Kai Krakow wrote:
> > > Am Fri, 1 Apr 2016 07:57:25 +0200
> > > schrieb Marc Haber <mh+linux-btrfs@zugschlus.de>:  
> > > > On Thu, Mar 31, 2016 at 11:16:30PM +0200, Kai Krakow wrote:  
> >  [...]  
> >  [...]  
> >  [...]  
> > > > 
> > > > I cryptsetup luksFormat'ted the partition before I mkfs.btrfs'ed
> > > > it. That should do a much better job than wipefsing it, shouldnt
> > > > it?  
> > > 
> > > Not sure how luksFormat works. If it encrypts what is already on the
> > > device, it would also encrypt orphan superblocks.  
> > 
> > It overwrites the LUKS metadata including the symmetric key that was
> > used to encrypt the existing data. Short of Shor's Algorithm and
> > Quantum Computers, after that operation it is no longer possible to
> > even guess what was on the disk before.
> 
> If it was encrypted before... ;-)

First, it was.

Second, cleartext found on the block device is quite unlikely to be
readable from the unlocked crypto device. I would be very worried if
that were the case.

I must be missing something here.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
