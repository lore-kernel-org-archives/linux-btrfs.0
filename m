Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob05.myregisteredsite.com ([209.17.115.43]:43245 "EHLO
	atl4mhob05.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759148Ab3EXBlH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 21:41:07 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob05.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r4O1f5Fp022849
	for <linux-btrfs@vger.kernel.org>; Thu, 23 May 2013 21:41:05 -0400
Message-ID: <519EC537.4090801@chinilu.com>
Date: Thu, 23 May 2013 18:41:11 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Virtual Device Support ("N-way mirror code")
References: <518CFE3A.3080900@chinilu.com> <pan$9855$81c2d2df$c9aa1ca3$2451cc46@cox.net> <knfoof$u08$1@ger.gmane.org> <1823670.hMFQUu2mCu@merkaba>
In-Reply-To: <1823670.hMFQUu2mCu@merkaba>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2013 09:08 AM, Martin Steigerwald wrote:
> 3) As to my knowledge mount times of large partitions can be quite 
> long with ReiserFS 3.

That may well be, but I certainly wouldn't consider btrfs mount times 
"fast" in such cases.

[root@localhost ghmitch]# time mount LABEL=BACKUP /backup

real    0m18.133s
user    0m0.000s
sys     0m0.190s
[root@localhost ghmitch]#

