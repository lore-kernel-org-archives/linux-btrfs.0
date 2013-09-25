Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:53091 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040Ab3IYLa0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 07:30:26 -0400
Date: Wed, 25 Sep 2013 20:30:14 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: dsterba@suse.cz
Cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs: qgroup scan failed with -12
Message-ID: <20130925203014.2153ec6b@wpkg.org>
In-Reply-To: <20130925101124.GT6810@suse.cz>
References: <20130923074344.60f629d7@wpkg.org>
	<20130923171905.GR6810@twin.jikos.cz>
	<20130923174348.GC18681@localhost.localdomain>
	<20130925101124.GT6810@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 25 Sep 2013 12:11:24 +0200
David Sterba <dsterba@suse.cz> wrote:

> On Mon, Sep 23, 2013 at 01:43:48PM -0400, Josef Bacik wrote:
> > I've done that with a patch in bugzilla, hopefully that will fix
> > it.  I've not had time to try and reproduce myself, but I assume if
> > you do something like create a random file, then create 100000
> > snapshots and then defrag it will probably hit the same problem.
> > Thanks,
> 
> The patch looks ok.
> 
> I've tried to reproduce it with 100k subvolumes but was not lucky to
> hit the allocation failure.

For me, it was quite easy (i.e. every few days) to hang the server with
32 GB RAM with the following:

- BackupPC running,

- fs mounted with noatime,compress-force=zlib

- extended inode refs enabled,

- skinny metadata extent refs enabled,

- qgroups enabled.


For those unfamiliar, BackupPC is a backup program.
It works by rsyncing data from (possibly many) remote systems.

Then, it "deduplicates" identical files, by hardlinking the files to
identical ones in its pool.
As a result, a system running BackupPC will have lots of files
(multiple revisions of backups, from many systems) with lots of
hardlinks.

Additionally, once per night, BackupPC scans its pool of hardlinked
files to find the ones with no hardlinks (meaning, file is unused, can
be removed); typically, the process takes many hours to finish.
I believe this is when my system with btrfs was hanging.

BackupPC doesn't use any specific btrfs features, like snapshots.


With the above, my system was hanging regularly, every few days.


I've disabled BackupPC and I'm running rsync + btrfs snapshot now - no
hang since then (at least till now). Could be coincidence, but who
knows.

[1] http://backuppc.sourceforge.net

-- 
Tomasz Chmielewski
http://wpkg.org
