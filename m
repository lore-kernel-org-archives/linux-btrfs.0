Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51722 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab3HBC1q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 22:27:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V555j-0001FS-Vn
	for linux-btrfs@vger.kernel.org; Fri, 02 Aug 2013 04:27:43 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Aug 2013 04:27:43 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Aug 2013 04:27:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: filefrag and btrfs filesystem defragment and maybe snapshots
Date: Fri, 2 Aug 2013 02:27:25 +0000 (UTC)
Message-ID: <pan$4a6c0$5f5b3ad0$c61266cc$feaf3eba@cox.net>
References: <CAPs0BihZNQ1fY4syh-=Pqm_ekVwd7Fw+YhGuVgz0fcO=VUZrFw@mail.gmail.
	com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sandy McArthur posted on Thu, 01 Aug 2013 17:18:50 -0400 as excerpted:

> While exploring some btrfs maintenance with respect to defragmenting I
> ran the following commands:
> 
> # filefrag /path/to/34G.file /path/to/5.7G.file
> /path/to/34G.file: 2406 extents found
> /path/to/5.7G.file: 572 extents found
> 
> Thinking those mostly static files could be less fragmented I ran:
> # btrfs filesystem defragment -c /path/to/34G.file
> # btrfs filesystem defragment -c /path/to/5.7G.file
> 
> and to my surprise the number of fragments/extends doubled:
> 
> # filefrag /path/to/34G.file /path/to/5.7G.file
> /path/to/34G.file: 6324 extents found
> /path/to/5.7G.file: 1079 extents found
> 
> Did I actually improve these files?
> 
> I do have a number rolling readonly snapshots on the subvolume these
> files are on. I can imagine how that might be related but I'm not sure.
> When the pre-defrag snapshots are purged will the filefrag extents count
> drop.

I can't answer the snapshot angle, but do you have btrfs compression 
turned on?  I've read that filefrag always sees btrfs compressed files of 
sufficient size as fragmented, due to the way btrfs compression works.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

