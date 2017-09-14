Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45134 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751206AbdINHyp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 03:54:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dsOyp-0000l7-In
        for linux-btrfs@vger.kernel.org; Thu, 14 Sep 2017 09:54:35 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: defragmenting best practice?
Date: Thu, 14 Sep 2017 07:54:29 +0000 (UTC)
Message-ID: <pan$586a1$64c03ba5$a7b0bfe9$cf4fdc64@cox.net>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
        <20170912162843.GA32233@rus.uni-stuttgart.de>
        <1e39d1a1-db3a-1925-2bee-629987b22d3a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 12 Sep 2017 13:27:00 -0400 as
excerpted:

> The tricky part though is that differing workloads are impacted
> differently by fragmentation.  Using just four generic examples:
> 
> * Mostly sequential write focused workloads (like security recording
> systems) tend to be impacted by free space fragmentation more than data
> fragmentation.  Balancing filesystems used for such workloads is likely
> to give a noticeable improvement, but defragmenting probably won't give
> much.
> * Mostly sequential read focused workloads (like a streaming media
> server)
> tend to be the most impacted by data fragmentation, but aren't generally
> impacted by free space fragmentation.  As a result, defrag will help
> here a lot, but balance won't as much.
> * Mostly random write focused workloads (like most database systems or
> virtual machines) are often impacted by both free space and data
> fragmentation, and are a pathological case for CoW filesystems.  Balance
> and defrag will help here, but they won't help for long.
> * Mostly random read focused workloads (like most non-multimedia desktop
> usage) are not impacted much by either aspect, but if you're on a
> traditional hard drive they can be impacted significantly by how the
> data is spread across the disk.  Balance can help here, but only because
> it improves data locality, not because it compacts free space.

This is a very useful analysis, particularly given the examples.  Maybe 
put it on the wiki under the defrag discussion?  (Assuming something like 
it isn't already there.  I've not looked in awhile.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

