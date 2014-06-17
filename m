Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:60710 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaFQXKn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 19:10:43 -0400
Message-ID: <53A0CAE6.9030805@jp.fujitsu.com>
Date: Wed, 18 Jun 2014 08:10:30 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] lib: add size unit t/p/e to memparse
References: <1402623746-1171-1-git-send-email-guihc.fnst@cn.fujitsu.com> <alpine.DEB.2.02.1406171520510.517@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406171520510.517@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gui,

(2014/06/18 7:21), David Rientjes wrote:
> On Fri, 13 Jun 2014, Gui Hecheng wrote:
>
>> For modern filesystems such as btrfs, t/p/e size level operations
>> are common.
>> add size unit t/p/e parsing to memparse
>>
>> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>
> Acked-by: David Rientjes <rientjes@google.com>

It looks good to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

>
> Sorry, didn't do this before.  Good luck with the simple_strto*() work!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

