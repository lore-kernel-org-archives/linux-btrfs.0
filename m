From: John Wyzer <john.wyzer@gmx.de>
Subject: Re: btrfsck segmentation fault + trace
Date: Thu, 17 Jun 2010 01:26:38 +0200
Message-ID: <4C195DAE.6070503@gmx.de>
References: <4C18F348.80509@gmx.de>	<20100616163109.GX27466@think>	<4C18FD4D.4070100@gmx.de>	<20100616172900.GA27466@think>	<4C193329.1000500@gmx.de> <AANLkTil8fnhT-ViGRV7BIyLIiKXyAjmayTeAiBWqn1Jc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTil8fnhT-ViGRV7BIyLIiKXyAjmayTeAiBWqn1Jc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 17/06/10 00:45, Yan, Zheng wrote:
> On Thu, Jun 17, 2010 at 4:25 AM, John Wyzer <john.wyzer@gmx.de> wrote:
>> btrfs: fail to dirty  inode 6634 error -28
>> [...] (nothing new coming, only error -28)
>>
>> Apart from that, I had messages that there was no space left on /, but
>> those were from userspace and not logged via netconsole.
>>
> 
> looks like the fs runs out of metadata space. btrfs in 2.6.35 reserves
> more metadata space for system use than btrfs in 2.6.34. That's why
> these error message only appear on 2.6.35.

Hmm. I've formatted with -m single because I wanted to avoid running out
of space for metadata. So if there's more then 10% of space left which
is about 40GB that seems like quite a bit of waste... ;-)

I'll stay with 2.6.34 then for the time being.

Thanks.

