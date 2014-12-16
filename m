Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37779 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaLPJZv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 04:25:51 -0500
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id D01ED3EE1C1
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 18:25:49 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id B8E11AC040E
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 18:25:48 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 64227E08001
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 18:25:48 +0900 (JST)
Message-ID: <548FFA95.1070307@jp.fujitsu.com>
Date: Tue, 16 Dec 2014 18:25:41 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: "btrfs subvolume list" feature request
References: <CABvhJLhSTfm711Hdp6_=7xEv44ejYmbSRPgqKT6a5jNHvxEWTA@mail.gmail.com>	<548FC4FA.6030009@jp.fujitsu.com> <CAJCQCtQ-+gkTVfV+ghVm_1sLRi3aQLpKZpD+eAdU_20p399OfQ@mail.gmail.com>
In-Reply-To: <CAJCQCtQ-+gkTVfV+ghVm_1sLRi3aQLpKZpD+eAdU_20p399OfQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

(2014/12/16 16:52), Chris Murphy wrote:
> On Mon, Dec 15, 2014 at 10:36 PM, Satoru Takeuchi
> <takeuchi_satoru@jp.fujitsu.com> wrote:
>
>> Is "btrfs property get <subvol>" (and some one liner) insufficient for
>> your purpose?
>
> I was not previously aware of btrfs property, thanks for mentioning
> this. man btrfs does not list the property command; although man btrfs
> property does explain it. So now I'm wondering what other commands
> might not be listed in man btrfs.

I dug into it and found that only btrfs-property is
missing subcommand, at least in devel/integration-20141204
branch.

I'll submit a patch which fixes this problem later.

Thanks,
Satoru

