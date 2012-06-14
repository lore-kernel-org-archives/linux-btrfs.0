Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lulu.zabbo.net ([69.168.54.52]:45447 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab2FNQm2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 12:42:28 -0400
Message-ID: <4FDA1472.8020803@zabbo.net>
Date: Thu, 14 Jun 2012 09:42:26 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: use radix tree for checksum
References: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com> <1339582751-32029-2-git-send-email-liubo2009@cn.fujitsu.com> <4FD8BAC9.2020108@zabbo.net> <4FD9437C.3070009@cn.fujitsu.com>
In-Reply-To: <4FD9437C.3070009@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>> +    BUG_ON(ret);
>>
>> I wonder if we can patch BUG_ON() to break the build if its only
>> argument is "ret".
>>
>
> why?

Well, I'm mostly joking :).  That would be a very silly change to make.

But only mostly joking.  btrfs does have a real fragility problem from
all these incomplete error handling paths:

	$ grep 'BUG_ON(ret.*)' fs/btrfs/*.c | wc -l
	197

We should be fixing these, not adding more.  I don't think any patches
should be merged which add more of these.

- z
