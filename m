From: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Subject: Re: Data De-duplication
Date: Thu, 11 Dec 2008 09:58:46 +0000
Message-ID: <1228989526.17969.17.camel@mattos-laptop>
References: <1228862899.8130.1.camel@mattos-laptop>
	 <1228915802.11900.8.camel@think.oraclecorp.com>
	 <32809.2001:470:e828:1::2:2.1228939660.squirrel@avalon.arbitraryconstant.com>
	 <1228943437.7571.1.camel@mattos-laptop>
	 <20081210211903.GA29002@bludgeon.org>
	 <1228945336.7571.26.camel@mattos-laptop>
	 <20081210215754.GT23979@tracyreed.org>
	 <20081210221006.GA30484@bludgeon.org>
	 <1228954691.7571.33.camel@mattos-laptop>
	 <1228966979.7571.48.camel@mattos-laptop>
	 <20081211035052.GA3917@bludgeon.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Tracy Reed <treed@tracyreed.org>,
	<btrfs-devel@arbitraryconstant.com>,
	Chris Mason <chris.mason@oracle.com>
To: Ray Van Dolson <rayvd@bludgeon.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081211035052.GA3917@bludgeon.org>
List-ID: <linux-btrfs.vger.kernel.org>

> Neat.  Thanks much.  It'd be cool to output the results of each of your
> hashes to a database so you can get a feel for how many duplicate
> blocks there are cross-files as well.
> 
> I'd like to run this in a similar setup on all my VMware VMDK files and
> get an idea of how much space savings there would be across 20+ Windows
> 2003 VMDK files... probably *lots* of common blocks.
> 
> Ray
Hi,

Currently it DOES do cross file block matching - thats why it takes sooo
long to run :-)

If you remove everything after the word "sort", it will make a verbose
output, which you could then stick into some SQL database if you wanted.
You could relativey easily format the output into a format for direct
input to an SQL database if you modified the line with the "dd" in it
within the first while.  You can also remove the "sort" and the pipe
before it to get an unsorted output - the advantage of this is it takes
less time.

I'm guessing that if you had the time to run this on multi-gigabyte disk
images you'd find that as much as 80% of the blocks are duplicated
between any two virtual machines of the same operating system.

That means if you have 20 Win 2k3 VM's and the first VM image of Windows
+ software is 2GB (after nulls are removed), the total size for 20VM's
could be ~6GB (remembering there will be extra redundancy the more VM's
you add)- not a bad saving.

Thanks
Oliver

