From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: stalls with latest btrfs merge into 3.0-rc2
Date: Tue, 14 Jun 2011 09:13:31 -0600
Message-ID: <4DF77A9B.9050901@sandia.gov>
References: <4DF67C06.4000307@sandia.gov> <4DF6B301.90904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Cc: linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
To: "Josef Bacik" <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4DF6B301.90904@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> On 06/13/2011 05:07 PM, Jim Schutt wrote:
>> Hi,
>>
>> On a system under a heavy write load from multiple ceph OSDs,
>> I'm running into the following hung tasks where btrfs is implicated.
>> I'm running commit 3c25fa740e2 from Linus' tree merged with
>> commit cb9b41c92fa from git://ceph.newdream.net/git/ceph-client.git.
>>
> 
> Please try this patch and verify it fixes the problem.  If it does I'll 
> make it less crappy and send it along.  Thanks,

I saw no stalls with your patch applied after 30 minutes of writing,
whereas without it the stalls would trigger after a few minutes.

Let me know if you get a new version you'd like me to test, otherwise

Tested-by: Jim Schutt <jaschut@sandia.gov>

Thanks -- Jim

> 
> Josef
> 


