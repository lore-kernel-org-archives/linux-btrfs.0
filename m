Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.bordeaux.inra.fr ([147.100.111.220]:30142 "EHLO
	mail-1.bordeaux.inra.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754489AbbFOOoS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 10:44:18 -0400
Received: from [147.100.98.136] ([147.100.98.136])
	(authenticated bits=0)
	by mail-1.bordeaux.inra.fr (/8.14.4) with ESMTP id t5FEiFvb027403
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 16:44:15 +0200 (CEST)
Message-ID: <557EE4BF.2090908@bordeaux.inra.fr>
Date: Mon, 15 Jun 2015 16:44:15 +0200
From: Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Bad performance with near-full FS
References: <557EC95C.8020902@bordeaux.inra.fr> <20150615132915.GM6761@twin.jikos.cz>
In-Reply-To: <20150615132915.GM6761@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/15/2015 03:29 PM, David Sterba wrote:
> On Mon, Jun 15, 2015 at 02:47:24PM +0200, Tovo Rabemanantsoa wrote:
>> Hi all,
>> By browsing this list's archive, I've found a thread initiated by
>> Charles Cazabon entitled: "Oddly slow read performance with near-full
>> largish FS."
>> Actually, I'm living the same experience but with a not so large FS
>> (256GB on a SSD). Indeed, when I have less than 1GB of free space, the
>> applications (thunderbird, thunar ...) on the machine become awfully
>> slow but remain normal if I make some cleaning.
>> Is it due to the FS or because it's an SSD hard disk ?
> 
> 1G of 256G is less than a percent. At this level of usage you can expect
> slowdown on any filesystem.
> 
> This could be caused by free space fragmentation and even on a SSD, this
> needs extra time to process.  Higher number of fragments needs more
> structures to represent them and cost more CPU time, though this still
> might not be the worst impact.
> 
> AFAIK btrfs space handling logic needs to do more flushes of unwritten
> data when the accounted free space goes below some threshold (because
> COW needs to write the data twice before it switches to the new "root"
> pointer and can free the previous version).

Thanks for you reply,
If I really understand, it's always a good idea to keep more than 1% of
free space. Right ?
