From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v7 1/8] btrfs: added helper functions to iterate backrefs
Date: Wed, 27 Jul 2011 10:22:21 +0200
Message-ID: <4E2FCABD.8070705@jan-o-sch.net>
References: <cover.1311333004.git.list.btrfs@jan-o-sch.net> <c821ea4b363f4894b421a51d882c1f2b6c2eae00.1311333004.git.list.btrfs@jan-o-sch.net> <4E2FC549.90303@cn.fujitsu.com> <4E2FC712.6020603@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E2FC712.6020603@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 27.07.2011 10:06, Li Zefan wrote:
>>> +	alloc_bytes = max((unsigned long)total_bytes, sizeof(*data));
>>
>> The return type of sizeof() is unsigned int, so this will cause compile
>> warning.
>>
>> We can use max_t() instead.
>>
> 
> correct: type of sizeof is size_t (so may or may not be unsigned long)

Right, thanks. Changed for the next version.

-Jan
