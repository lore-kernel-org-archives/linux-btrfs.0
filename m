From: Ray Van Dolson <rayvd@bludgeon.org>
Subject: Re: Data De-duplication
Date: Wed, 10 Dec 2008 19:50:52 -0800
Message-ID: <20081211035052.GA3917@bludgeon.org>
References: <1228862899.8130.1.camel@mattos-laptop> <1228915802.11900.8.camel@think.oraclecorp.com> <32809.2001:470:e828:1::2:2.1228939660.squirrel@avalon.arbitraryconstant.com> <1228943437.7571.1.camel@mattos-laptop> <20081210211903.GA29002@bludgeon.org> <1228945336.7571.26.camel@mattos-laptop> <20081210215754.GT23979@tracyreed.org> <20081210221006.GA30484@bludgeon.org> <1228954691.7571.33.camel@mattos-laptop> <1228966979.7571.48.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Tracy Reed <treed@tracyreed.org>,
	btrfs-devel@arbitraryconstant.com,
	Chris Mason <chris.mason@oracle.com>
To: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228966979.7571.48.camel@mattos-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 11, 2008 at 03:42:58AM +0000, Oliver Mattos wrote:
> Here is a script to locate duplicate data WITHIN files:
> 
> On some test file sets of binary data with no duplicated files, about 3%
> of the data blocks were duplicated, and about 0.1% of the data blocks
> were nulls.  The data was mainly elf and win32 binaries plus some random
> game data, office documents and a few images.
> 
> This code is hideously slow, so don't give it more than a couple of MB
> of files to chew through at once.  In retrospect I should've just
> written it in plain fast C instead of fighting with bash pipes!
> 
> Note to get "verbose" output, just remove everything after the word
> "sort" in the code.

Neat.  Thanks much.  It'd be cool to output the results of each of your
hashes to a database so you can get a feel for how many duplicate
blocks there are cross-files as well.

I'd like to run this in a similar setup on all my VMware VMDK files and
get an idea of how much space savings there would be across 20+ Windows
2003 VMDK files... probably *lots* of common blocks.

Ray
