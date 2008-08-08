From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Btrfs v0.16 released
Date: Fri, 8 Aug 2008 23:56:25 +0200
Message-ID: <20080808215625.GC9038@one.firstfloor.org>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1218221293.15342.263.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

> So, the mirroring turns a single large write into two large writes.
> Definitely not free, but always a fixed cost.

Thanks for the explanation and the numbers. I see that's the advantage of 
copy-on-write that you can actually always cluster the metadata together and 
get always batched IO this way and then afford to do more of it. 

Still wondering what that will do to read seekiness.

-Andi
