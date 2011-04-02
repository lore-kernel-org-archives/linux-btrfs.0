From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [RFC PATCH] Trace: use unsigned long long in trace print frames
Date: Sat, 02 Apr 2011 09:41:35 +0800
Message-ID: <4D967ECF.8050802@cn.fujitsu.com>
References: <4D9573DB.4010009@cn.fujitsu.com> <1301665762.2160.22.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1301665762.2160.22.camel@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/01/2011 09:49 PM, Steven Rostedt wrote:
> On Fri, 2011-04-01 at 14:42 +0800, liubo wrote:
>> While adding tracepoint for btrfs, I got a problem:
>>
>> btrfs uses some macros with "ULL" type, but tracepoint's macros,
>> __print_[flags,symbols](), only have "unsigned long", so on 32bit box
>> there will be 64->32 truncate WARNINGs when compiling.
>>
>> Here I'm inclined to make the replacement to clear those WARNINGs.
> 
> Hmm, I don't like this. unsigned long is a natural word for
> architectures, I don't want to have 32 bit suffer because one user is
> doing something with ULL.
> 
> A better solution is to add a trace_print_flags_u64 or something, that
> can be used for cases that u64 is needed. For archs were sizeof(long) ==
> sizeof(u64) we can have the two macros/structs be the same.
> 

All right, a u64 specific one is also in my mind. :)

thanks,
liubo

> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
