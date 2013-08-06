Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41264 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab3HFF4s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 01:56:48 -0400
Message-ID: <5200905A.4080607@cn.fujitsu.com>
Date: Tue, 06 Aug 2013 13:57:46 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: don't overrun "answer" array in cmds-chunk.c
References: <52006509.1060207@redhat.com> <20130806035757.GL12314@lenny.home.zabbo.net>
In-Reply-To: <20130806035757.GL12314@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 5 Aug 2013 20:57:57 -0700, Zach Brown wrote:
> On Mon, Aug 05, 2013 at 09:52:57PM -0500, Eric Sandeen wrote:
>> If an array is 5 chars in size:
>>
>>        char answer[5];
>>
>> and we write the 6th char (counting from 0)...
>>
>>        answer[5] = '\0';
> 
> *high fives*
> 
>> -	answer[5] = '\0';
>> +	answer[4] = '\0';
> 
> I went to see which way of avoiding another magical raw constant would
> be best and did a bit of a double take.
> 
> If you're in here, want to reimplement this thing in a few lines of
> scanf(%s) and strcasecmp()?  I can give it a go if you don't want to.
> 

I think it is better that moving it to utils.c because the other commands
may use it in the future.

Thanks
Miao

