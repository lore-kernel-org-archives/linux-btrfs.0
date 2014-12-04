Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59716 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaLDEqx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Dec 2014 23:46:53 -0500
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id DF46B3EE1AB
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Dec 2014 13:46:51 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id F2404AC07C6
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Dec 2014 13:46:50 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 990E6E08008
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Dec 2014 13:46:50 +0900 (JST)
Message-ID: <547FE72E.4020007@jp.fujitsu.com>
Date: Thu, 4 Dec 2014 13:46:38 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Shriramana Sharma <samjnaa@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com> <547D663A.3020201@jp.fujitsu.com> <CAH-HCWV8upw8prPvCiJcpL2NRmuiWaAM+5ZEayD3OoEZrcsyaw@mail.gmail.com> <547E5544.7090907@jp.fujitsu.com> <20141203191240.GZ12140@twin.jikos.cz>
In-Reply-To: <20141203191240.GZ12140@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

(2014/12/04 4:12), David Sterba wrote:
> On Wed, Dec 03, 2014 at 09:11:48AM +0900, Satoru Takeuchi wrote:
>> It's not a Btrfs itself's feature. It's a snapper's feature.
>> It works as a helper of snapshot management.
>>
>> 1. You takes /snap by "snapper create" command.
>> 2. You delete /snap by "snapper delete" command by mistake.
>>      Then snapper takes a "pre" snapshot just before deleting
>>      /snap.
>> 3. Now /snap is deleted, however, a "pre" snapshot which is
>>      the same as /snap before deleting, is still alive.
>
> Can you please post exact commands how you achieve that?
>
> The 'create' subcommand may take a --type parameter, without it it
> creates 'single', and does not create pre or post snapshots
> automatically.
>

Oh, I misunderstood the concept of snapper and my explanation
was wrong. I apologize you, David and Shriramana.

I confused taking automatic pre/post snapshots at YAST and
something and on deleting snapshots. "snapper delete" doesn't
take "pre" snapshot.

Thanks,
Satoru

