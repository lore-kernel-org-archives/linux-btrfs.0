From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: add initial tracepoint support for btrfs
Date: Tue, 29 Mar 2011 09:16:11 +0800
Message-ID: <4D9132DB.9000507@cn.fujitsu.com>
References: <4D8B28A3.7050105@cn.fujitsu.com> <1301141505-sup-3679@think> <1301273942-sup-2832@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1301273942-sup-2832@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/28/2011 08:59 AM, Chris Mason wrote:
> Excerpts from Chris Mason's message of 2011-03-26 08:12:04 -0400:
>> Excerpts from liubo's message of 2011-03-24 07:18:59 -0400:
>>> Tracepoints can provide insight into why btrfs hits bugs and be greatly
>>> helpful for debugging, e.g
>> This is really neat, I've queued it up.
> 
> Whoops, it has a lot of warnings when compiled on 32 bit machines.
> Please take a look:
> 
> include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:68:1: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:68:1: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:68:1: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:144:1: warning: large integer implicitly truncated to unsigned type
> 

Ahh, I figure it out.
Will send a new version to clear warnings.

Thanks,
liubo

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

