From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: btrfsck segmentation fault + trace
Date: Thu, 17 Jun 2010 07:36:45 +0800
Message-ID: <AANLkTimytyLANT6s-VWToEcH7_OjfAELfFdiNUNqXWQ_@mail.gmail.com>
References: <4C18F348.80509@gmx.de>
	<20100616163109.GX27466@think>
	<4C18FD4D.4070100@gmx.de>
	<20100616172900.GA27466@think>
	<4C193329.1000500@gmx.de>
	<AANLkTil8fnhT-ViGRV7BIyLIiKXyAjmayTeAiBWqn1Jc@mail.gmail.com>
	<4C195DAE.6070503@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: John Wyzer <john.wyzer@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C195DAE.6070503@gmx.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 17, 2010 at 7:26 AM, John Wyzer <john.wyzer@gmx.de> wrote:
> On 17/06/10 00:45, Yan, Zheng wrote:
>> On Thu, Jun 17, 2010 at 4:25 AM, John Wyzer <john.wyzer@gmx.de> wrot=
e:
>>> btrfs: fail to dirty =A0inode 6634 error -28
>>> [...] (nothing new coming, only error -28)
>>>
>>> Apart from that, I had messages that there was no space left on /, =
but
>>> those were from userspace and not logged via netconsole.
>>>
>>
>> looks like the fs runs out of metadata space. btrfs in 2.6.35 reserv=
es
>> more metadata space for system use than btrfs in 2.6.34. That's why
>> these error message only appear on 2.6.35.
>
> Hmm. I've formatted with -m single because I wanted to avoid running =
out
> of space for metadata. So if there's more then 10% of space left whic=
h
> is about 40GB that seems like quite a bit of waste... ;-)
>
> I'll stay with 2.6.34 then for the time being.
>

Spaces for data and metadata are separated even the FS was formatted
with -m single.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
