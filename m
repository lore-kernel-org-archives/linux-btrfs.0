From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 16:02:11 +0200
Message-ID: <20081022160211.e7295fcf.skraw@ithnet.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	<1224597580.27474.93.camel@think.oraclecorp.com>
	<20081021182710.a12f4914.skraw@ithnet.com>
	<1224611383.27474.140.camel@think.oraclecorp.com>
	<20081022141906.f6529c6d.skraw@ithnet.com>
	<c24352ca0810220548h4f383b32u18efa44251797b3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "Jeff Schroeder" <jeffschroed@gmail.com>,
	"Chris Mason" <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: jeffschroeder@computer.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c24352ca0810220548h4f383b32u18efa44251797b3d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 22 Oct 2008 05:48:30 -0700
"Jeff Schroeder" <jeffschroed@gmail.com> wrote:

> > NFS is a good example for a fs that never got redesigned for modern world. I
> > hope it will, but currently it's like Model T on a highway.
> > You have a NFS server with clients. Your NFS server dies, your backup server
> > cannot take over the clients without them resetting their NFS-link (which
> > means reboot to many applications) - no way.
> > Besides that you still need another fs below NFS to bring your data onto some
> > medium, which means you still have the problem how to create redundancy in
> > your server architecture.
> 
> You are somewhat misinformed on this. Perhaps the Linux nfs server can't cope,
> but I doubt it. NFS was designed to be stateless. I've got a fair
> amount of experience
> with a dual head netapp architecture. When 1 head dies, the other
> transparently fails
> over. During the brief downtime, the clients will go into I/O wait if
> at all instead of being
> disconnected. You might be able to do something similar using nfsd and
> keepalived if
> both servers were connected to the same storage. Setting that up would
> be trivial. You
> just need the clients mounting the vip and a reliable mechanism to
> provide the data from
> that vip. You could use heartbeat, but it is overly complex. Also look
> at clustered nfs or
> pnfs, both of which are nfs redesigns like you speak of.

we tried that with pure linux nfs, and it does not work. The clients do not
recover. After trying ourselves and failing we found several docs on the net
that described just the same problem and its reasons. Very likely netapp found
that out too and did something against it. 

Ah yes, and btw, your description contains another discussed problem: "both
servers were connected to the same storage". If you mean that both servers
really access the same storage at the same time your software options are
pretty few in numbers.

> -- 
> Jeff Schroeder

-- 
Regards,
Stephan

