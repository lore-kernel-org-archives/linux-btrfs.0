Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:53830 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752901AbcKROhU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 09:37:20 -0500
Subject: Re: Btrfs Heatmap - v2 - block group internals!
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
 <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
 <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
 <68eecdb7-90e4-a5ba-ca63-f714faf88ede@mendix.com>
 <c067cd99-31ba-9e33-6da6-1d55c1a8c8f5@gmail.com>
 <0b5c943f-4f4b-3844-22d5-6e0f8dc5eb6e@mendix.com>
 <eee07943-1bf6-fd87-abb2-23cf48ccab01@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <615cb35c-7700-abe2-edec-6c7041688ddc@mendix.com>
Date: Fri, 18 Nov 2016 15:37:05 +0100
MIME-Version: 1.0
In-Reply-To: <eee07943-1bf6-fd87-abb2-23cf48ccab01@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ha,

On 11/18/2016 01:36 PM, Austin S. Hemmelgarn wrote:
> On 2016-11-17 16:08, Hans van Kranenburg wrote:
>> On 11/17/2016 08:27 PM, Austin S. Hemmelgarn wrote:
>>> On 2016-11-17 13:51, Hans van Kranenburg wrote:
>> But, the fun with visualizations of data is that you learn whether they
>> just work(tm) or don't as soon as you see them. Mathematical or
>> algorithmic beauty is not always a good recipe for beauty as seen by the
>> human eye.
>>
>> So, let's gather a bunch of ideas which we can try out and then observe
>> the result.
>>
>> Before doing so, I'm going to restructure the code a bit more so I can
>> write another script in the same directory, just doing import heatmap
>> and calling a few functions in there to quickly try stuff, bypassing the
>> normal cli api.
>>
>> Also, the png writing handling is now done by some random png library
>> that I found, which requires me to build (or copy/resize) an entire
>> pixel grid in memory, explicitely listing all pixel values, which is a
>> bit of a memory hog for bigger pictures, so I want to see if something
>> can be done there also.
> I haven't had a chance to look at the code yet, but do you have an
> option to control how much data a pixel represents?  On a multi TB
> filesystem for example, you may not care about exact data, just an
> overall view of the data, in which case making each pixel represent a
> larger chunk of data (and thus reducing the resolution of the image)
> would almost certainly save some memory on big filesystems.

--order, which defines the hilbert curve order.

Example: for a 238GiB filesystem, when specifying --order 7, then 2**7 =
128, so 128x128 = 16384 pixels, which means that a single one represents
~16MiB

when --size > --order, the image simply gets scaled up.

When not specifying --order, a number gets chosen automatically with
which bytes per pixel is closest to 32MiB.

When size is not specified, it's 10, or same as order if order is
greater than 10.

Now this output should make sense:

-# ./heatmap.py /mnt/238GiB
max_id 1 num_devices 1 fsid ed108358-c746-4e76-a071-3820d423a99d
nodesize 16384 sectorsize 4096 clone_alignment 4096
scope filesystem curve hilbert order 7 size 10 pngfile
fsid_ed10a358-c846-4e76-a071-3821d423a99d_at_1479473532.png
grid height 128 width 128 total_bytes 255057723392 bytes_per_pixel
15567488.0 pixels 16384

-# ./heatmap.py /mnt/40TiB
max_id 2 num_devices 2 fsid 9bc9947e-070f-4bbc-872e-49b2a39b3f7b
nodesize 16384 sectorsize 4096 clone_alignment 4096
scope filesystem curve hilbert order 10 size 10 pngfile
/home/beheer/heatmap/generated/fsid_9bd9947e-070f-4cbc-8e2e-49b3a39b8f7b_at_1479473950.png
grid height 1024 width 1024 total_bytes 46165378727936 bytes_per_pixel
44026736.0 pixels 1048576

-- 
Hans van Kranenburg
