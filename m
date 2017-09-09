Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64824 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756862AbdIIK6u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Sep 2017 06:58:50 -0400
Subject: Re: generic name for volume and subvolume root?
To: linux-btrfs@vger.kernel.org, framstag@rus.uni-stuttgart.de
References: <20170909083551.GC22060@rus.uni-stuttgart.de>
 <48008a58-a82e-d9f7-327e-eeb905e18aa1@gmx.com>
 <20170909104845.GW12642@rus.uni-stuttgart.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9911ae20-6181-5ce2-0374-e601a1034c4a@gmx.com>
Date: Sat, 9 Sep 2017 18:58:38 +0800
MIME-Version: 1.0
In-Reply-To: <20170909104845.GW12642@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月09日 18:48, Ulli Horlacher wrote:
> On Sat 2017-09-09 (18:40), Qu Wenruo wrote:
> 
>>> Is there a generic name for both volume and subvolume root?
>>
>> Nope, subvolume (including snapshot) is not distinguished by its
>> filename/path/directory name.
>>
>> And you can only do snapshot on subvolume (snapshot is one kind of
>> subvolume) boundary.
> 
> So, I can name a btrfs root volume also btrfs subvolume?

Yes, root volume is also a subvolume, so just call "btrfs root volume"
a "subvolume".

> 
> I am talking about documentation, not coding!
> 
> I just want yo use the correct terms.

If you're referring to the term, I think subvolume is good enough.
Which represents your original term, "directories one can snapshot".


For the whole btrfs "volume", I would just call it "filesystem" to avoid 
the name "volume" or "subvolume" at all.

Thanks,
Qu
