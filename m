Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from manchmal.in-ulm.de ([217.10.9.201]:36681 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbbIKX25 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 19:28:57 -0400
Date: Sat, 12 Sep 2015 01:21:54 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Chris Mason <clm@fb.com>, Christoph Hellwig <hch@lst.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>
Subject: Re: btrfs regression since 4.X kernel NULL pointer dereference
Message-ID: <1442013503@msgid.manchmal.in-ulm.de>
References: <55D8B193.8010906@profihost.ag>
 <20150825090030.GF31630@lst.de>
 <20150825135146.GE7176@ret.masoncoding.com>
 <590FB3C7-8BCA-4B04-BBB0-92863E02A89C@profihost.ag>
 <20150901000610.GC5136@ret.masoncoding.com>
 <55E52C6D.6050504@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55E52C6D.6050504@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Priebe wrote...

> Thanks. We're using schroot like the user in this bugreport:
> https://bugzilla.kernel.org/show_bug.cgi?id=100911
> 
> But he also claims he found another way to reproduce using vfcgbackup (last
> comment).

FWIW, this was still the same thing, just stripped down to get closer
to the actual cause. It began with building a private Debian package
that has lvm2 as build dependency. Daemons are disabled in the build
chroot (via policy-rc.d) but the vfcgbackup invocation in lvm2's
postinst is still run.

Also, a quick test of Jeff's update to the Bugzilla ticket looks very
good. More tests will follow.

    Christoph
