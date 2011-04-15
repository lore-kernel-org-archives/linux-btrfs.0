From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Trace: add __print_symbolic_u64 to avoid warnings on
 32bit machine
Date: Fri, 15 Apr 2011 09:24:18 -0700
Message-ID: <20110415092418.b18fd6fe.randy.dunlap@oracle.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
	<1301665762.2160.22.camel@gandalf.stny.rr.com>
	<4D9C2FF6.7090607@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D9C2FF6.7090607@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 06 Apr 2011 17:18:46 +0800 liubo wrote:

> 
> Btrfs has some "ULL" macros, and when these macros are passed to tracepoints'
> __print_symbolic(), there will be 64->32 truncate WARNINGS during compiling
> on 32bit box.

Hi,

Can this also be used to stop this warning that has been around
like forever (on i386)?

linux-next-20110415/fs/xfs/linux-2.6/./xfs_trace.h:1354: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'


thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
