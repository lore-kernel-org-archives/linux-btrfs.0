Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30392 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbdJPDbD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Oct 2017 23:31:03 -0400
Subject: Re: [PATCH v2 3/3] btrfs-progs: device: add remove missing-all
To: linux-btrfs@vger.kernel.org
References: <bb58e829-77d4-1bd1-4021-2db996809a6e@jp.fujitsu.com>
 <be3e6086-5a2f-77d0-5dbc-dcb5a1a57815@jp.fujitsu.com>
 <pan$48dd8$f51614da$34e59787$eb10b745@cox.net>
Cc: Duncan <1i5t5.duncan@cox.net>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d311a713-a663-a11d-7cdb-bb9d359c4ba5@oracle.com>
Date: Mon, 16 Oct 2017 11:30:52 +0800
MIME-Version: 1.0
In-Reply-To: <pan$48dd8$f51614da$34e59787$eb10b745@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/13/2017 01:27 PM, Duncan wrote:
> Misono, Tomohiro posted on Wed, 11 Oct 2017 11:18:50 +0900 as excerpted:
> 
>> Add 'btrfs remove missing-all' to remove all the missing devices at once
>> for improving usability.
>>
>> Example:
>>   sudo mkfs.btrfs -f -d raid1 /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4
>>   sudo wipefs -a /dev/sdb1 /dev/sdb3
>>   sudo mount -o degraded /dev/sdb2 /mnt <-- 


   I agree with Duncan here. This step itself will fail even with RO
   option. Do you have any patch that is not in the ML which will
   make this step a success in the first place ?

Thanks, Anand


>>   sudo btrfs filesystem show /mnt
>>   sudo btrfs device remove missing-all /mnt
>>   sudo btrfs filesystem show /mnt
> 
> 
> There's a reason remove missing-all hasn't yet been implemented.
> 
> Note that the above would be very unlikely to work once a filesystem has
> been used in any significant way, because raid1 and raid10 are explicitly
> chunk pairs, *NOT* duplicated N times across N devices.  So with two
> devices missing, chances are that both copies of some chunks will be
> missing as well, so the filesystem would no longer be mountable degraded-
> writable, only degraded-readonly, in which case device remove won't work
> at all because the filesystem is readonly.
> 
> In fact, until the recent per-chunk check patches went in, it was
> impossible to mount-writable a raid1 missing two devices at all, because
> the safeguards simply assumed some chunks would be entirely missing.
> 
> The only case in which more than a single device missing is likely to be
> mountable degraded-writable (so device remove will work at all) is raid6,
> tho with recent patches there's narrow cases in which it /might/ be
> doable with raid1 as well.
> 
> Now you may still wish to implement remove missing-all for raid6 mode and
> for the unusual corner-case raid1/raid10 in which it might work, but the
> documentation should be pretty clear that save for raid6 it can't be
> expected to work in most cases.
> 
> Given that, I think remove missing-all hasn't been implemented as it
> simply hasn't been considered to be worth the bother for the narrow use-
> cases in which it will actually work.
> 
