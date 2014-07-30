Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33277 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaG3C65 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 22:58:57 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 0E2153EE0BD
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:58:54 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 1239AAC06AB
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:58:53 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id B1EB91DB8037
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:58:52 +0900 (JST)
Message-ID: <53D85F5D.40301@jp.fujitsu.com>
Date: Wed, 30 Jul 2014 11:58:37 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: introduce test_issubvolname() for simplicity
References: <53D1F65A.7030606@jp.fujitsu.com> <20140729133208.GS1553@twin.jikos.cz>
In-Reply-To: <20140729133208.GS1553@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

(2014/07/29 22:32), David Sterba wrote:
> On Fri, Jul 25, 2014 at 03:16:58PM +0900, Satoru Takeuchi wrote:
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> There are many duplicated codes to check if the given string is
>> correct subvolume name. Introduce test_issubvolname() for this
>> purpose for simplicity.
>
> Please move it to utils.c

OK, I'll do. In addition, how about moving test_isdir() and
test_issubvolume() to utils.c too? These are also utility functions.

Thanks,
Satoru

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

