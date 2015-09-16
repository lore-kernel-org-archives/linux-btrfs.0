Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34265 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbbIPQZX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 12:25:23 -0400
Received: by padhy16 with SMTP id hy16so213501125pad.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 09:25:22 -0700 (PDT)
Received: from [172.16.0.11] (60-241-125-152.static.tpgi.com.au. [60.241.125.152])
        by smtp.googlemail.com with ESMTPSA id df2sm28844909pad.19.2015.09.16.09.25.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2015 09:25:22 -0700 (PDT)
Subject: Re: FYIO: A rant about btrfs
To: linux-btrfs@vger.kernel.org
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com>
From: Zia Nayamuth <zedestructor@gmail.com>
Message-ID: <55F997E9.8040401@gmail.com>
Date: Thu, 17 Sep 2015 02:25:13 +1000
MIME-Version: 1.0
In-Reply-To: <55F988A6.8070109@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some response to your criticism:

1. How would that hole fare with a fully battery-backed/flash-backed 
path (battery-backed or flash-backed HBA with disks with full power-loss 
protection, like the Intel S3500)? In such a situation (quite 
commonplace in server-land), power-loss should not cause any data loss 
since all data in the cache is guaranteed to be committed to 
non-volatile memory at some point (whether such assurances may be 
trusted is another matter entirely though, and well outside the scope of 
this discussion).

2. Fair point. I'd like to know his hardware, given how strongly 
hardware can influence things.

3. It's pretty obvious that the author of that blog is specifically 
targeting OLTP performance (explicit statement in intro, choice of 
benchmark, name and focus of blog), not common-case, and even states 
that in the first two paragraphs of his conclusion. The focus is 
somewhat less clear in said conclusion, namely, is he truly talking 
about general purpose use or is he talking about general purpose OLTP use?

-- 
Zia Nayamuth

On 17/09/2015 01:20, Austin S Hemmelgarn wrote:
> On 2015-09-16 10:43, M G Berberich wrote:
>> Hello,
>>
>> just for information. I stumbled about a rant about btrfs-performance:
>>
>> http://blog.pgaddict.com/posts/friends-dont-let-friends-use-btrfs-for-oltp
>>
>>     MfG
>>     bmg
>>
> It is worth noting a few things that were done incorrectly in this 
> testing:
> 1. _NEVER_ turn off write barriers (nobarrier mount option), doing so 
> subtly breaks the data integrity guarantees of _ALL_ filesystems, but 
> especially so on COW filesystems like BTRFS. With this off, you will 
> have a much higher chance that a power loss will cause data loss.  It 
> shouldn't be turned off unless you are also turning off write-caching 
> in the hardware or know for certain that no write-reordering is done 
> by the hardware (and almost all modern hardware does write-reordering 
> for performance reasons).
> 2. He provides no comparison of any other filesystem with TRIM support 
> turned on (it is very likely that all filesystems will demonstrate 
> such performance drops.  Based on that graph, it looks like the device 
> doesn't support asynchronous trim commands).
> 3. He's testing it for a workload is a known and documented problem 
> for BTRFS, and claiming that that means that it isn't worth 
> considering as a general usage filesystem.  Most people don't run 
> RDBMS servers on their systems, and as such, such a workload is not 
> worth considering for most people.
>
> His points about the degree of performance jitter are valid however, 
> as are the complaints of apparent CPU intensive stalls in the BTRFS 
> code, and I occasionally see both on my own systems.
>

