Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:51014 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755337AbcIPXZ4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 19:25:56 -0400
Date: Fri, 16 Sep 2016 19:25:53 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Post ext3 conversion problems
Message-ID: <20160916232552.GA18014@coach.home>
References: <20160916192459.GA13514@coach.home>
 <CAJCQCtQutt6r2Jovr0jEbTk4W6HUaQpbGiipen97TH1C+k055g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQutt6r2Jovr0jEbTk4W6HUaQpbGiipen97TH1C+k055g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2016 at 02:23:44PM -0600, Chris Murphy wrote:
> Not a mess, I think it's a good bug report. I think Qu and David know
> more about the latest iteration of the convert code. If you can wait
> until next week at least to see if they have questions that'd be best.
> If you need to get access to the computer sooner than later I suggest
> btrfs-image -c9 -t4 -s to make a filename sanitized copy of the
> filesystem metadata for them to look at, just in case. They might be
> able to figure out the problem just from the stack trace, but better
> to have the image before blowing away the file system, just in case
> they want it.

I can hang on to the system in its current state, I don't particularly
need this machine fully operational.

Just to be proactive, I ran the btrfs-image as follows:

btrfs-image -c9 -t4 -s -w /dev/sda2 dumpfile

http://phead.us/tmp/sgreenslade_home_sanitized_2016-09-16.btrfs

In the mean time, is there any way to make the kernel more verbose about
btrfs errors? It would be nice to see, for example, what was in the
transaction that failed, or at least what files / metadata it was
touching.

--Sean

