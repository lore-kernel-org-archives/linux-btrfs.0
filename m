From: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Subject: Re: Data De-duplication
Date: Thu, 11 Dec 2008 00:18:11 +0000
Message-ID: <1228954691.7571.33.camel@mattos-laptop>
References: <1228862899.8130.1.camel@mattos-laptop>
	 <1228915802.11900.8.camel@think.oraclecorp.com>
	 <32809.2001:470:e828:1::2:2.1228939660.squirrel@avalon.arbitraryconstant.com>
	 <1228943437.7571.1.camel@mattos-laptop>
	 <20081210211903.GA29002@bludgeon.org>
	 <1228945336.7571.26.camel@mattos-laptop>
	 <20081210215754.GT23979@tracyreed.org>
	 <20081210221006.GA30484@bludgeon.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Tracy Reed <treed@tracyreed.org>,
	<btrfs-devel@arbitraryconstant.com>,
	Chris Mason <chris.mason@oracle.com>,
	<linux-btrfs@vger.kernel.org>
To: Ray Van Dolson <rayvd@bludgeon.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081210221006.GA30484@bludgeon.org>
List-ID: <linux-btrfs.vger.kernel.org>


> It would be interesting to see how many duplicate *blocks* there are
> across the filesystem, agnostic to files...
> 
> Is this somthing your script does Oliver?

My script doesn't yet exist, although when created it would, yes.  I was
thinking of just making a BASH script and using dd to extract 512 byte
chunks of files, pipe through md5sum and save the result in a large
index file.  Next just iterate through the index file looking for
duplicate hashes.

In fact that sounds so easy I might do it right now...  (only to proof
of concept stage - a real utility would probably want to be written in a
compiled language and use proper trees for faster searching)

