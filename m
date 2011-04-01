From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Trace: use unsigned long long in trace print frames
Date: Fri, 01 Apr 2011 09:49:22 -0400
Message-ID: <1301665762.2160.22.camel@gandalf.stny.rr.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D9573DB.4010009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2011-04-01 at 14:42 +0800, liubo wrote:
> While adding tracepoint for btrfs, I got a problem:
> 
> btrfs uses some macros with "ULL" type, but tracepoint's macros,
> __print_[flags,symbols](), only have "unsigned long", so on 32bit box
> there will be 64->32 truncate WARNINGs when compiling.
> 
> Here I'm inclined to make the replacement to clear those WARNINGs.

Hmm, I don't like this. unsigned long is a natural word for
architectures, I don't want to have 32 bit suffer because one user is
doing something with ULL.

A better solution is to add a trace_print_flags_u64 or something, that
can be used for cases that u64 is needed. For archs were sizeof(long) ==
sizeof(u64) we can have the two macros/structs be the same.

-- Steve
