Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36936 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab3EYLxl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 07:53:41 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: george@chinilu.com
Cc: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Virtual Device Support ("N-way mirror code")
Date: Sat, 25 May 2013 13:53:39 +0200
Message-ID: <1475157.0IUGs6RWvS@merkaba>
In-Reply-To: <519EC537.4090801@chinilu.com>
References: <518CFE3A.3080900@chinilu.com> <1823670.hMFQUu2mCu@merkaba> <519EC537.4090801@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 23. Mai 2013, 18:41:11 schrieb George Mitchell:
> On 05/23/2013 09:08 AM, Martin Steigerwald wrote:
> > 3) As to my knowledge mount times of large partitions can be quite
> > long with ReiserFS 3.
> 
> That may well be, but I certainly wouldn't consider btrfs mount times
> "fast" in such cases.
> 
> [root@localhost ghmitch]# time mount LABEL=BACKUP /backup
> 
> real    0m18.133s
> user    0m0.000s
> sys     0m0.190s
> [root@localhost ghmitch]#

Well yes, I saw some a bit longer mount times for my 2 TB backup disk with 
quite some snapshots as well already.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
