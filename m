Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:63978 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754346AbdHYAfE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 20:35:04 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id CD2E0AC0192
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 09:34:56 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: doc: fix btrfs-inspect-internal rootid doc
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <453da244-de65-e58b-ef28-f6dbff093052@jp.fujitsu.com>
 <20170824173734.GI2866@twin.jikos.cz>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <28eb3b27-6dc2-cc5c-d563-72a6a49716c7@jp.fujitsu.com>
Date: Fri, 25 Aug 2017 09:34:49 +0900
MIME-Version: 1.0
In-Reply-To: <20170824173734.GI2866@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/08/25 2:37, David Sterba wrote:
> On Thu, Aug 24, 2017 at 04:39:53PM +0900, Misono, Tomohiro wrote:
>> "btrfs inspect-internal rootid <path>" rejects a file to be specified in
>> the implementation.
>> Therefore change "file or directory" to "directory" in the doc.
> 
> Is there a reason why a file should not be accepted? The ioctl supports
> that just fine.
> 
> 

I thought ioctl would work for file, but current code checks whether 
<path> is directory or not in the first place. So, I change the doc.

If it is better to change the code rather than the doc, I will do that. 
What do you think?

