From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs-progs: add dedup functionality
Date: Wed, 5 Jan 2011 11:32:11 -0500
Message-ID: <20110105163211.GA2562@localhost.localdomain>
References: <1294244451-4558-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294244451-4558-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 05, 2011 at 11:20:51AM -0500, Josef Bacik wrote:
> This program very basically does dedup.  It searches a directory recursively and
> scans all of the files looking for 64k extents and hashing them to figure out if
> there are any duplicates.  After that it calls the btrfs same extent ioctl for
> all of the duplicates in order to dedup the space on disk.  There is alot more
> that can be done with this, like changing the block size and so on, but for now
> this will get us started.  Thanks,
> 

Argh crap ignore this, this is only part of the commit, I meant to send this out
as a series.  Thanks,

Josef
