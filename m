From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [RFC PATCH 2/4 v2] Btrfs: avoid transaction stuff when readonly
Date: Wed, 1 Dec 2010 21:41:47 -0800
Message-ID: <AANLkTi=WE5FO6YiW18O9_sVUyhHmQQCjdKEzCSFrMaZh@mail.gmail.com>
References: <4CF62169.8000702@cn.fujitsu.com>
	<4CF7158C.30801@cn.fujitsu.com>
	<AANLkTi=2j4MEJ0s3Ot6+gFP=g3TWVdEsFmhwPKvpTRo-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>
To: "Yan, Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=2j4MEJ0s3Ot6+gFP=g3TWVdEsFmhwPKvpTRo-@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 1, 2010 at 8:28 PM, Yan, Zheng <yanzheng@21cn.com> wrote:
> On Thu, Dec 2, 2010 at 11:42 AM, liubo <liubo2009@cn.fujitsu.com> wrote:
>> On 12/01/2010 06:20 PM, liubo wrote:
>>> When the filesystem is readonly, avoid transaction stuff by checking MS_RDONLY at
>>> start transaction time.
>>>
>>
>> This patch may lead btrfs panic.
>>
>> Since btrfs allows transaction under readonly fs state, which is a bit weird, btrfs
>> does not even check the returned transaction from start_transaction, although it may
>> return -ENOMEM.
>
> btrfs may do log replay even mount as readonly.
>

What part is logged besides tree roots and/or superblocks?
