From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1301!
Date: Wed, 22 Jun 2011 12:14:03 -0600
Message-ID: <4E0230EB.6050204@sandia.gov>
References: <4DFB7C77.6010807@sandia.gov>
 <4DFF1CFA.7060201@cn.fujitsu.com> <4DFFCA04.1000209@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org,
	"Josef Bacik" <josef@redhat.com>, ceph-devel@vger.kernel.org
To: "Jim Schutt" <jaschut@sandia.gov>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4DFFCA04.1000209@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

Jim Schutt wrote:
> Hi Miao,
> 
> Miao Xie wrote:
>> Hi, Jim
>>
>> Could you test the attached patch for me? I have done some quick 
>> tests, it worked well. But I'm not sure if it can fix
>> the bug you reported or not, so I need your help!
> 
> So far I haven't been able to reproduce with your patch
> applied.  I'd like to test for a few more days, though,
> before calling it good.
> 
> Thanks for the patch -- I'll let you know what more
> testing brings.

I've been running this patch on top of 3.0-rc4 for
the last couple days, and have been unable to reproduce
the BUG.

Thanks -- Jim

> 
> -- Jim
> 

