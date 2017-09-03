Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64977 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753036AbdICXzg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 Sep 2017 19:55:36 -0400
Subject: Re: How to disable/revoke 'compression'?
To: Adam Borowski <kilobyte@angband.pl>,
        Cloud Admin <admin@cloud.haefemeier.eu>
Cc: linux-btrfs@vger.kernel.org
References: <1504459921.8809.3.camel@cloud.haefemeier.eu>
 <20170903180636.ayrubvma7awbki6i@angband.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5e49c33f-ce4b-523d-24e6-befd379503a9@gmx.com>
Date: Mon, 4 Sep 2017 07:55:27 +0800
MIME-Version: 1.0
In-Reply-To: <20170903180636.ayrubvma7awbki6i@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月04日 02:06, Adam Borowski wrote:
> On Sun, Sep 03, 2017 at 07:32:01PM +0200, Cloud Admin wrote:
>> Hi,
>> I used the mount option 'compression' on some mounted sub volumes. How
>> can I revoke the compression? Means to delete the option and get all
>> data uncompressed on this volume.
>> Is it enough to remount the sub volume without this option? Or is it
>> necessary to do some addional step (balancing?) to get all stored data
>> uncompressed.
> 
> If you set it via mount option, removing the option is enough to disable
> compression for _new_ files.  Other ways are chattr +c and btrfs-property,
> but if you haven't heard about those you almost surely don't have such
> attributes set.
> 
> After remounting, you may uncompress existing files.  Balancing won't do
> this as it moves extents around without looking inside; defrag on the other
> hand rewrites extents thus as a side effect it applies new [non]compression
> settings.  Thus: ｢btrfs fi defrag -r /path/to/filesystem｣.
> 
>> Beside of it, is it possible to find out what the real and compressed size
>> of a file, for example or the ratio?
> 
> Currently not.
> 
> I've once written a tool which does this, but 1. it's extremely slow, 2.
> insane, 3. so insane a certain member of this list would kill me had I
> distributed the tool.  Thus, I'd need to rewrite it first...

AFAIK the only method to determine the compression ratio is to check the 
EXTENT_DATA key and its corresponding file_extent_item structure.
(Which I assume Adam is doing this way)

In that structure is records its on-disk data size and in-memory data 
size. (All rounded up to sectorsize, which is 4K in most case)
So in theory it's possible to determine the compression ratio.

The only method I can think of (maybe I forgot some methods?) is to use 
offline tool (btrfs-debug-tree) to check that.
FS APIs like fiemap doesn't even support to report on-disk data size so 
we can't use it.


But the problem is more complicated, especially when compressed CoW is 
involved.

For example, there is an extent (A) which represents the data for inode 
258, range [0,128k).
On disk size its just 4K.

And when we write the range [32K, 64K), which get CoWed and compressed, 
resulting a new file extent (B) for inode 258, range [32K, 64K), and on 
disk size is 4K as an example.

Then file extent layout for 258 will be:
[0,32k):  range [0,32K) of uncompressed Extent A
[32k, 64k): range [0,32k) of uncompressed Extent B
[64k, 128k): range [64k, 128K) of uncompressed Extent A.

And on disk extent size is 4K (compressed Extent A) + 4K (compressed 
Extent B) = 8K.

Before the write, the compresstion ratio is 4K/128K = 3.125%
While after write, the compression ratio is 8K/128K = 6.25%

Not to mention that it's possible to have uncompressed file extent.

So it's complicated even we're just using offline tool to determine the 
compression ratio of btrfs compressed file.

Thanks,
Qu

> 
> 
> Meow!
> 
