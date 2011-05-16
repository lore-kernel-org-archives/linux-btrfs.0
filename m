From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs warnings from 2.6.39-rc5
Date: Mon, 16 May 2011 10:56:15 -0400
Message-ID: <4DD13B0F.2000403@redhat.com>
References: <4DB863B4.3070900@sandia.gov> <4DC016C1.2070505@redhat.com> <4DD134A9.8010008@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
To: Jim Schutt <jaschut@sandia.gov>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DD134A9.8010008@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/16/2011 10:28 AM, Jim Schutt wrote:
> Josef Bacik wrote:
>> On 04/27/2011 02:43 PM, Jim Schutt wrote:
>>> Hi,
>>>
>>> I'm not sure if they matter, but I got these warnings on
>>> one of the machines I'm using as a Ceph OSD server:
>>>
>>> [ 1806.549469] ------------[ cut here ]------------
>>> [ 1806.554593] WARNING: at fs/btrfs/extent-tree.c:5790
>>> use_block_rsv+0xa7/0x101 [btrfs]()
>
>>> Please let me know if I can do anything to help sort these out.
>>>
>>
>> I just posted a patch for this problem, it's titled
>>
>> Btrfs: fix how we do space reservation for truncate
>>
>> Please apply it and test it and see if it makes this problem go away.
>
> This patch has been working very well for me, thanks.
> I've had no sign of truncate trouble since I started using it.
>
> -- Jim
>

Fantastic, thank you for testing.

Josef
