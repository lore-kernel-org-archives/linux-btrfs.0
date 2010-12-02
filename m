From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [RFC PATCH 2/4 v2] Btrfs: avoid transaction stuff when readonly
Date: Thu, 2 Dec 2010 12:28:07 +0800
Message-ID: <AANLkTi=2j4MEJ0s3Ot6+gFP=g3TWVdEsFmhwPKvpTRo-@mail.gmail.com>
References: <4CF62169.8000702@cn.fujitsu.com>
	<4CF7158C.30801@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF7158C.30801@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 2, 2010 at 11:42 AM, liubo <liubo2009@cn.fujitsu.com> wrote:
> On 12/01/2010 06:20 PM, liubo wrote:
>> When the filesystem is readonly, avoid transaction stuff by checking MS_RDONLY at
>> start transaction time.
>>
>
> This patch may lead btrfs panic.
>
> Since btrfs allows transaction under readonly fs state, which is a bit weird, btrfs
> does not even check the returned transaction from start_transaction, although it may
> return -ENOMEM.

btrfs may do log replay even mount as readonly.
