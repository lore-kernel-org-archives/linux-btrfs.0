Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:44415 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757750AbaLLBbP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 20:31:15 -0500
Message-ID: <548A4560.9010105@pobox.com>
Date: Thu, 11 Dec 2014 17:31:12 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: russell@coker.com.au
CC: "sys.syphus" <syssyphus@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Balance & scrub & defrag
References: <CAAe=sHWSR=G0+hJCbLCQfgBB_b9VQxu2Q8JETMuRgz79fcBUbg@mail.gmail.com> <5488F0A8.7070503@pobox.com> <44336672.dmUL7ANCyf@russell.coker.com.au>
In-Reply-To: <44336672.dmUL7ANCyf@russell.coker.com.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/2014 05:00 PM, Russell Coker wrote:
> On Wed, 10 Dec 2014 17:17:28 Robert White wrote:
>> A _monthly_ scrub is maybe worth scheduling if you have a lot of churn
>> in your disk contents.
>
> I do weekly scrubs.  I recently had 2 disks in a RAID-1 array develop read
> errors within a month of each other.  The first scrub after replacing sdb
> revealed an error on sdc!

You need to buy better disks. 8-)

I use SMART (smartmontools etc) and its tests to keep track of and warn 
me of such issues. It's way more likely to catch incipient media 
failures long before scrub would. It's also more likely to correct 
situations before they become visible to userspace. Its also a way 
better full-platter scan that involves less real time delay and won't 
bog down a running system.

I reserve scrub for after maintenance and the occasional look-see.

But whatever works for you.

>
> The problem with running out of metadata space requires a need for an
> occasional data balance.  If you set it to only balance chunks that are less
> than 10% used then it doesn't take much time.

In very recent kernels the empty extent remover will take up most of 
this burden.

A shallow balance is fast, but you are missing most of its potential 
benefits at that point. I wash my clothes instead of just taking a lint 
brush to them. Half measures, repeated, lead to more and more fractional 
results.

Every time you sweep a 10% full extent into a another extent far, far 
away you are perturbing your locality and probably shaving a little off 
of probable peak performance. It's the equivalent of organizing your 
sock drawer by just taking all the socks out of the dryer in a lump and 
cramming them into the back of the drawer. That is you are moving the 
most-changed items back to pack them against the least-changed ones. The 
natural lay of the filesystem is to spread out and churn. Repeatedly 
smashing it down is just going to wrinkle your data.

If you are getting anywhere near running out of metadata extents on any 
kind of regular basis then you need to reexamine your entire deal. Make 
sure you are running a recent kernel with the reclaim update. Do a full 
balance _once_ and then leave it alone. Maybe consider autodefrag if 
your file load is compatible (not a lot of VMs and RDBMS extents).

Of course if this is your pirate warez machine and you are regularly 
passing torrents through it, then you just need more space and better 
delete discipline.

