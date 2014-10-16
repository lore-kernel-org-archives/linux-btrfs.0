Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35288 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJPBh4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 21:37:56 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id C33453EE1C1
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Oct 2014 10:37:54 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id D0C38AC06E4
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Oct 2014 10:37:53 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 527011DB803F
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Oct 2014 10:37:53 +0900 (JST)
Message-ID: <543F213F.5090308@jp.fujitsu.com>
Date: Thu, 16 Oct 2014 03:37:03 +0200
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>
CC: naota <naota@elisp.net>
Subject: Re: [PATCH 1/4] btrfs: correct empty compression property behavior
References: <541BED3D.5020803@jp.fujitsu.com> <20140929163646.GF11436@twin.jikos.cz>
In-Reply-To: <20140929163646.GF11436@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David and Chris,

(2014/09/29 18:36), David Sterba wrote:
> On Fri, Sep 19, 2014 at 05:45:49PM +0900, Satoru Takeuchi wrote:
>> In the current implementation, compression property == "" has
>> the two different meanings: one is with BTRFS_INODE_NOCOMPRESS,
>> and the other is without this flag.
>>
>> So, even if the two files a and b have the same compression
>> property, "", and the same contents, one file seems to be
>> compressed and the other is not. It's difficult to understand
>> for users and also confuses them.
>
> Fixing this inconsistency is good, let me think more about the
> interface.

How about these patches? These patches seems not to be merged yet.
Especially patch 4/4 resolve the bug that atomic two operations
are separated to the different two transactions. I consider this
patch should be applied as soon as possible.

Thanks,
Satoru

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

