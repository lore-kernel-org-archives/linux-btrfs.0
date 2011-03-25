From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] mutex: Apply adaptive spinning on mutex_trylock()
Date: Thu, 24 Mar 2011 23:24:42 -0400
Message-ID: <20110325032442.GA9313@home.goodmis.org>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324081816.GD30812@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110324081816.GD30812@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2011 at 09:18:16AM +0100, Ingo Molnar wrote:
> 
> * Tejun Heo <tj@kernel.org> wrote:
> 
> > NOT-Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> s/NOT-// ?
> 

Perhaps because it is still in RFC context?

-- Steve

