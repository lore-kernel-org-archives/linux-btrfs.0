Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:52233 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751484AbdINM2r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 08:28:47 -0400
Received: by mail-it0-f49.google.com with SMTP id c195so233129itb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Sep 2017 05:28:47 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id f140sm9029297ioe.33.2017.09.14.05.28.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Sep 2017 05:28:45 -0700 (PDT)
Subject: Re: defragmenting best practice?
To: linux-btrfs@vger.kernel.org
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
 <20170912162843.GA32233@rus.uni-stuttgart.de>
 <1e39d1a1-db3a-1925-2bee-629987b22d3a@gmail.com>
 <pan$586a1$64c03ba5$a7b0bfe9$cf4fdc64@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5adfc6fb-e7d7-5d99-d5f5-b153ea690bc9@gmail.com>
Date: Thu, 14 Sep 2017 08:28:42 -0400
MIME-Version: 1.0
In-Reply-To: <pan$586a1$64c03ba5$a7b0bfe9$cf4fdc64@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-14 03:54, Duncan wrote:
> Austin S. Hemmelgarn posted on Tue, 12 Sep 2017 13:27:00 -0400 as
> excerpted:
> 
>> The tricky part though is that differing workloads are impacted
>> differently by fragmentation.  Using just four generic examples:
>>
>> * Mostly sequential write focused workloads (like security recording
>> systems) tend to be impacted by free space fragmentation more than data
>> fragmentation.  Balancing filesystems used for such workloads is likely
>> to give a noticeable improvement, but defragmenting probably won't give
>> much.
>> * Mostly sequential read focused workloads (like a streaming media
>> server)
>> tend to be the most impacted by data fragmentation, but aren't generally
>> impacted by free space fragmentation.  As a result, defrag will help
>> here a lot, but balance won't as much.
>> * Mostly random write focused workloads (like most database systems or
>> virtual machines) are often impacted by both free space and data
>> fragmentation, and are a pathological case for CoW filesystems.  Balance
>> and defrag will help here, but they won't help for long.
>> * Mostly random read focused workloads (like most non-multimedia desktop
>> usage) are not impacted much by either aspect, but if you're on a
>> traditional hard drive they can be impacted significantly by how the
>> data is spread across the disk.  Balance can help here, but only because
>> it improves data locality, not because it compacts free space.
> 
> This is a very useful analysis, particularly given the examples.  Maybe
> put it on the wiki under the defrag discussion?  (Assuming something like
> it isn't already there.  I've not looked in awhile.)
> 
I've actually been meaning to write up something more thoroughly about 
this online (probably as a Gist).  When finally get around to that 
(probably in the next few weeks), I'll try to make sure a link ends up 
on the defrag page on the wiki.
