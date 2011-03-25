From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH] mutex: Apply adaptive spinning on mutex_trylock()
Date: Fri, 25 Mar 2011 11:29:12 +0100
Message-ID: <20110325102912.GB31903@elte.hu>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324081816.GD30812@elte.hu>
 <20110325032442.GA9313@home.goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110325032442.GA9313@home.goodmis.org>
List-ID: <linux-btrfs.vger.kernel.org>


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, Mar 24, 2011 at 09:18:16AM +0100, Ingo Molnar wrote:
> > 
> > * Tejun Heo <tj@kernel.org> wrote:
> > 
> > > NOT-Signed-off-by: Tejun Heo <tj@kernel.org>
> > 
> > s/NOT-// ?
> > 
> 
> Perhaps because it is still in RFC context?

Ok, i guess i was a bit too cryptic about it: the discussion was in support of 
the changes so i asked Tejun above to send a SOB version and did that in a 
geeky way.

And paid my price for the shortcut: had two write two other emails about it 
already ;-)

Thanks,

	Ingo
