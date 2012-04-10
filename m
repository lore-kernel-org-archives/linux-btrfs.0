From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:3982!
Date: Tue, 10 Apr 2012 14:32:22 -0600
Message-ID: <4F8498D6.6050905@sandia.gov>
References: <4F848C62.6030100@sandia.gov> <20120410202440.GZ29506@shiny>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
To: "Chris Mason" <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120410202440.GZ29506@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/10/2012 02:24 PM, Chris Mason wrote:
> On Tue, Apr 10, 2012 at 01:39:14PM -0600, Jim Schutt wrote:
>> Hi,
>>
>> I hit this BUG today.
>>
>> I'm running 3.3.1 merged with the ceph and btrfs bits for 3.4,
>> i.e. 3.3.1 +
>>    commit bc3f116fec194 "Btrfs: update the checks for mixed block groups with big metadata blocks"
>>    commit c666601a935b9 "rbd: move snap_rwsem to the device, rename to header_rwsem"
>>
>> The btrfs filesystem in question is backing a Ceph OSD under
>> a heavy write load.
>>
>> Here's the bug:
>>
>> [510342.517157] ------------[ cut here ]------------
>> [510342.521855] kernel BUG at fs/btrfs/extent_io.c:3982!
>
> Could you please confirm that line number is this BUG_ON()
>
>          BUG_ON(extent_buffer_under_io(eb));

Yep, that's definitely it:

git blame fs/btrfs/extent_io.c | grep -w 3982
0b32f4bb (Josef Bacik        2012-03-13 09:38:00 -0400 3982) 	BUG_ON(extent_buffer_under_io(eb));

>
> Josef has a theory on this one, but I want to make sure we're chasing
> the right thing.

Great, thanks.  I'll be happy to test any patches, if needed.

-- Jim

>
> -chris
>


