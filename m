From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Trace: add __print_symbolic_u64 to avoid warnings on
 32bit machine
Date: Mon, 18 Apr 2011 14:11:49 -0400
Message-ID: <1303150309.7181.51.camel@gandalf.stny.rr.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
	 <1301665762.2160.22.camel@gandalf.stny.rr.com>
	 <4D9C2FF6.7090607@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9C2FF6.7090607@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2011-04-06 at 17:18 +0800, liubo wrote:
> Btrfs has some "ULL" macros, and when these macros are passed to tracepoints'
> __print_symbolic(), there will be 64->32 truncate WARNINGS during compiling
> on 32bit box.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  include/linux/ftrace_event.h |   12 ++++++++++++
>  include/trace/events/btrfs.h |    4 ++--
>  include/trace/ftrace.h       |   13 +++++++++++++
>  kernel/trace/trace_output.c  |   27 +++++++++++++++++++++++++++
>  4 files changed, 54 insertions(+), 2 deletions(-)

Could you break this up into two patches. One that touches the ftrace
core, and one that updates btrfs.

Thanks,

-- Steve


