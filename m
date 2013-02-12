Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab3BLTo5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 14:44:57 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1CJivg2026418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 14:44:57 -0500
Date: Tue, 12 Feb 2013 11:44:56 -0800
From: Zach Brown <zab@redhat.com>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What can I do to make btrfs work?
Message-ID: <20130212194456.GD14246@lenny.home.zabbo.net>
References: <20130212185449.GA16773@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130212185449.GA16773@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 12, 2013 at 06:54:49PM +0000, Richard W.M. Jones wrote:
> Btrfs has been broken for me for ages.  I first reported it on this
> list 5 months ago[1].  Below is a very simple reproducer that anyone
> can run.

The very simple reproducer doesn't fail over here on bare hardware for
me.

# dmesg | grep -c 'device label TEST'
808

(keeps it spinning)

> *NB* before you run this, adjust /dev/sda & /dev/sda1 to point to an
> unused block device!

What block devices are you using?  I ask because how it implements
caching affects this test.

The theory, as I understand it, is that btrfs is issuing bio reads that
don't see the cached writes from mkfs.

You'd never see this bug on loopback because it serves bio reads from
the cache that mkfs wrote to.

I'm not seeing it on hardware because the filemap_write_and_wait() that
btrfs does in the kernel on mount is syncing the cached writes.  The bio
reads then get the mkfs data from disk.

If your block device has a cache that doesn't sync with btrfs calls
this, you'd see this problem.. but..  that'd be strange indeed.  Chris'
test patch to sync from mkfs would probably help, but you'd still see
the problem if, say, you just wrote a btrfs image to the block device
and reasonably expected the kernel to find it on mount.

So it'd be nice to know what devices you're using.  Maybe some nutty
in-guest virt passthrough thing?

- z
