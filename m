From: Chris Mason <chris.mason@oracle.com>
Subject: Re: still see locking issues...
Date: Thu, 31 Jul 2008 10:11:16 -0400
Message-ID: <1217513476.20239.47.camel@think.oraclecorp.com>
References: <21782573.1217014155193.JavaMail.oracle@acsmt304.oracle.com>
	 <1217257799.7572.103.camel@think.oraclecorp.com>
	 <4891C236.3000604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: rwheeler@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4891C236.3000604@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-07-31 at 09:46 -0400, Ric Wheeler wrote:
> Not sure if this is just an 8-way, multithreaded test, but my run of the 
> latest unstable tree ground to a halt with lock messages (see the 
> attached, compressed log for details ;-))  On the good news side, it did 
> run for around 8 hours before the first message was logged.

I just merged Yan's missing hunks that might help explain this.  At
least for fs_mark, you shouldn't really be hitting the throttling code
very often.

But, until I fully thread the allocator I can't completely get rid of
the stalls.  That's one of the first things on my list for after v0.16

One of your procs is stuck in generic_unplug_device, and that one didn't
come from me ;)  Sounds like the IO subsystem might be taking short
breaks as well.

-chris


