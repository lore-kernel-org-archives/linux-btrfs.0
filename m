Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:39568 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbcDBJof (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Apr 2016 05:44:35 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1amI6a-0004Rd-HX
	for linux-btrfs@vger.kernel.org; Sat, 02 Apr 2016 11:44:32 +0200
Date: Sat, 2 Apr 2016 11:44:32 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: bad metadata crossing stripe boundary
Message-ID: <20160402094432.GQ9342@torres.zugschlus.de>
References: <20160326203035.4b876a04@jupiter.sol.kaishome.de>
 <20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
 <56F7E65C.7020300@gmx.com>
 <20160328120203.1b8d79dc@jupiter.sol.kaishome.de>
 <56FC7E6D.8010805@cn.fujitsu.com>
 <56FC8C15.5060002@cn.fujitsu.com>
 <20160331210004.GZ9342@torres.zugschlus.de>
 <20160331231630.7b4ceda9@jupiter.sol.kaishome.de>
 <20160401055725.GA9342@torres.zugschlus.de>
 <20160402110353.10ae123a@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160402110353.10ae123a@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 02, 2016 at 11:03:53AM +0200, Kai Krakow wrote:
> Am Fri, 1 Apr 2016 07:57:25 +0200
> schrieb Marc Haber <mh+linux-btrfs@zugschlus.de>:
> > On Thu, Mar 31, 2016 at 11:16:30PM +0200, Kai Krakow wrote:
> > > Am Thu, 31 Mar 2016 23:00:04 +0200
> > > schrieb Marc Haber <mh+linux-btrfs@zugschlus.de>:  
> > > > I find it somewhere between funny and disturbing that the first
> > > > call of btrfs check made my kernel log the following:
> > > > Mar 31 22:45:36 fan kernel: [ 6253.178264] EXT4-fs (dm-31):
> > > > mounted filesystem with ordered data mode. Opts: (null) Mar 31
> > > > 22:45:38 fan kernel: [ 6255.361328] BTRFS: device label fanbtr
> > > > devid 1 transid 67526 /dev/dm-31
> > > > 
> > > > No, the filesystem was not converted, it was directly created as
> > > > btrfs, and no, I didn't try mounting it.  
> > > 
> > > I suggest that your partition contained ext4 before, and you didn't
> > > run wipefs before running mkfs.btrfs.  
> > 
> > I cryptsetup luksFormat'ted the partition before I mkfs.btrfs'ed it.
> > That should do a much better job than wipefsing it, shouldnt it?
> 
> Not sure how luksFormat works. If it encrypts what is already on the
> device, it would also encrypt orphan superblocks.

It overwrites the LUKS metadata including the symmetric key that was
used to encrypt the existing data. Short of Shor's Algorithm and
Quantum Computers, after that operation it is no longer possible to
even guess what was on the disk before.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
