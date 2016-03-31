Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:33572 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbcCaVAG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 17:00:06 -0400
Date: Thu, 31 Mar 2016 23:00:04 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: bad metadata crossing stripe boundary
Message-ID: <20160331210004.GZ9342@torres.zugschlus.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
 <56F1068E.6050806@cn.fujitsu.com>
 <20160322194854.161e9c4c@jupiter.sol.kaishome.de>
 <56F21898.3020101@cn.fujitsu.com>
 <20160326203035.4b876a04@jupiter.sol.kaishome.de>
 <20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
 <56F7E65C.7020300@gmx.com>
 <20160328120203.1b8d79dc@jupiter.sol.kaishome.de>
 <56FC7E6D.8010805@cn.fujitsu.com>
 <56FC8C15.5060002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56FC8C15.5060002@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2016 at 10:31:49AM +0800, Qu Wenruo wrote:
> Would you please try the following patch based on v4.5 btrfs-progs?
> https://patchwork.kernel.org/patch/8706891/

This also fixes the "bad metadata crossing stripe boundary" on my pet
patient.

I find it somewhere between funny and disturbing that the first call
of btrfs check made my kernel log the following:
Mar 31 22:45:36 fan kernel: [ 6253.178264] EXT4-fs (dm-31): mounted filesystem with ordered data mode. Opts: (null)
Mar 31 22:45:38 fan kernel: [ 6255.361328] BTRFS: device label fanbtr devid 1 transid 67526 /dev/dm-31

No, the filesystem was not converted, it was directly created as
btrfs, and no, I didn't try mounting it.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
