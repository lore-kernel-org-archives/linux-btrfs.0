From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [RFC PATCH 2/4 v2] Btrfs: avoid transaction stuff when readonly
Date: Thu, 02 Dec 2010 13:38:50 +0800
Message-ID: <4CF730EA.9040507@cn.fujitsu.com>
References: <4CF62169.8000702@cn.fujitsu.com>	<4CF7158C.30801@cn.fujitsu.com> <AANLkTi=2j4MEJ0s3Ot6+gFP=g3TWVdEsFmhwPKvpTRo-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=2j4MEJ0s3Ot6+gFP=g3TWVdEsFmhwPKvpTRo-@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/02/2010 12:28 PM, Yan, Zheng wrote:
> On Thu, Dec 2, 2010 at 11:42 AM, liubo <liubo2009@cn.fujitsu.com> wrote:
>> On 12/01/2010 06:20 PM, liubo wrote:
>>> When the filesystem is readonly, avoid transaction stuff by checking MS_RDONLY at
>>> start transaction time.
>>>
>> This patch may lead btrfs panic.
>>
>> Since btrfs allows transaction under readonly fs state, which is a bit weird, btrfs
>> does not even check the returned transaction from start_transaction, although it may
>> return -ENOMEM.
> 
> btrfs may do log replay even mount as readonly.

Yeah, it it right.

log replay maybe does take place when btrfs is mounted as readonly, but after the FS is
broken, is btrfs willing to do log replay in such case?

thanks,
Liu Bo

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

