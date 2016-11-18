Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25337 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752037AbcKRA6E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 19:58:04 -0500
Subject: Re: [PATCH 0/2] RAID5/6 scrub race fix
To: <kreijack@inwind.it>, <linux-btrfs@vger.kernel.org>
References: <20161115025024.25299-1-quwenruo@cn.fujitsu.com>
 <d4209447-5fb5-e947-1546-45608814c87a@libero.it>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <746c65d8-ae19-50aa-9e21-fce5bde531e2@cn.fujitsu.com>
Date: Fri, 18 Nov 2016 08:57:58 +0800
MIME-Version: 1.0
In-Reply-To: <d4209447-5fb5-e947-1546-45608814c87a@libero.it>
Content-Type: multipart/mixed;
        boundary="------------E582B608DD2AB6130F366BBF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------E582B608DD2AB6130F366BBF
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit



At 11/18/2016 02:09 AM, Goffredo Baroncelli wrote:
> Hi Qu,
>
> On 2016-11-15 03:50, Qu Wenruo wrote:
>> Fix the so-called famous RAID5/6 scrub error.
>>
>> Thanks Goffredo Baroncelli for reporting the bug, and make it into our
>> sight.
>> (Yes, without the Phoronix report on this,
>> https://www.phoronix.com/scan.php?page=news_item&px=Btrfs-RAID-56-Is-Bad,
>> I won't ever be aware of it)
>>
>> Unlike many of us(including myself) assumed, it's not a timed bomb buried
>> deeply into the RAID5/6 code, but a race condition in scrub recovery
>> code.
>>
>> The problem is not found because normal mirror based profiles aren't
>> affected by the race, since they are independent with each other.
>
> Unfortunately, even with these patches btrfs still fails to rebuild a raid5 array in my tests.
> To perform the tests I create a filesystem raid5-three disks; then I created a file
>
> # python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" >out.txt
>
> The filesystem layout is composed by stripes large 128k of data, and 64k of parity.
>
> The idea is that the first third of the stripe (64k on disk0) is composed by "adaaa...";
> the second third (again 64k on disk1 is composed by "bdbbbb"; and finally the parity (disk0^disk1) is stored on the last portion of the stripe.
>
> Doing some calculation it is possible to know where the data is physically stored.
>
> I perform 3 tests:
> 1) I corrupt some bytes of the data stored on disk0; mount the filesystem; run scrub; unmount the filesystem; check all the disks if the bytes of the stripe are corrected
> 2) I corrupt some bytes of the data stored on disk1; mount the filesystem; run scrub; unmount the filesystem; check all the disks the bytes of the stripe are corrected
> 3) I corrupt some bytes of the parity stored on disk2; mount the filesystem; run scrub; unmount the filesystem; check all the disks the bytes of the stripe are corrected
>
> Before your patches, my all tests fail (not all the times, but very often).
> After your patches, test1 and test2 still fail. In my test test3 succeded.

Thanks for your report and script.

I compared my script with yours, and found the difference is, I'm 
corrupting the whole data stripe (64K, and without space cache to make 
sure all data are at the 1st full stripe), while you only corrupt 5 
bytes of it.

And in that case, btrfs won't report more error than expected 1, which 
means the race fix is working.

But new btrfs-progs scrub will report that the recovered data stripes 
are all OK, but P/Q is not correct.

This seems to be a new bug, unrelated to the RAID5/6 scrub race(whose 
main symptom is incorrect csum error number and sometimes even 
unrecoverable error).


I assume it will be easier to fix than the race, but I can be totally 
wrong unless I dig into it further.

Anyway I'll fix it in a new patchset.

Thanks,
Qu

>
> Enclosed my script which performs the tests (it uses loop device; please run in a VM; firts you have to uncomment the function make_imgs to create the disk image.).
>
> Let me know if I can help you providing more information.
>
> BR
> G.Baroncelli
>
>
>>
>> Although this time the fix doesn't affect the scrub code much, it should
>> warn us that current scrub code is really hard to maintain.
>>
>> Abuse of workquque to delay works and the full fs scrub is race prone.
>>
>> Xfstest will follow a little later, as we don't have good enough tools
>> to corrupt data stripes pinpointly.
>>
>> Qu Wenruo (2):
>>   btrfs: scrub: Introduce full stripe lock for RAID56
>>   btrfs: scrub: Fix RAID56 recovery race condition
>>
>>  fs/btrfs/ctree.h       |   4 ++
>>  fs/btrfs/extent-tree.c |   3 +
>>  fs/btrfs/scrub.c       | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 199 insertions(+)
>>
>
>



--------------E582B608DD2AB6130F366BBF
Content-Type: application/x-shellscript; name="raid56_recover.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="raid56_recover.sh"

IyEvYmluL2Jhc2gKCmRldjE9L2Rldi92ZGI2CmRldjI9L2Rldi92ZGI3CmRl
djM9L2Rldi92ZGI4Cm1udD0vbW50L3Rlc3QKCnVtb3VudCAkbW50Cm1rZnMu
YnRyZnMgJGRldjEgJGRldjIgJGRldjMgLWYgLW0gcmFpZDUgLWQgcmFpZDUK
bW91bnQgJGRldjEgJG1udCAtbyBub3NwYWNlX2NhY2hlCnhmc19pbyAtZiAt
YyAicHdyaXRlIDAgMjU2ayIgJG1udC9maWxlMQpzeW5jCnVtb3VudCAkbW50
CgpkbWVzZyAtQwojIGRlc3RvcnkgcGFyaXR5CiNkZCBpZj0vZGV2L3VyYW5k
b20gb2Y9JGRldjEgYnM9MSBjb3VudD02NGsgc2Vlaz01NjYyMzEwNDAKZGQg
aWY9L2Rldi91cmFuZG9tIG9mPSRkZXYyIGJzPTEgY291bnQ9NjRrIHNlZWs9
NTQ2MzA4MDk2CiNkZCBpZj0vZGV2L3VyYW5kb20gb2Y9JGRldjIgYnM9MSBj
b3VudD0zMmsgc2Vlaz01NDYzNDA4NjQKCiMgYnRyZnMtcHJvZ3Mgc2NydWIK
YnRyZnMgY2hlY2sgLS1zY3J1YiAkZGV2MQoKIyBzY3J1Ygptb3VudCAkZGV2
MSAkbW50IC1vIG5vc3BhY2VfY2FjaGUKYnRyZnMgc2NydWIgc3RhcnQgLUIg
JG1udAp1bW91bnQgJG1udAoKIyBidHJmcy1wcm9ncyBzY3J1YiByZWNoZWNr
CmJ0cmZzIGNoZWNrIC0tc2NydWIgJGRldjEK

--------------E582B608DD2AB6130F366BBF--
