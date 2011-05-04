From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: btrfs warnings from 2.6.39-rc5
Date: Wed, 4 May 2011 10:37:16 -0600
Message-ID: <4DC180BC.8060007@sandia.gov>
References: <4DB863B4.3070900@sandia.gov> <4DC016C1.2070505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Cc: linux-btrfs@vger.kernel.org,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
To: "Josef Bacik" <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4DC016C1.2070505@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> On 04/27/2011 02:43 PM, Jim Schutt wrote:
>> Hi,
>>
>> I'm not sure if they matter, but I got these warnings on
>> one of the machines I'm using as a Ceph OSD server:
>>
>> [ 1806.549469] ------------[ cut here ]------------
>> [ 1806.554593] WARNING: at fs/btrfs/extent-tree.c:5790
>> use_block_rsv+0xa7/0x101 [btrfs]()

[snip]

>>
>> Please let me know if I can do anything to help sort these out.
>>
> 
> I just posted a patch for this problem, it's titled
> 
>     Btrfs: fix how we do space reservation for truncate
> 
> Please apply it and test it and see if it makes this problem go away. 

Thanks for taking a look at this.  I'm running now with the
patch applied to 2.6.39-rc6.  The warning was relatively
hard to trigger for me, so it might be a while before I
can report back that it helped.

-- Jim

> Thanks,
> 
> Josef
> -- 
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


