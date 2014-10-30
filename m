Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52934 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161211AbaJ3Xdr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 19:33:47 -0400
Message-ID: <5452CAD7.30602@gmx.de>
Date: Fri, 31 Oct 2014 00:33:43 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: v3.18-rc2 at a 32 bit KVM gives :"INFO: trying to register non-static
 key.the code is fine but needs lockdep annotation."
References: <54511C41.5090603@gmx.de> <20141030101552.GD26064@localhost.localdomain>
In-Reply-To: <20141030101552.GD26064@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/30/2014 11:15 AM, Liu Bo wrote:
> On Wed, Oct 29, 2014 at 05:56:33PM +0100, Toralf Förster wrote:
>> > This is new in my eyes, or ? :
> Also new to me, could you please turn on lock debug and try again?
> 
> thanks,
> -liubo
you mean CONFIG_PROVE_LOCKING=y right ?

-- 
Toralf
pgp key: 0076 E94E

