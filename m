Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:53680 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbcC3G2j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 02:28:39 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1al9cL-0006uu-Mj
	for linux-btrfs@vger.kernel.org; Wed, 30 Mar 2016 08:28:37 +0200
Date: Wed, 30 Mar 2016 08:28:37 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: "bad metadata" not fixed by btrfs repair
Message-ID: <20160330062837.GG9342@torres.zugschlus.de>
References: <20160328143714.GZ10135@torres.zugschlus.de>
 <56F98784.8090700@gmail.com>
 <20160329064351.GA28990@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160329064351.GA28990@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 29, 2016 at 08:43:51AM +0200, Marc Haber wrote:
> On Mon, Mar 28, 2016 at 03:35:32PM -0400, Austin S. Hemmelgarn wrote:
> > As far as what the kernel is involved with, the easy way to check is if it's
> > operating on a mounted filesystem or not.  If it only operates on mounted
> > filesystems, it almost certainly goes through the kernel, if it only
> > operates on unmounted filesystems, it's almost certainly done in userspace
> > (except dev scan and technically fi show).
> 
> Then btrfs check is a userspace-only matter, as it wants the fs
> unmounted, and it is irrelevant that I did btrfs check from a rescue
> system with an older kernel, 3.16 if I recall correctly.

And it also means that I should not try btrfs balance from grml
because btrfs balance goes through the kernel code.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
