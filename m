From: "Oliver Mattos" <oliver.mattos08@imperial.ac.uk>
Subject: Re: [PATCH] Btrfs: take block group fragmentation into account for allocation
Date: Mon, 9 Mar 2009 15:21:06 -0000
Message-ID: <9F6FB775EC554CDBB1949CDCAC6F08EC@laptop>
References: <2c259a8f0903080742l6e2f6233g709b036281bf962c@mail.gmail.com> <20090308163707.GC11787@kernel.dk> <2c259a8f0903081903w7cebb98excfbf9a4ec5c147d8@mail.gmail.com> <1236606993.7842.8.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Cc: "Jens Axboe" <jens.axboe@oracle.com>,
	<linux-btrfs@vger.kernel.org>, "Josef Bacik" <jbacik@redhat.com>
To: =?utf-8?Q?Simon_Holm_Th=C3=B8gersen?= <odie@cs.aau.dk>,
	"Yien Zheng" <esprout@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1236606993.7842.8.camel@odie.local>
List-ID: <linux-btrfs.vger.kernel.org>


> So the idea of the function is to return an integer in the range
> [0,100]?

Why are we using a range of 0 to 100 anyway?  100 seems like an arbitary 
value for kernel space - why not just keep it as a value in the range 
[0,2^32) ?   That eliminates the arbitary constant of 100, and in some cases 
could reduce the effects of rounding and allow finer control at no 
additional expense. 

