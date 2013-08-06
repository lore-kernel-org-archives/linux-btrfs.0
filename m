Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab3HFEDo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 00:03:44 -0400
Message-ID: <5200759C.2040200@redhat.com>
Date: Mon, 05 Aug 2013 23:03:40 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs-progs: don't overrun "answer" array in cmds-chunk.c
References: <52006509.1060207@redhat.com> <20130806035757.GL12314@lenny.home.zabbo.net>
In-Reply-To: <20130806035757.GL12314@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/5/13 10:57 PM, Zach Brown wrote:
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

Zach, I think you'd do that really, really well.  ;)

-Eric

(sorry for just going for the expedient/obvious/1-char fix :) )
 
> - z
> 

