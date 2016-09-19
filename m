Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:44928 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbcISPNo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 11:13:44 -0400
Date: Mon, 19 Sep 2016 11:13:41 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Post ext3 conversion problems
Message-ID: <20160919151341.GA1431@coach.home>
References: <20160916192459.GA13514@coach.home>
 <CAJCQCtQutt6r2Jovr0jEbTk4W6HUaQpbGiipen97TH1C+k055g@mail.gmail.com>
 <17ca9019-836b-f4f1-f84c-f8c1edcd9925@cn.fujitsu.com>
 <20160919041247.GA32208@coach.home>
 <ae8fd0d5-0d38-aa8e-0114-36ef62b1a783@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ae8fd0d5-0d38-aa8e-0114-36ef62b1a783@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2016 at 02:30:28PM +0800, Qu Wenruo wrote:
> All chunks are completed convert to DUP, no small chunk, all to its maximum
> chunk size.
> So from chunk level, nothing related to convert yet.
> 
> But for extent tree, I found several extents are heavily referred to.
> Like extent 158173081600 or 183996522496.
> 
> If you're not using off-band dedupe, then it's quite possible that's the
> remaining structure of convert.

I never ran any sort of dedup on this partition.

> Not pretty sure if it's related to the bug, but did you do the
> balance/defrag operation just after removing ext_save subvolume?

That's quite possible. I did it in a live boot, so I don't have the bash
history to check. I checked it just now using "btrfs subvol list -d",
and there's nothing listed. I ran a full balance after that, but the
problem remains. So whatever the problem is, it can survive a full
balance after the ext_save subvol is completely deleted.

--Sean
