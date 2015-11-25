Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21018 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753852AbbKYA7n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 19:59:43 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Christoph Anton Mitterer <calestyo@scientia.net>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <1448175373.7143.24.camel@scientia.net> <56526790.6020907@cn.fujitsu.com>
 <1448302368.2100.28.camel@scientia.net> <5653B34B.9000103@cn.fujitsu.com>
 <1448330029.14125.13.camel@scientia.net> <5653C6D5.1010908@cn.fujitsu.com>
 <1448333334.14125.14.camel@scientia.net> <5653D157.5060209@cn.fujitsu.com>
 <1448334124.14125.17.camel@scientia.net> <5653F725.5030700@cn.fujitsu.com>
 <1448389513.21291.38.camel@scientia.net>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <565507EF.5030205@cn.fujitsu.com>
Date: Wed, 25 Nov 2015 08:59:27 +0800
MIME-Version: 1.0
In-Reply-To: <1448389513.21291.38.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Christoph Anton Mitterer wrote on 2015/11/24 19:25 +0100:
> On Tue, 2015-11-24 at 13:35 +0800, Qu Wenruo wrote:
>> Hopes you didn't wait too long.
> No worries, didn't hold my breath ;)
>
>
>> The fixing patch is CCed to you, or you can get it from patchwork:
>> https://patchwork.kernel.org/patch/7687611/
> Unfortunately that doesn't make the error messages go away.
> :(
>
> Shall I start debugging again?
>
> Cheers,
> Chris.
>
Quite strange...

I succeeded in reproducing the bug, just disable skinny metadata and 
create fill a btrfs with fsstress.

Btrfsck will report a lot of such false alert.
But with my patch applied, all the warning just disappeared...

Did you use the complied btrfsck? Or use the system btrfsck by mistake?

Thanks,
Qu

-- 
This message has been scanned for viruses and
dangerous content by Fujitsu, and is believed to be clean.

