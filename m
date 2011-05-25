From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] tracing: add __print_symbolic_u64 to avoid
 warnings on 32bit machine
Date: Wed, 25 May 2011 12:47:44 -0400
Message-ID: <1306342064.1465.101.camel@gandalf.stny.rr.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
	 <1301665762.2160.22.camel@gandalf.stny.rr.com>
	 <4D9C2FF6.7090607@cn.fujitsu.com>
	 <1303150309.7181.51.camel@gandalf.stny.rr.com>
	 <4DACE6E0.7000507@cn.fujitsu.com> <4DBA8C95.4000300@cn.fujitsu.com>
	 <1304264124.25414.1079.camel@gandalf.stny.rr.com>
	 <4DDDE9E6.7090303@cn.fujitsu.com>
	 <1306326464.1465.85.camel@gandalf.stny.rr.com>
	 <20110525091252.8899385e.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Cc: liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110525091252.8899385e.randy.dunlap@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2011-05-25 at 09:12 -0700, Randy Dunlap wrote:
>  
> > But what I sent out previously is not going into 2.6.40 anyway. Ingo
> > feels that it's too late in the merge window to pull those changes and
> > wants to wait till the next merge window. Since there's some fixes in
> > that pull request, I'll need to cherry pick them out and rebase the rest
> > for the next window.
> 
> Sorry to hear all of that.  This fix is needed in mainline.
> 

Hmm, it is a warning fix. Well, I could add this to the cherry picking
I'm doing (fixes only).

I'm currently making a fix for a triple fault in the function tracer
caused by PROVE_RCU causing recursive tracing. When I get this fixed,
I'll be pushing the "fixes" next.

Thanks!

-- Steve
