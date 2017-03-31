Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:47140 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753430AbdCaUuJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 16:50:09 -0400
Subject: Re: [PATCH v2] btrfs: drop the nossd flag when remounting with -o ssd
To: Adam Borowski <kilobyte@angband.pl>
References: <20170331171016.GN4781@twin.jikos.cz>
 <20170331200850.7067-1-kilobyte@angband.pl>
 <ec137980-08d0-77d8-258b-29610a49a13f@mendix.com>
 <20170331204337.comndlwr5j7o5bqp@angband.pl>
Cc: David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <70b55b49-c4a8-135c-0cbc-b56315ec76ce@mendix.com>
Date: Fri, 31 Mar 2017 22:50:06 +0200
MIME-Version: 1.0
In-Reply-To: <20170331204337.comndlwr5j7o5bqp@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/31/2017 10:43 PM, Adam Borowski wrote:
> On Fri, Mar 31, 2017 at 10:24:57PM +0200, Hans van Kranenburg wrote:
>>
>> Yes, but we're not doing the same thing here.
>>
>> You have a file via a loop mount. If I do that, I get the same output as
>> you show, the right messages when I remount ssd and nossd.
>>
>> My test was lvm based on an ssd. When I mount that, I get the "detected
>> SSD devices, enabling SSD mode", and everytime I remount, being it ssd
>> or nossd, it *always* says "use ssd allocation scheme".
>>
>> So, this needs some more research I guess. It doesn't feel right.
> 
> I can't reproduce:
> 
> [~]# cat /proc/swaps
> Filename				Type		Size	Used	Priority
> /dev/sda2                               partition	8822780	0	-1
> [~]# swapoff /dev/sda2
> [~]# mkfs.btrfs -f /dev/sda2
> ...
> [ 2459.856819] BTRFS info (device sda2): detected SSD devices, enabling SSD mode
> [ 2459.857699] BTRFS info (device sda2): creating UUID tree
> [ 2477.234868] BTRFS info (device sda2): not using ssd allocation scheme
> [ 2477.234873] BTRFS info (device sda2): disk space caching is enabled
> [ 2482.306649] BTRFS info (device sda2): use ssd allocation scheme
> [ 2482.306654] BTRFS info (device sda2): disk space caching is enabled
> [ 2483.618578] BTRFS info (device sda2): not using ssd allocation scheme
> [ 2483.618583] BTRFS info (device sda2): disk space caching is enabled
> 
> Same partition on lvm:
> [ 2813.259749] BTRFS info (device dm-0): detected SSD devices, enabling SSD mode
> [ 2813.260586] BTRFS info (device dm-0): creating UUID tree
> [ 2827.131076] BTRFS info (device dm-0): not using ssd allocation scheme
> [ 2827.131081] BTRFS info (device dm-0): disk space caching is enabled
> [ 2828.618841] BTRFS info (device dm-0): use ssd allocation scheme
> [ 2828.618845] BTRFS info (device dm-0): disk space caching is enabled
> [ 2829.546796] BTRFS info (device dm-0): not using ssd allocation scheme
> [ 2829.546801] BTRFS info (device dm-0): disk space caching is enabled
> [ 2833.770787] BTRFS info (device dm-0): use ssd allocation scheme
> [ 2833.770792] BTRFS info (device dm-0): disk space caching is enabled
> 
> Seems to flip back and forth correctly for me.
> 
> Are you sure you have this patch applied?

Oh ok, that's with the patch. The output I show is without the patch.

If it does my output without the patch instead and the right output with
it applied, then the puzzle pieces are in the right place again.

-- 
Hans van Kranenburg
