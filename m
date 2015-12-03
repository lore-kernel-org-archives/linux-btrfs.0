Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpoutz28.laposte.net ([194.117.213.103]:47607 "EHLO
	smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752418AbbLCRNt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Dec 2015 12:13:49 -0500
Received: from smtp.laposte.net (localhost [127.0.0.1])
	by lpn-prd-vrout016 (Postfix) with ESMTP id 9CFEE1116F0
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 18:13:46 +0100 (CET)
Received: from lpn-prd-vrin004 (lpn-prd-vrin004.laposte [10.128.63.5])
	by lpn-prd-vrout016 (Postfix) with ESMTP id 704A111162D
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 18:13:46 +0100 (CET)
Received: from lpn-prd-vrin004 (localhost [127.0.0.1])
	by lpn-prd-vrin004 (Postfix) with ESMTP id 4B07D70E269
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 18:13:46 +0100 (CET)
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <56519644.8060105@laposte.net> <56526543.4090301@cn.fujitsu.com>
 <565462F7.8040601@laposte.net> <5654F6BC.8020900@gmx.com>
 <565579DB.2040105@laposte.net>
Cc: Lukas Pirl <btrfs@lukas-pirl.de>, linux-btrfs@vger.kernel.org,
        calestyo@scientia.net
From: Laurent Bonnaud <L.Bonnaud@laposte.net>
Message-ID: <56607848.5040705@laposte.net>
Date: Thu, 3 Dec 2015 18:13:44 +0100
MIME-Version: 1.0
In-Reply-To: <565579DB.2040105@laposte.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/11/2015 10:05, Laurent Bonnaud wrote:

>> > Nice reproducer.
>> > Is it 100% reproducible or has a chance to reproduce?
> I tried a second time and got a similar kernel backtrace.

Hi,

any news since you downloaded my FS image ?

I kept my corrupted FS in case you wanted more info, but since I use this disk as a backup, it deprives me from one backup.  So would you mind if I replace my corrupted FS with a new one ?

Thanks for investigating this bug,

-- 
Laurent.
