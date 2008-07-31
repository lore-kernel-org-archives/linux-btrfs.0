From: Chris Mason <chris.mason@oracle.com>
Subject: Re: still see locking issues...
Date: Thu, 31 Jul 2008 10:37:59 -0400
Message-ID: <1217515079.20239.49.camel@think.oraclecorp.com>
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

It also looks like writeback is getting stuck waiting for locked pages
that are waiting for the transaction lock.  I've changed around the
start_transaction code a bit to help with this, and I'll test a bit and
send out.

-chris


