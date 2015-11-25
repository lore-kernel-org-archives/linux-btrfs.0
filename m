Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57450 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbbKYACS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 19:02:18 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <1448175373.7143.24.camel@scientia.net> <56526790.6020907@cn.fujitsu.com>
 <1448302368.2100.28.camel@scientia.net> <5653B34B.9000103@cn.fujitsu.com>
 <1448330029.14125.13.camel@scientia.net> <5653C6D5.1010908@cn.fujitsu.com>
 <1448333334.14125.14.camel@scientia.net> <5653D157.5060209@cn.fujitsu.com>
 <1448334124.14125.17.camel@scientia.net> <5653F725.5030700@cn.fujitsu.com>
 <1448389513.21291.38.camel@scientia.net>
Cc: linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5654FA80.4000402@gmx.com>
Date: Wed, 25 Nov 2015 08:02:08 +0800
MIME-Version: 1.0
In-Reply-To: <1448389513.21291.38.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/25/2015 02:25 AM, Christoph Anton Mitterer wrote:
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

That's too bad...
Although you can try debugging again, but the result may not change at 
all. :(

There maybe some complicated debugging method, like add breakpoint at 
add_extent_rec() for special bytenr(bytenr in btrfsck error output, e.g 
5993525264384) to check if its metadata flag is set correctly.

If metadata flag is not set correctly, the backtrace will provide a lot 
of useful info...
But that's what dev should do, not an end user.
I'm totally OK if you can't provide that output.

I'll continue searching the code for any possible false alert.
But without a local test image, I'm afraid you may try several patches 
until a final fix is found....

Thanks,
Qu

>
> Cheers,
> Chris.
>
