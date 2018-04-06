Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58315 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751445AbeDFXoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 19:44:12 -0400
Subject: Re: Bad magic on superblock on /dev/sda at 65536
To: dsterba@suse.cz, Ben Parsons <9parsonsb@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
 <20180406170329.GH8557@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1401c2e5-d0e9-ac9e-178f-776cb9847ffb@gmx.com>
Date: Sat, 7 Apr 2018 07:44:01 +0800
MIME-Version: 1.0
In-Reply-To: <20180406170329.GH8557@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月07日 01:03, David Sterba wrote:
> On Fri, Apr 06, 2018 at 11:32:34PM +1000, Ben Parsons wrote:
>> Hi,
>>
>> I just had an unexpected restart and now my btrfs pool wont mount.
>> The error on mount is:
>>
>>     "ERROR: unsupported checksum algorithm 41700"
>>
>> and when running
>>
>>     btrfs inspect-internal dump-super /dev/sda
>>     ERROR: bad magic on superblock on /dev/sda at 65536
>>
>> I saw a thread in the mailing list about it:
>> https://www.spinics.net/lists/linux-btrfs/msg75326.html
>> However I am told on IRC that Qu fixed it using magic.
>>
>> Any help would be much appreciated.
> 
> In the previous report, there were 2 isolated areas of superblock
> damaged. Please post output of
> 
> 	btrfs inspect dump-super /path

And don't forget -Ffa option.
-F to force btrfs-progs to recognize it as btrfs no matter what the magic is
-f shows all data so we could find all corruption and fix them if possible
-a shows all backup superblocks, and if some backup is good, "btrfs
rescue super-recovery" mentioned by Nikolay would be the best solution.

Despite that, any extra info on how this happened is also appreciated,
as similar problem happened twice, which means we need to pay attention
on this.

Thanks,
Qu

Thanks,
Qu

> 
> so we can see if it's a similar issue.
> 
> In case it is, there's a tool in the btrfs-progs repo that can fix the
> individual values.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
