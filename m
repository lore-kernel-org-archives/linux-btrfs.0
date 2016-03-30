Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:54078 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbcC3I10 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 04:27:26 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1alBTI-00080U-Hr
	for linux-btrfs@vger.kernel.org; Wed, 30 Mar 2016 10:27:24 +0200
Date: Wed, 30 Mar 2016 10:27:24 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: "bad metadata" not fixed by btrfs repair
Message-ID: <20160330082724.GK9342@torres.zugschlus.de>
References: <20160328143714.GZ10135@torres.zugschlus.de>
 <56F98784.8090700@gmail.com>
 <20160329064351.GA28990@torres.zugschlus.de>
 <56FB7983.2060608@cn.fujitsu.com>
 <20160330071812.GJ9342@torres.zugschlus.de>
 <56FB8845.5040904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56FB8845.5040904@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 04:03:17PM +0800, Qu Wenruo wrote:
> Did your btrfs have enough *unallocated* space?

87 Gig out of a total 200 Gig Device size. I guess that should be
enough for a rebalance of 2,8 Gig Metadata.

Greetings
Ma "please excuse my cynism" rc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
