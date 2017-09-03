Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34969 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752799AbdICBBg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Sep 2017 21:01:36 -0400
Date: Sat, 2 Sep 2017 18:01:27 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20170903010127.eafg2i7ry2tprro7@merlins.org>
References: <20170830034001.rlwaqsitco65exqi@merlins.org>
 <D6E7AD8E-AF2B-4A17-9692-FDE17F31A8D2@fb.com>
 <20170831173607.GM15290@merlins.org>
 <5320FF2E-D183-4D2A-A155-49424E1CD60F@fb.com>
 <20170901204329.GH30689@merlins.org>
 <11510543-DAC5-400B-8204-C1FCC12CF335@fb.com>
 <20170902160942.imo2hotpur3pnops@merlins.org>
 <B8F93BCF-0976-4450-A58E-13F6A3C48573@fb.com>
 <20170902235344.sb55vzaloglmqaad@merlins.org>
 <73427BC6-B85B-422C-BCA0-778C7BA203A8@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <73427BC6-B85B-422C-BCA0-778C7BA203A8@fb.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 03, 2017 at 12:30:07AM +0000, Josef Bacik wrote:
> My bad, I forgot I don't dynamically allocate the stack trace space so my patch did nothing, I blame the children for distracting me.  I've dropped allocating the action altogether for the on disk stuff, that should dramatically reduce the memory usage.  You can just do a git pull since I made a new commit.  You are mounting with -o ref_verify on only the one fs right?  Give this a try and if it still doesn't work we can try a stripped down version that doesn't build the initial tree and just hope that the problem exists in allocating a new block and not modifying the refs for an existing block.  Thanks,

Good news, this time it booted without crashing on OOM.

I'll now get to see how it runs and hopefully it won't crash due to
other problems in 4.13

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
