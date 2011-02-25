From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [RFC PATCH] Btrfs: add ioctl to set compress or cow per file/dir
Date: Fri, 25 Feb 2011 11:33:35 +0800
Message-ID: <4D67230F.6070501@cn.fujitsu.com>
References: <4D6627A7.7050001@cn.fujitsu.com> <EE604399-9A36-4E16-82F5-659BA93413B5@dilger.ca> <1298572774-sup-6568@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1298572774-sup-6568@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/25/2011 02:39 AM, Chris Mason wrote:
> Excerpts from Andreas Dilger's message of 2011-02-24 13:37:52 -0500:
>> On 2011-02-24, at 2:40 AM, liubo wrote:
>>>  #define FS_DIRECTIO_FL            0x00100000 /* Use direct i/o */
>>> +#define FS_NOCOW_FL            0x00200000 /* Do not cow file */
>>> +#define FS_COW_FL            0x00100000 /* Cow file */
>>>  #define FS_RESERVED_FL            0x80000000 /* reserved for ext2 lib */
>> I'm assuming that FS_COW_FL should not be the same as FS_DIRECTIO_FL?
> 
> No, we can do DIRECTIO with COW.
> 

Sorry for my fault, thanks for pointing it out.

thanks,
liubo

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

