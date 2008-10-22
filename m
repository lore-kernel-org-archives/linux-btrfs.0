From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 09:19:53 -0400
Message-ID: <1224681593.6448.7.camel@think.oraclecorp.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	 <1224597580.27474.93.camel@think.oraclecorp.com>
	 <1224622451.7412.1.camel@telesto> <48FE553D.80501@redhat.com>
	 <1224642544.7189.17.camel@telesto> <48FF038A.4010105@redhat.com>
	 <48FF0625.6040400@kernel.org> <48FF2343.3070107@redhat.com>
	 <48FF276B.6090602@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Eric Anopolsky <erpo41@gmail.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF276B.6090602@kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-10-22 at 22:15 +0900, Tejun Heo wrote:
> Ric Wheeler wrote:
> > I think that we do handle a failure in the case that you outline above
> > since the FS will be able to notice the error before it sends a commit
> > down (and that commit is wrapped in the barrier flush calls). This is
> > the easy case since we still have the context for the IO.
> 
> I'm no FS guy but for that to be true FS should be waiting for all the
> outstanding IOs to finish before issuing a barrier and actually
> doesn't need barriers at all - it can do the same with flush_cache.
> 

We wait and then barrier.  If the barrier returned status that a
previously ack'd IO had actually failed, we could do something to make
sure the FS was consistent.

-chris


