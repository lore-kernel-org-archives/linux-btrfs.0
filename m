Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36701 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751801AbcBOARp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 19:17:45 -0500
Subject: Re: btrfs-image failure (btrfs-tools 4.4)
To: Marc MERLIN <marc@merlins.org>
References: <20160123170354.GA10113@merlins.org>
 <56A57C59.1040203@cn.fujitsu.com> <20160125205500.GK23751@merlins.org>
 <56A6C5CB.5060406@cn.fujitsu.com> <20160211063132.GX13969@merlins.org>
 <56BC355F.1080305@cn.fujitsu.com> <20160211150947.GY13969@merlins.org>
 <20160211151339.GZ13969@merlins.org> <56BD2847.8070403@cn.fujitsu.com>
 <20160212172628.GJ2763@merlins.org> <20160214172659.GD4115@merlins.org>
CC: David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56C1191C.7030309@cn.fujitsu.com>
Date: Mon, 15 Feb 2016 08:17:32 +0800
MIME-Version: 1.0
In-Reply-To: <20160214172659.GD4115@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Marc MERLIN wrote on 2016/02/14 09:26 -0800:
> On Fri, Feb 12, 2016 at 09:26:28AM -0800, Marc MERLIN wrote:
>> On Fri, Feb 12, 2016 at 08:33:11AM +0800, Qu Wenruo wrote:
>>> There is still a last chance.
>>>
>>> If btrfsck still report original error about "bad file extent" in root:
>>>   45851/45852/...
>>> Btrfs-debug-tree may provide useful info by dumping only that root.
>>>
>>> # btrfs-debug-tree -t 45851
>>>
>>> But the problem is, there is no filename fuzz option.
>>> You need to mask all the filenames in INODE_REF/DIR_ITEM/DIR_INDEX by
>>> script, or just grep the affected inode info following the pattern "key
>>> (<INODE_NUM>".
>>>
>>> At least this should tell us what's the problem and we can check
>>> manually to determine if it's fixable.
>>
>> Mmmh, so the fsck is looking a bit worse now, here is the output:
>> http://marc.merlins.org/tmp/ggm-broken-ds1-fsck.txt
>>
>> I'm not super sure what inode I should use for debug tree. Can you suggest
>> one?
>>
>> I ran the dump
>> gargamel:~# btrfs-image -s -c 9 /dev/mapper/dshelf1old
>> /mnt/dshelf1/ds1old.dump
>> Error adding space cache blocks -5
>> Error flushing pending -5
>> create failed (Success)
>>
>> and a du every so often showed the file go to 9.3GB before btrfs-image
>> deleted it:
>> 9.3G    /mnt/dshelf1/ds1old.dump
>
> So I'm at a point where I need to delete this filesystem. I believe it'll be
> monday morning soon on your side of the world :)
> Can you let me know if there is anything else I can/should get before I wipe
> it?
>
> Thanks,
> Marc
>
Sorry for the late reply.

According to the output of your btrfsck --repair output, things just get 
worse.

So at this point, it's harder to locate the original problem. (Csum 
missing with bad file extents)

IMHO you can wipe the fs now.

Thanks,
Qu


