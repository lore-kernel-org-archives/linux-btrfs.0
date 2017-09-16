Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:54255 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751249AbdIPOhD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 10:37:03 -0400
Date: Sat, 16 Sep 2017 16:37:02 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: subvolume list as user?
Message-ID: <20170916143702.GO32347@rus.uni-stuttgart.de>
References: <20170916094504.GL32347@rus.uni-stuttgart.de>
 <684fb723-4270-9589-b80b-e60ccc6dadfe@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <684fb723-4270-9589-b80b-e60ccc6dadfe@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2017-09-16 (14:39), Hans van Kranenburg wrote:
> On 09/16/2017 11:45 AM, Ulli Horlacher wrote:
> 
> > Every user can create subvolumes (and root cannot prevent it!).
> > But how can a user list these subvolumes?
> > 
> > tux@xerus:/test/tux: btrfs subvolume create test
> > Create subvolume './test'
> 
> From your other posts I don't quickly get if you actually do want to
> have this possible, or accept that it's currently like that and try to
> do damage control by having users also remove their things again.

I want both, country AND western :-)

Without joking:
I just want to learn more about btrfs and I have various use cases to
handle.

Different use cases need different actions.


> Actually, if you don't want this I think it's quite easily to patch your
> kernel with one or two lines of code to disallow it.

Kernel patching is a no-go for me. My boss does not allow it. No
discussion possible on this topic.


> > tux@xerus:/test/tux: btrfs subvolume list .
> > ERROR: can't perform the search - Operation not permitted
> 
> Yes, because the SEARCH ioctl only allows root to directly query any of
> the filesystem metadata from kernel memory. subvolume list uses this
> SEARCH ioctl to find it's info.

This is the explantion why it does not work, but it does not help me. I
still have the problem: how can a user get a list of his subvolumes? He
may created them some time ago and forget it. He now wants to have a list
of them.

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<684fb723-4270-9589-b80b-e60ccc6dadfe@mendix.com>
