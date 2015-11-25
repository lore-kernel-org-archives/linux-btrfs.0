Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpoutz24.laposte.net ([194.117.213.99]:42647 "EHLO
	smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932322AbbKYJFe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 04:05:34 -0500
Received: from smtp.laposte.net (localhost [127.0.0.1])
	by lpn-prd-vrout012 (Postfix) with ESMTP id 8E16F8C884
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 10:05:32 +0100 (CET)
Received: from lpn-prd-vrin003 (lpn-prd-vrin003.prosodie [10.128.63.4])
	by lpn-prd-vrout012 (Postfix) with ESMTP id 8C83F8C866
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 10:05:32 +0100 (CET)
Received: from lpn-prd-vrin003 (localhost [127.0.0.1])
	by lpn-prd-vrin003 (Postfix) with ESMTP id 799AA48C396
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 10:05:32 +0100 (CET)
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <56519644.8060105@laposte.net> <56526543.4090301@cn.fujitsu.com>
 <565462F7.8040601@laposte.net> <5654F6BC.8020900@gmx.com>
Cc: Lukas Pirl <btrfs@lukas-pirl.de>, linux-btrfs@vger.kernel.org,
        calestyo@scientia.net
From: Laurent Bonnaud <L.Bonnaud@laposte.net>
Message-ID: <565579DB.2040105@laposte.net>
Date: Wed, 25 Nov 2015 10:05:31 +0100
MIME-Version: 1.0
In-Reply-To: <5654F6BC.8020900@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/11/2015 00:46, Qu Wenruo wrote:

> The size seems small enough, I'll try to download it as it's super useful to debug it.

Thanks !

> Nice reproducer.
> Is it 100% reproducible or has a chance to reproduce?

I tried a second time and got a similar kernel backtrace.

> BTW, did you encountered the same btrfsck error "chunk type dismatch" from Christoph? 

Yes, that's what drew me to this discussion :>.

I also tried the --repair option and that is perhaps what corrupted my FS.

-- 
Laurent.
