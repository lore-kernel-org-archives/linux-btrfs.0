Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33039 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaLBUh3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 15:37:29 -0500
Received: by mail-pa0-f53.google.com with SMTP id kq14so14225542pab.40
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 12:37:29 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH-v5 1/5] vfs: add support for a lazytime mount option
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20141202192337.GA13618@thunk.org>
Date: Tue, 2 Dec 2014 13:37:27 -0700
Cc: Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <0CAF91FD-F713-4E98-8967-9CA0390CA784@dilger.ca>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu> <1417154411-5367-2-git-send-email-tytso@mit.edu> <20141128172323.GD738@quack.suse.cz> <20141128181421.GA19461@google.com> <20141202125820.GE9092@quack.suse.cz> <547DFD24.9070805@plexistor.com> <20141202192337.GA13618@thunk.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Dec 2, 2014, at 12:23 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Dec 02, 2014 at 07:55:48PM +0200, Boaz Harrosh wrote:
>> 
>> This I do not understand. I thought that I_DIRTY_TIME, and the all
>> lazytime mount option, is only for atime. So if there are dirty
>> pages then there are also m/ctime that changed and surly we want to
>> write these times to disk ASAP.
> 
> What are the situations where you are most concerned about mtime or
> ctime being accurate after a crash?
> 
> I've been running with it on my laptop for a while now, and it's
> certainly not a problem for build trees; remember, whenever you need
> to update the inode to update i_blocks or i_size, the inode (with its
> updated timestamps) will be flushed to disk anyway.
[snip]
> I'm not aware of an application which is doing a large number of
> non-allocating random writes (for example, such as a database), where
> said database actually cares about mtime being correct.
[snip]
> Did you have such a use case or application in mind?


One thing that comes to mind is touch/utimes()/utimensat().  Those
should definitely not result in timestamps being kept only in memory
for 24h, since the whole point of those calls is to update the times.
It makes sense for these APIs to dirty the inode for proper writeout.

Cheers, Andreas

>> if we are lazytime also with m/ctime then I think I would like an
>> option for only atime lazy. because m/ctime is cardinal to some
>> operations even though I might want atime lazy.
> 
> If there's a sufficiently compelling use case where we do actually
> care about mtime/ctime being accurate, and the current semantics don't
> provide enough of a guarantee, it's certainly something we could do.
> I'd rather keep things simple unless it's really there.  (After all,
> we did create the strictatime mount option, but I'm not sure anyone
> every ends up using it.  It woud be a shame if we created a
> strictcmtime, which had the same usage rate.)
> 
> I'll also note that if it's only about atime updates, with the default
> relatime mount option, I'm not sure there's enough of a win to hae a
> mode to justify a lazyatime only option.  If you really neeed strict
> c/mtime after a crash, maybe the best thing to do is to just simply
> not use the lazytime mount option and be done with it.
> 
> Cheeres,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





