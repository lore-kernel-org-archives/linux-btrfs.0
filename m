Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:51798 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbeHNK1h (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 14 Aug 2018 06:27:37 -0400
Subject: Re: [RFC PATCH 00/17] btrfs zoned block device support
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, dsterba@suse.cz,
        Naohiro Aota <naota@elisp.net>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>
References: <20180809180450.5091-1-naota@elisp.net>
 <20180813184251.GC24025@twin.jikos.cz>
 <86bddb14-104e-182b-29a1-6ab8150f09a8@suse.com>
 <057b6600-0fef-4067-54ca-216b591d43f8@gmail.com>
From: Hannes Reinecke <hare@suse.com>
Message-ID: <9531d57f-2271-7eb8-b734-dac6d33f0ec1@suse.com>
Date: Tue, 14 Aug 2018 09:41:36 +0200
MIME-Version: 1.0
In-Reply-To: <057b6600-0fef-4067-54ca-216b591d43f8@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/13/2018 09:29 PM, Austin S. Hemmelgarn wrote:
> On 2018-08-13 15:20, Hannes Reinecke wrote:
>> On 08/13/2018 08:42 PM, David Sterba wrote:
>>> On Fri, Aug 10, 2018 at 03:04:33AM +0900, Naohiro Aota wrote:
>>>> This series adds zoned block device support to btrfs.
>>>
>>> Yay, thanks!
>>>
[ .. ]
>>> Device replace is disabled, but the changlog suggests there's a way to
>>> make it work, so it's a matter of implementation. And this should be
>>> implemented at the time of merge.
>>>
>> How would a device replace work in general?
>> While I do understand that device replace is possible with RAID
>> thingies, I somewhat fail to see how could do a device replacement
>> without RAID functionality.
>> Is it even possible?
>> If so, how would it be different from a simple umount?
> Device replace is implemented in largely the same manner as most other
> live data migration tools (for example, LVM2's pvmove command).
> 
> In short, when you issue a replace command for a given device, all
> writes that would go to that device are instead sent to the new device.
> While this is happening, old data is copied over from the old device to
> the new one.  Once all the data is copied, the old device is released
> (and it's BTRFS signature wiped), and the new device has it's device ID
> updated to that of the old device.
> 
> This is possible largely because of the COW infrastructure, but it's
> implemented in a way that doesn't entirely depend on it (otherwise it
> wouldn't work for NOCOW files).
> 
> Handling this on zoned devices is not likely to be easy though, you
> would functionally have to freeze I/O that would hit the device being
> replaced so that you don't accidentally write to a sequential zone out
> of order.

Ah. Oh. Hmm.

It would be possible in principle if we freeze accesses to any partially
filled zones on the original device. Then all new writes will be going
into new/empty zones on the new disks, and we can copy over the old data
with no issue at all.
We end up with some partially filled zones on the new disk, but they
really should be cleaned up eventually either by the allocator filling
up the partially filled zones or once garbage collection clears out
stale zones.

However, I fear the required changes to the btrfs allocator are beyond
my btrfs knowledge :-(

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
