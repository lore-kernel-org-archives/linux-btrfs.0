From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: take block group fragmentation into account for
	allocation
Date: Mon, 9 Mar 2009 11:24:17 -0400
Message-ID: <20090309152417.GA31524@unused.rdu.redhat.com>
References: <2c259a8f0903080742l6e2f6233g709b036281bf962c@mail.gmail.com> <20090308163707.GC11787@kernel.dk> <2c259a8f0903081903w7cebb98excfbf9a4ec5c147d8@mail.gmail.com> <1236606993.7842.8.camel@odie.local> <9F6FB775EC554CDBB1949CDCAC6F08EC@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>,
	Yien Zheng <esprout@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@redhat.com>
To: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9F6FB775EC554CDBB1949CDCAC6F08EC@laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 09, 2009 at 03:21:06PM -0000, Oliver Mattos wrote:
>
>> So the idea of the function is to return an integer in the range
>> [0,100]?
>
> Why are we using a range of 0 to 100 anyway?  100 seems like an arbitary  
> value for kernel space - why not just keep it as a value in the range  
> [0,2^32) ?   That eliminates the arbitary constant of 100, and in some 
> cases could reduce the effects of rounding and allow finer control at no  
> additional expense. 
>

Its not arbitrary, its a percentage, so 0-100 percent.

Josef
