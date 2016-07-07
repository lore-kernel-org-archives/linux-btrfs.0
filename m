Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061AbcGGCnO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jul 2016 22:43:14 -0400
Subject: Re: [PATCH] btrfs-progs: du: fix to skip not btrfs dir/file
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
References: <1467807934-23403-1-git-send-email-wangshilong1991@gmail.com>
 <577D091F.6020407@applied-asynchrony.com>
Cc: dsterba@suse.cz
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <606f0245-68b6-587f-eb2c-7044144af83d@redhat.com>
Date: Wed, 6 Jul 2016 21:43:12 -0500
MIME-Version: 1.0
In-Reply-To: <577D091F.6020407@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/6/16 8:35 AM, Holger Hoffstätte wrote:
> On 07/06/16 14:25, Wang Shilong wrote:

...

>> After patch, it will look like:
>>    Total   Exclusive  Set shared  Filename
>> skipping not btrfs dir/file: boot
>> skipping not btrfs dir/file: dev
>> skipping not btrfs dir/file: proc
>> skipping not btrfs dir/file: run
>> skipping not btrfs dir/file: sys
>>      0.00B       0.00B           -  //root/.bash_logout
>>      0.00B       0.00B           -  //root/.bash_profile
>>      0.00B       0.00B           -  //root/.bashrc
>>      0.00B       0.00B           -  //root/.cshrc
>>      0.00B       0.00B           -  //root/.tcshrc
>>
>> This works for me to analysis system usage and analysis
>> performaces.
> 
> This is great, but can we please skip the "skipping .." messages?
> Maybe it's just me but I really don't see the value of printing them
> when they don't contribute to the result.
> They also mess up the display. :)

<driveby>
I agree, those messages add no value.
</driveby>

-Eric

> thanks,
> Holger

