From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] tracing: add __print_symbolic_u64 to avoid
 warnings on 32bit machine
Date: Wed, 25 May 2011 21:17:07 -0400
Message-ID: <1306372627.1465.131.camel@gandalf.stny.rr.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
	 <1301665762.2160.22.camel@gandalf.stny.rr.com>
	 <4D9C2FF6.7090607@cn.fujitsu.com>
	 <1303150309.7181.51.camel@gandalf.stny.rr.com>
	 <4DACE6E0.7000507@cn.fujitsu.com> <4DBA8C95.4000300@cn.fujitsu.com>
	 <1304264124.25414.1079.camel@gandalf.stny.rr.com>
	 <4DDDE9E6.7090303@cn.fujitsu.com>
	 <1306326464.1465.85.camel@gandalf.stny.rr.com>
	 <20110525091252.8899385e.randy.dunlap@oracle.com>
	 <1306342064.1465.101.camel@gandalf.stny.rr.com>
	 <4DDDA7F5.9020001@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DDDA7F5.9020001@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2011-05-26 at 09:08 +0800, Li Zefan wrote:
> Steven Rostedt wrote:

> Actually it's more than a compile warning fix.
> 
> After a variable is cast from u64 to u32 and passed to __print_symbolic(),
> we'll see incorrect result in the trace output.

Don't worry, I didn't even say a warning fix was not reason to get into
this merge window.

There was only two patches in my last pull request that were not fixing
a bug and/or warning, but adding enhancements. I rebased without them
and even added this patch and another bug fix patch to get ready to push
out.

After my ktest runs are done (I test each patch on x86_64 and x86_32,
and then compile test them on a bunch of other archs), I'll do another
git pull request for this merge window.

Thanks!

-- Steve
