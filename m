Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:39102 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab2GZRIT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jul 2012 13:08:19 -0400
Date: Thu, 26 Jul 2012 19:08:15 +0200
From: David Sterba <dave@jikos.cz>
To: Marios Titas <redneb8888@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: No/bad auto-detection of fs type for small volumes (related to
 mixed metadata/data?)
Message-ID: <20120726170815.GJ17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAAdM644Xs1Vq-Sw4ZacGz_gBrURHzEhhs4drXJC+dMtP0DhSiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAdM644Xs1Vq-Sw4ZacGz_gBrURHzEhhs4drXJC+dMtP0DhSiw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 24, 2012 at 08:39:36PM -0400, Marios Titas wrote:
> When I create a btrfs volume of size strictly less than 256 MiB then if I do
>     mount /dev/sdb1 /mnt/test
> the kernel tries unsuccessfully to do the mount with many other file systems
> before successfully trying with btrfs. For volumes of size larger than
> or equal to
> 256 MiB it just mounts the volume without doing that. Why is this discrepancy?

[As Hugo wrote, use --mixed in that case]

The underlying reason why it fails is that 256M is a size of some
internal structure. If the size is smaller, filesystem will not set up
itself, then the mount fails. And mount interprets this as if the
filesystem was not there and tries next one.


david
