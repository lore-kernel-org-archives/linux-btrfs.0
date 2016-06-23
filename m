Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:54220 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbcFWVY6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 17:24:58 -0400
Subject: Re: [PATCH 0/3] btrfs-progs: check improve 'checking extents'
 scalability
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <1466709966-31506-1-git-send-email-jeffm@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <576C53A2.3090704@applied-asynchrony.com>
Date: Thu, 23 Jun 2016 23:24:50 +0200
MIME-Version: 1.0
In-Reply-To: <1466709966-31506-1-git-send-email-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/23/16 21:26, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> While running xfstests generic/291, which creates a single file populated
> with reflinks to the same extent, I found that fsck had been running for
> hours.  perf top lead me to find_data_backref as the culprit, and a litte
> more digging made it clear: For every extent record we add, we iterate
> the entire list first.  My test case had ~2M records.  That math doesn't
> go well.
> 
> This patchset converts the extent_backref list to an rbtree.  The test
> that used to run for more than 8 hours without completing now takes
> less than 20 seconds.

Very interesting. Time for science!

unpatched:

holger>time btrfs check /dev/sdc1 
Checking filesystem on /dev/sdc1
..
btrfs check /dev/sdc1  17.03s user 3.79s system 25% cpu 1:22.82 total

patched:

holger>time btrfs check /dev/sdc1
Checking filesystem on /dev/sdc1
..
btrfs check /dev/sdc1  17.03s user 3.74s system 24% cpu 1:23.24 total

This is a 1TB disk with ~850GB data in 4 subvolumes, ~2 snapshots each.
I guess it only starts to matter (relative to the necessary I/O cost per
extent) when the level of sharing is higher, i.e. many more snapshots?

OTOH it doesn't explode, so that's good. :)

cheers
Holger

