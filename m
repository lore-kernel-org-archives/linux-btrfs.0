From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Trace: add __print_symbolic_u64 to avoid warnings on
 32bit machine
Date: Tue, 19 Apr 2011 09:08:21 +0800
Message-ID: <4DACE085.9070202@cn.fujitsu.com>
References: <4D9573DB.4010009@cn.fujitsu.com>	 <1301665762.2160.22.camel@gandalf.stny.rr.com>	 <4D9C2FF6.7090607@cn.fujitsu.com> <1303150309.7181.51.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303150309.7181.51.camel@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/19/2011 02:11 AM, Steven Rostedt wrote:
> On Wed, 2011-04-06 at 17:18 +0800, liubo wrote:
>> Btrfs has some "ULL" macros, and when these macros are passed to tracepoints'
>> __print_symbolic(), there will be 64->32 truncate WARNINGS during compiling
>> on 32bit box.
>>
>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
>> ---
>>  include/linux/ftrace_event.h |   12 ++++++++++++
>>  include/trace/events/btrfs.h |    4 ++--
>>  include/trace/ftrace.h       |   13 +++++++++++++
>>  kernel/trace/trace_output.c  |   27 +++++++++++++++++++++++++++
>>  4 files changed, 54 insertions(+), 2 deletions(-)
> 
> Could you break this up into two patches. One that touches the ftrace
> core, and one that updates btrfs.
> 

Sure, I'll break it and resend soon.  Thanks for the reply.

thanks,
liubo

> Thanks,
> 
> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

