Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59649 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751212AbdIEITu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Sep 2017 04:19:50 -0400
Subject: Re: [PATCH 0/5] Mkfs: Rework --rootdir to a more generic behavior
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
 <20170904180856.GG31874@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b2299128-307f-b35f-e4c7-396d3a5d3a17@gmx.com>
Date: Tue, 5 Sep 2017 16:19:42 +0800
MIME-Version: 1.0
In-Reply-To: <20170904180856.GG31874@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月05日 02:08, David Sterba wrote:
> On Mon, Sep 04, 2017 at 03:41:05PM +0900, Qu Wenruo wrote:
>> mkfs.btrfs --rootdir provides user a method to generate btrfs with
>> pre-written content while without the need of root privilege.
>>
>> However the code is quite old and doesn't get much review or test.
>> This makes some strange behavior, from customized chunk allocation
>> (which uses the reserved 0~1M device space) to lack of special file
>> handler (Fixed in previous 2 patches).
> 
> The cleanup in this area is most welcome. The patches look good after a
> quick look, I'll do another review round.

To save you some time, I found that my rework can't create new image 
which old --rootdir can do. So it's still not completely the same behavior.
I can fix it by creating a large sparse file first and then truncate it 
using current method easily.

But this really concerns me, do we need to shrink the fs?

I had a discussion with Austin about this, thread named "[btrfs-progs] 
Bug in mkfs.btrfs -r".
The only equivalent I found is "mkfs.ext4 -d", which can only create new 
file if size is given and will not shrink fs.
(Genext2fs shrinks the fs, but is no longer in e2fsprogs)

If we follow that behavior, the 3rd and 5th patches are not needed, 
which I'm pretty happy with.

Functionally, both behavior can be implemented with current method, but 
I hope to make sure which is the designed behavior so I can stick to it.

I hope you could make the final decision on this so I can update the 
patchset.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
