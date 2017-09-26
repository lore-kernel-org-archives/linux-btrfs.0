Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62678 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965142AbdIZJgT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 05:36:19 -0400
Subject: Re: btrfs scrub crashes OS
To: Lukas Pirl <btrfs@lukas-pirl.de>
Cc: linux-btrfs@vger.kernel.org
References: <6e6dc9a3-b3e9-2831-8149-94f7c11b9df1@lukas-pirl.de>
 <67942154-0940-e1f3-318a-6a9a893fe351@gmx.com>
 <f01fc6f7-a0d4-dbae-b5fa-ea51842c4793@lukas-pirl.de>
 <9e86bf20-a686-4c73-22d8-1f8332409c54@gmx.com>
 <e9cfdde0-f07d-c73b-23f0-49ef55709240@lukas-pirl.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2c7db235-827c-1f17-484b-2a7f8da4810c@gmx.com>
Date: Tue, 26 Sep 2017 17:36:09 +0800
MIME-Version: 1.0
In-Reply-To: <e9cfdde0-f07d-c73b-23f0-49ef55709240@lukas-pirl.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月26日 17:26, Lukas Pirl wrote:
> Hi Qu,
> 
> On 09/26/2017 10:51 AM, Qu Wenruo wrote as excerpted:
>> This make things more weird.
>> Just in case, are you executing offline scrub by "btrfs scrub start
>> --offline <device>"
> 
> Yes. I even got some output (pretty sure the last lines are missing due
> to the crash):
> 
> WARNING: Offline scrub doesn't support extra options other than -r
> [I gave -d as well]
> Invalid mapping for 644337258496-644337332224, got
> 645348196352-646421938176
> Couldn't map the block 644337258496

This is strange, this means that we can't find a chunk map for a 72K 
length data extent.

Either the new mapper code has some bug, or it's a big problem.
But I think it's more possible for former case.

Would you please try to dump the chunk tree (which should be quite 
small) using the following command?

$ btrfs inspect-internal dump-tree -t chunk <device>

> ERROR: failed to read out data at bytenr 644337258496 mirror 1
> Invalid mapping for 653402148864-653402152960, got
> 653938130944-655011872768
> Couldn't map the block 653402148864
> ERROR: failed to read out data at bytenr 653402148864 mirror 1
> Invalid mapping for 717315420160-717315526656, got
> 718362640384-719436382208
> Couldn't map the block 717315420160
> ERROR: failed to read out data at bytenr 717315420160 mirror 1
> Invalid mapping for 875072008192-875072040960, got
> 875128946688-876202688512
> Couldn't map the block 875072008192
> ERROR: failed to read tree block 875072008192 mirror 1
> ERROR: extent 875072008192 len 32768 CORRUPTED: all mirror(s)
> corrupted, can't be recovered
> 
> Can I find out on which disk a mirror of a block is?

btrfs-map-logical can help you.
But I doubt if the offline scrub code, especially the new 
btrfs_map_block_v2() has hidden bug which caused the problem.

Withouth chunk tree dump, I am not which if it's a real bug or missing 
device.

Thanks,
Qu
> 
>> If so, I think there may be some problem outside the btrfs territory.
> 
> Of course, that is a possibility…
> 
>> Offline scrub has nothing to do with btrfs kernel module, it just reads
>> out on-disk data and verify checksum in *user* space.
>>
>> So if offline scrub can also screw up the system, it means there is
>> something wrong in the disk IO routine, not btrfs.
>>
>> And scrub can trigger it because normal btrfs IO won't try to read that
>> part/mirror.
> 
> …especially when considering this.
> 
>> What about trying to read all data out of your raw disk?
>> If offline crashes the system, reading the disk may crash it also.
>> Using dd to read each of your disk (with btrfs unmounted) may expose
>> which disk caused the problem.
> 
> That it is good idea! Will go ahead.
> 
> Thanks for your help so far.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
