Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:60443 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752113AbdI2RFb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 13:05:31 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
 <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
 <trinity-eef9a61f-60ab-47a3-9771-d638cb0083c9-1506076766926@3c-app-mailcom-bs16>
 <9f598cb9-0267-158d-c54b-13f4372eadd5@gmail.com>
 <9652f4f4-b91c-0382-fa2a-01d45dde7fbb@gmx.com>
 <5e079410-cd64-3d40-8914-b3d48ecdebfd@gmail.com>
 <808d11d8-f22b-f26e-ba3f-7d148915db5a@gmx.com>
 <5b26f9dd-8bae-a35a-4920-4a617b52f9f7@oracle.com>
 <c0652f30-5ca7-b917-7f15-78dfdb2e1205@libero.it>
 <7af34399-f969-dfe5-d006-3e7fb293b9df@gmail.com>
 <20170927162032.GM31640@twin.jikos.cz>
 <287aaa56-f2a2-d44c-1068-ec6f87b7a2f3@gmx.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <cdd1e7c5-80c1-cd41-0e62-a1302c6682c5@inwind.it>
Date: Fri, 29 Sep 2017 18:57:18 +0200
MIME-Version: 1.0
In-Reply-To: <287aaa56-f2a2-d44c-1068-ec6f87b7a2f3@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/2017 02:00 AM, Qu Wenruo wrote:
> 
> 
> On 2017年09月28日 00:20, David Sterba wrote:
>> On Mon, Sep 25, 2017 at 07:15:30AM -0400, Austin S. Hemmelgarn wrote:
>>> On 2017-09-24 10:08, Goffredo Baroncelli wrote:
>>>> On 09/24/2017 12:10 PM, Anand Jain wrote:
>>
>> A lot of points in this thread, let me address them here.
>>
>> I don't want to remove --rootdir functionality, the fix that's being
>> proposed removes the minimalization -- feature that was not well known,
>> but I understand it's useful (and already used).
>>
>> I'd like to fix that in another way, eg. as an option to mkfs or a
>> separate tool.
>>
>> I'm not worried about adding more code or code complexity. If we do it
>> right it's not a problem in the long run. But people for some reason
>> like to delete other people's code or functionality.
>>
>> Regarding guessing number of users, this is always hard. So if there's
>> one vocal enough to let us know about the usecase, it's IMHO good time
>> to explore the it, code-wise and documentation-wise, and fix it or
>> improve.
>>
>> So, what next. I'd like to get rid of the custom chunk allocator, namely
>> because of the known 1MB area misuse and duplication.
>>
>> Implementing the minimalization might need some preparatory work and I
>> don't have a realistic ETA now.
> 
> Well, if using over-reserve-then-shrink method, it could be done, without much hassle.

What about doing it on a file instead of a device ? As sparse file, it would be less expensive to enlarge then shrink. I think that who need to build a filesystem with "shrink", doesn't need to create it on a real block device
> 
> However ETA maybe delayed to middle of Oct, as I'm going to enjoy my holiday during 1st Oct to 7th Oct.
> 
> Thanks,
> Qu
> 
>> Ideally we'd fix both problems in one
>> version, as I'd rather avoid "temporary" solution to drop the
>> minimalization with the promise to put it back later.
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
