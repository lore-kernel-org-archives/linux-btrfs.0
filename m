From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] tracing: add __print_symbolic_u64 to avoid
 warnings on 32bit machine
Date: Wed, 25 May 2011 08:27:44 -0400
Message-ID: <1306326464.1465.85.camel@gandalf.stny.rr.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
	 <1301665762.2160.22.camel@gandalf.stny.rr.com>
	 <4D9C2FF6.7090607@cn.fujitsu.com>
	 <1303150309.7181.51.camel@gandalf.stny.rr.com>
	 <4DACE6E0.7000507@cn.fujitsu.com>  <4DBA8C95.4000300@cn.fujitsu.com>
	 <1304264124.25414.1079.camel@gandalf.stny.rr.com>
	 <4DDDE9E6.7090303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DDDE9E6.7090303@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2011-05-26 at 01:49 -0400, liubo wrote:
> On 05/01/2011 11:35 AM, Steven Rostedt wrote:
> > On Fri, 2011-04-29 at 18:01 +0800, liubo wrote:
> >> ping?
> > 
> > Sorry, I've been trying to get the new ftrace function tracer features
> > out ASAP. I plan on looking at this when I'm done.
> > 
> > Thanks,
> > 
> 
> Hi, Steven,
> 
> I've seen your latest git-pull, but these 2 patches are not included yet,
> so is there any problem with them?

Actually, I was trying to get out what I had. There's a bit more patches
that I need to process still. This being one of them.

But what I sent out previously is not going into 2.6.40 anyway. Ingo
feels that it's too late in the merge window to pull those changes and
wants to wait till the next merge window. Since there's some fixes in
that pull request, I'll need to cherry pick them out and rebase the rest
for the next window.

I'll look at this patch soon. It's still in my queue "todo" ;)

-- Steve

> 
> If it does, I can be helpful. :)
