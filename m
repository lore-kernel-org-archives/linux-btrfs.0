Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab3B0P7Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 10:59:24 -0500
Message-ID: <512E2D36.4040307@redhat.com>
Date: Wed, 27 Feb 2013 09:58:46 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Wang Shilong <wangshilong1991@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: fix parse_limit function to return errors
 when parsing unit
References: <1361449575-1835-1-git-send-email-wangshilong1991@gmail.com> <20130227155255.GI27541@twin.jikos.cz>
In-Reply-To: <20130227155255.GI27541@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/27/13 9:52 AM, David Sterba wrote:
> On Thu, Feb 21, 2013 at 08:26:15PM +0800, Wang Shilong wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>
>> Steps to reproduce:
>> 	btrfs qgroup limit m <mnt>/subv
>>
>> Here, unit(k/K/g/G/m/M/t/T) all will trigger the problem.
>> For the above command, the original code will parse the limit value as 0
>> and return successfully.It is wrong,fix it.
> 
> I don't think we should allow to accept bare units for specifing
> numbers, so in that case fail with 'unrecognized limit'.

I agree with that.  

Maybe since David didn't quite want to take my patch 01/17, and Zach
thought we needed better code for it all, and Goffredo didn't like
the exit() from parse_size, and now this problem, we need a single,
concerted effort to fix up size parsing.

Who knew it was so hard? :)

-Eric

> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

