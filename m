Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38505 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740AbaLCAN6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 19:13:58 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 288A23EE1E5
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Dec 2014 09:13:57 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 1F6F8AC0685
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Dec 2014 09:13:56 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id BE060E08008
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Dec 2014 09:13:55 +0900 (JST)
Message-ID: <547E5544.7090907@jp.fujitsu.com>
Date: Wed, 3 Dec 2014 09:11:48 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com> <547D663A.3020201@jp.fujitsu.com> <CAH-HCWV8upw8prPvCiJcpL2NRmuiWaAM+5ZEayD3OoEZrcsyaw@mail.gmail.com>
In-Reply-To: <CAH-HCWV8upw8prPvCiJcpL2NRmuiWaAM+5ZEayD3OoEZrcsyaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/12/03 0:17), Shriramana Sharma wrote:
> On Tue, Dec 2, 2014 at 12:41 PM, Satoru Takeuchi
> <takeuchi_satoru@jp.fujitsu.com> wrote:
>>
>> Snapper can automatically take a snapshot just before
>> taking/deleting snapshots. So, if you delete a snapshot
>> by mistake, it's still alive.
>
> Sorta contradicts the whole point of deleting a snapshot, no? Or is it
> some sort of trash vs (real) delete mechanism?
>

It's not a Btrfs itself's feature. It's a snapper's feature.
It works as a helper of snapshot management.

1. You takes /snap by "snapper create" command.
2. You delete /snap by "snapper delete" command by mistake.
    Then snapper takes a "pre" snapshot just before deleting
    /snap.
3. Now /snap is deleted, however, a "pre" snapshot which is
    the same as /snap before deleting, is still alive.

I don't know how Btrfs itself undo the deletion of a snapshot.
It works if you manages snapshots not by btrfs directly,
but by snapper.

If I misunderstanding something, sorry for noise.

Thanks,
Satoru

