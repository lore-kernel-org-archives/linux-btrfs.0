From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: mount a multi-device filesystem using a loopback device
Date: Wed, 07 Sep 2011 14:42:12 +0800
Message-ID: <4E671244.6030501@oracle.com>
References: <4E66F090.4030507@oracle.com> <4E670FB8.4000705@cn.fujitsu.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E670FB8.4000705@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


On 09/07/2011 02:31 PM, Li Zefan wrote:
>> Is it a bug? or Am I missing something?
>>
> You need to run this before mounting the devices:
>
>    # btrfs device scan
Thank you, it works by executing device scan.

-Jeff
