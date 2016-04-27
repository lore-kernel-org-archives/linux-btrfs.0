Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:53712 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbcD0Q3x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 12:29:53 -0400
Received: from tux.wizards.de (pD953EFF0.dip0.t-ipconnect.de [217.83.239.240])
	by mail02.iobjects.de (Postfix) with ESMTPSA id 18AAA41601A6
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 18:29:51 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id AECC311C01D9
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 18:29:50 +0200 (CEST)
Subject: Re: Add device while rebalancing
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
 <pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net> <571DFCF2.6050604@gmail.com>
 <pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net> <571E154C.9060604@gmail.com>
 <CAHaPQf03yMAxMZRa=zr3Fjh_B+-ggwwuzRFwDsUyK3t=jW2WFw@mail.gmail.com>
 <571F4CD0.9050004@gmail.com>
 <CAHaPQf39H-JRhQmCssmgJ98RCxL_36poE_kObAmgmH6nkn4xoA@mail.gmail.com>
 <CAJCQCtQbCbR9V7z4jZCejbKLJyhBbtrZJmcQBkX=VnxReBf46g@mail.gmail.com>
 <5720A0E8.5000407@gmail.com>
 <CAHaPQf3cR4jXKziSCqp0CnrB6oKQoO=2kywsKuo7BLqHqBjBRw@mail.gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <5720E8FE.2000407@googlemail.com>
Date: Wed, 27 Apr 2016 18:29:50 +0200
MIME-Version: 1.0
In-Reply-To: <CAHaPQf3cR4jXKziSCqp0CnrB6oKQoO=2kywsKuo7BLqHqBjBRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/27/16 17:58, Juan Alberto Cirez wrote:
> Correct me if I'm wrong but the sum total of the above seems to
> suggest (at first glance) that BRTFS add several layers of complexity,
> but for little real benefit (at least in the case use of btrfs at the
> brick layer with a distributed filesystem on top)...

This may come as a surprise, but the same can be said for every other
(common) filesystem (+ device management stack) that can be used
standalone.

Jeff Darcy (of GlusterFS) just wrote a really nice blog post why
current filesystems and their historically grown requirements (mostly
as they relate to the POSIX interface standard) are in many ways
just not a good fit for scale-out/redundant storage:
http://pl.atyp.us/2016-05-updating-posix.html

Quite a few of the capabilities & features which are useful or
necessary in standalone operation (regardless of single- or multi-
device setup) are *actively unhelpful* in a distributed context, which
is why e.g. Ceph will soon do away with the on-disk filesystem for
data, and manage metadata exclusively by itself.

cheers,
Holger

