Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40028 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161410AbaJaBgp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 21:36:45 -0400
Date: Fri, 31 Oct 2014 09:36:27 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: v3.18-rc2 at a 32 bit KVM gives :"INFO: trying to register
 non-static key.the code is fine but needs lockdep annotation."
Message-ID: <20141031013626.GA30764@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <54511C41.5090603@gmx.de>
 <20141030101552.GD26064@localhost.localdomain>
 <5452CAD7.30602@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5452CAD7.30602@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 31, 2014 at 12:33:43AM +0100, Toralf Förster wrote:
> On 10/30/2014 11:15 AM, Liu Bo wrote:
> > On Wed, Oct 29, 2014 at 05:56:33PM +0100, Toralf Förster wrote:
> >> > This is new in my eyes, or ? :
> > Also new to me, could you please turn on lock debug and try again?
> > 
> > thanks,
> > -liubo
> you mean CONFIG_PROVE_LOCKING=y right ?

I'd have these open,

CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_DEBUG_LOCKDEP=y

__btrfs_alloc_chunk() uses write_[un]lock and spin_[un]lock, it may tell us something.

thanks,
-liubo
