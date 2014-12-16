Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59522 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaLPFjH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 00:39:07 -0500
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 2C46A3EE0AE
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 14:39:06 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 2B2B1AC04E1
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 14:39:05 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id CA9DFE18001
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 14:39:04 +0900 (JST)
Message-ID: <548FC4FA.6030009@jp.fujitsu.com>
Date: Tue, 16 Dec 2014 14:36:58 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Ali AlipourR <alipoor90@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: "btrfs subvolume list" feature request
References: <CABvhJLhSTfm711Hdp6_=7xEv44ejYmbSRPgqKT6a5jNHvxEWTA@mail.gmail.com>
In-Reply-To: <CABvhJLhSTfm711Hdp6_=7xEv44ejYmbSRPgqKT6a5jNHvxEWTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Ali,

(2014/12/16 11:01), Ali AlipourR wrote:
> Hi
>
> I think it will be to add option to "btrfs subvolume list" command to
> also show the property of sub volumes (ro, compression,...)? do this
> is possible?

Of course it's possible by writing some code :-D

Is "btrfs property get <subvol>" (and some one liner) insufficient for
your purpose? If you want to just list properties of each subvolumes
instead of listing properties with existing fields, it can be
accomplished as follows.

===============================================================================
# btrfs sub list /btrfstest
# btrfs sub cre /btrfstest/sub1
Create subvolume '/btrfstest/sub1'
# btrfs sub cre /btrfstest/sub2
Create subvolume '/btrfstest/sub2'
# btrfs sub list /btrfstest/
ID 382 gen 39625 top level 5 path sub1
ID 383 gen 39626 top level 5 path sub2
# for i in $(btrfs sub list /btrfstest | cut -d ' ' -f 9) ; do echo -n $i': ' ; btrfs prop get /btrfstest/$i ; done
sub1    ro=false
sub2    ro=false
===============================================================================

Thanks,
Satoru

>
> Thanks,
> Ali
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

