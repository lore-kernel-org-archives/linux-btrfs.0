Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56473 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab2IKLMT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 07:12:19 -0400
Received: by pbbrr13 with SMTP id rr13so633410pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 04:12:19 -0700 (PDT)
Message-ID: <504F1C8F.10307@gmail.com>
Date: Tue, 11 Sep 2012 19:12:15 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: enquiry about defrag
References: <504BDCE0.8020407@gmail.com> <CAMQ-g0d3iF-0RCGWd3RD_buXXa3j3DS2PwyUgXSAJ95=-F=c+Q@mail.gmail.com> <504C49F7.2070201@gmail.com> <CAG1y0sdFTKLX8N1VnSYzxZ-Xr4kDPtYGG6ixMrPwBWQPRVAGgg@mail.gmail.com> <504C861D.2020009@gmail.com> <504DDAD5.8010908@gmail.com> <504DE6B3.2010900@oracle.com> <504E75E1.5060304@gmail.com> <504E93BF.9080907@huawei.com>
In-Reply-To: <504E93BF.9080907@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/11/2012 09:28 AM, Li Zefan wrote:
>> may i ask a stupid question, if i remove my "compress-force=lzo" option, will compression disabled for new written data?
> the answer is yes. :)
>
>

The problem seems fixed. The number of extent decrease to 14055 after defrag with compression off.
