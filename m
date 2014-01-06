Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144AbaAFRxN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 12:53:13 -0500
Date: Mon, 6 Jan 2014 18:53:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Gerhard Heift <gerhard@heift.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: FILE_EXTENT_SAME changes mtime and ctime
Message-ID: <20140106175312.GB6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CACeaM8_zLWB_R3-kWWqGGk45ySbXEpb9J1f58adggoQ7Ovi-Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACeaM8_zLWB_R3-kWWqGGk45ySbXEpb9J1f58adggoQ7Ovi-Ng@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 06, 2014 at 12:02:51AM +0100, Gerhard Heift wrote:
> I am currently playing with snapshots and manual deduplication of
> files. During these tests I noticed the change of ctime and mtime in
> the snapshot after the deduplication with FILE_EXTENT_SAME. Does this
> happens on purpose? Otherwise I would like to have ctime and mtime
> left unmodified, because on a read only snapshot I cannot change them
> back after the ioctl call.

I'm not sure what's the correct behaviour wrt timestamps and extent
cloning. The inode metadata are modified in some way, but the stat data
and actual contents are left unchanged, so the timestamps do not reflect
that something changed according to their definition (stat(2)).

On the other hand, the differences can be seen in the extent listing,
the physical offset of the blocks will change. I'm not aware of any
tools that would become broken by breaking this assumption. Also, the
(partial) cloning functionality is not implemented anywhere so we could
have a look and try to stay consistent with that.

My oppinion is to drop the mtime/iversion updates completely.


david
