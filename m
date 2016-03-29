Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:49242 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbcC2Gnx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 02:43:53 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1aknNX-00006n-9n
	for linux-btrfs@vger.kernel.org; Tue, 29 Mar 2016 08:43:51 +0200
Date: Tue, 29 Mar 2016 08:43:51 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: "bad metadata" not fixed by btrfs repair
Message-ID: <20160329064351.GA28990@torres.zugschlus.de>
References: <20160328143714.GZ10135@torres.zugschlus.de>
 <56F98784.8090700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56F98784.8090700@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 28, 2016 at 03:35:32PM -0400, Austin S. Hemmelgarn wrote:
> Did you convert this filesystem from ext4 (or ext3)?

No.

> You hadn't mentioned what version of btrfs-progs you're using, and that is
> somewhat important for recovery.  I'm not sure if current versions of btrfs
> check can fix this issue, but I know for a fact that older versions (prior
> to at least 4.1) can not fix it.

4.1 for creation and btrfs check.

> As far as what the kernel is involved with, the easy way to check is if it's
> operating on a mounted filesystem or not.  If it only operates on mounted
> filesystems, it almost certainly goes through the kernel, if it only
> operates on unmounted filesystems, it's almost certainly done in userspace
> (except dev scan and technically fi show).

Then btrfs check is a userspace-only matter, as it wants the fs
unmounted, and it is irrelevant that I did btrfs check from a rescue
system with an older kernel, 3.16 if I recall correctly.

> 2. Regarding general support:  If you're using an enterprise distribution
> (RHEL, SLES, CentOS, OEL, or something similar), you are almost certainly
> going to get better support from your vendor than from the mailing list or
> IRC.

My "productive" desktops (fan is one of them) run Debian unstable with
a current vanilla kernel. At the moment, I can't use 4.5 because it
acts up with KVM.  When I need a rescue system, I use grml, which
unfortunately hasn't released since November 2014 and is still with
kernel 3.16

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
