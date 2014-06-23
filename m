Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:36475 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaFWXNw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 19:13:52 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 9E1D73EE0C3
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 08:13:50 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.nic.fujitsu.com [10.0.50.92])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id AC947AC05D3
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 08:13:49 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 644471DB802C
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 08:13:49 +0900 (JST)
Message-ID: <53A8B45E.7020809@jp.fujitsu.com>
Date: Tue, 24 Jun 2014 08:12:30 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Adam Buchbinder <abuchbinder@google.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Properly size the leafsize field in the mdrestore_struct
 struct.
References: <1402613853-14956-1-git-send-email-abuchbinder@google.com> <53A12B3C.7020606@jp.fujitsu.com> <20140623134433.GD1553@twin.jikos.cz>
In-Reply-To: <20140623134433.GD1553@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/06/23 22:44), David Sterba wrote:
> On Wed, Jun 18, 2014 at 03:01:32PM +0900, Satoru Takeuchi wrote:
>> (2014/06/13 7:57), Adam Buchbinder wrote:
>>> It's 32 bits as defined in ctree.h, but the struct had it as 64 bits.
>>>
>>> Found using MemorySanitizer.
>>>
>>> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
>>
>> It looks good to me.
>>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>
> Sidned-off? Did you mean Reviewed-by ?
>

Oops, sorry.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

