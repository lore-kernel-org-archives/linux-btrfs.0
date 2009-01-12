From: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 19:32:44 +0200
Message-ID: <496B7EBC.6020208@redhat.com>
References: <1231774622.4371.96.camel@laptop>  <496B6C23.8000808@redhat.com> <1231780388.4371.185.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231780388.4371.185.camel@laptop>
List-ID: <linux-btrfs.vger.kernel.org>

Peter Zijlstra wrote:
> Spinlocks can use 'pure' MCS locks.
>   

How about this, then.  In mutex_lock(), keep wait_lock locked and only 
release it when scheduling out.  Waiter spinning naturally follows.  If 
spinlocks are cache friendly (are they today?) we inherit that.  If 
there is no contention on the mutex, then we don't need to reacquire the 
wait_lock on mutex_unlock() (not that the atomic op is that expensive 
these days).

-- 
error compiling committee.c: too many arguments to function

