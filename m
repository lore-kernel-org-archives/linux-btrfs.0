Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35892 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752467AbcEYAdy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 May 2016 20:33:54 -0400
Subject: Re: [PATCH] btrfs-progs: utils: use better wrappered random generator
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1463973049-3480-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160523120112.GK29147@twin.jikos.cz>
 <f9d00b26-b0d7-c720-9dcf-4c4268a9ff75@cn.fujitsu.com>
 <20160524095155.GN29147@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <913572bb-72f3-1428-f50c-4dc338d5c528@cn.fujitsu.com>
Date: Wed, 25 May 2016 08:33:45 +0800
MIME-Version: 1.0
In-Reply-To: <20160524095155.GN29147@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/24 11:51 +0200:
> On Tue, May 24, 2016 at 08:31:01AM +0800, Qu Wenruo wrote:
>>> This could be made static (with thread local storage) so the state does
>>> not get regenerated all the time. Possibly it could be initialize from
>>> some true random source, not time or pid.
>>
>> I also considered true random source like /dev/random, but since it's
>> possible to wait for entropy pool, it would be quite slow and confusing
>> for users.
>
> How would it be confusing? We'll once seed the random generator from
> /dev/random, reading 3 * 16bit for the nrand generator context.

Reading from /dev/random may sleep, until the entropy pool is filled.

This may cause any caller of the new random API sleep for a long time.
Just like when using openssl to generate private key.

Also, for current use case, I didn't think we really need that true 
random bytes even as random seed.

We're not generating key pair, we only need to make the numbers seems to 
be random(pseudo random).

So IMHO the cost of hanging btrfs-corrupt-block is not validated for 
just true random seed.

Thanks,
Qu
>
>> So time with pid seems good enough.
>
> Only as a fallback if /dev/random is not available at all.
>
>


