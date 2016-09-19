Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:60274 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750696AbcISEMu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 00:12:50 -0400
Date: Mon, 19 Sep 2016 00:12:47 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Post ext3 conversion problems
Message-ID: <20160919041247.GA32208@coach.home>
References: <20160916192459.GA13514@coach.home>
 <CAJCQCtQutt6r2Jovr0jEbTk4W6HUaQpbGiipen97TH1C+k055g@mail.gmail.com>
 <17ca9019-836b-f4f1-f84c-f8c1edcd9925@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <17ca9019-836b-f4f1-f84c-f8c1edcd9925@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2016 at 10:20:37AM +0800, Qu Wenruo wrote:
> <snip>
> -95 is -EOPNOTSUPP.
> 
> Not a common errno in btrfs.
> 
> Most EOPNOTSUPP are related to discard and crapped fallcate/drop extents.
> 
> Then are you using discard mount option?

I did indeed have the discard mount option enabled. I tried booting with
discard disabled, but the same problem appeared.

> <snip>
> Normally a btrfs-debug-tree would help in most case, but this time it seems
> to be a runtime scrub bug other than on-disk metadata corruption.
> 
> What I can see here is, with all your operation, your fs should be a normal
> btrfs, other than converted one.
> 
> To confirm my idea, would you please upload the following things if your
> filesystem is not too large?
> 
> # btrfs-debug-tree -t extent <your device>
> # btrfs-debug-tree -t chunk <your device>
> # btrfs-debug-tree -t dev <your device>
> 
> There is no file/dir name/data contained in the dump. So it's just
> chunk/extent allocation info.
> You could upload them at ease.
> 
> > Not a mess, I think it's a good bug report. I think Qu and David know
> > more about the latest iteration of the convert code. If you can wait
> > until next week at least to see if they have questions that'd be best.
> > If you need to get access to the computer sooner than later I suggest
> > btrfs-image -c9 -t4 -s to make a filename sanitized copy of the
> > filesystem metadata for them to look at, just in case. They might be
> > able to figure out the problem just from the stack trace, but better
> > to have the image before blowing away the file system, just in case
> > they want it.
> 
> Yes, btrfs-image dump would be the best.
> Although sanitizing may takes a long time and the output may be too large.

I had posted a btrfs-image before. It was run with a single -s flag:

http://phead.us/tmp/sgreenslade_home_sanitized_2016-09-16.btrfs

Here's the debug tree data:

http://phead.us/tmp/wheatley_chunk_2016-09-18.dump.gz
http://phead.us/tmp/wheatley_extent_2016-09-18.dump.gz
http://phead.us/tmp/wheatley_dev_2016-09-18.dump.gz

Thanks,

--Sean

