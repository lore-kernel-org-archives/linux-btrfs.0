Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932732AbbDJN20 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Apr 2015 09:28:26 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150409235234.GJ13731@dastard>
References: <20150409235234.GJ13731@dastard> <20150409174916.5a2efef5@notabene.brown> <29536.1428571388@warthog.procyon.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: dhowells@redhat.com, NeilBrown <neilb@suse.de>,
        linux-btrfs@vger.kernel.org, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH/RFC] fscache/cachefiles versus btrfs
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 10 Apr 2015 14:28:16 +0100
Message-ID: <9282.1428672496@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave Chinner <david@fromorbit.com> wrote:

> SEEK_HOLE/SEEK_DATA is what you want, as they are page cache
> coherent, not extent based operations. And, really if you need it to
> really be able to find real holes, then a superblock flag might be a
> better way of marking filesystems with the required capability.

Actually, I wonder if what I want is a kernel_read() that returns ENODATA upon
encountering a hole at the beginning of the area to be read.

Of course, what I really, really want is asynchronous, direct read and write
within the kernel, where the read will notify you of any holes, but will read
all the data it can around those holes.

David
