From: David Sterba <dave@jikos.cz>
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
Date: Wed, 25 Jan 2012 12:30:48 +0100
Message-ID: <20120125113048.GL7322@twin.jikos.cz>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <20120117090746.GD7322@twin.jikos.cz> <loom.20120118T155934-197@post.gmane.org> <loom.20120124T180109-491@post.gmane.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Hugo Chevrain <hugochevrain@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120124T180109-491@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2012 at 05:03:16PM +0000, Hugo Chevrain wrote:
> > evergreen writes:
> > > 
> > 
> > Although there is LessFS's Mark Ruijter :
> > http://www.lessfs.com/wordpress/?p=684&cpage=1#comment-3114
> > 
> > "On average the speeds appear to be 48% faster then snappy."
> > Sounds promising...
> > 
> > --
> 
> Well, it seems that the performance is really good.
> Apparently, LZ4 has displaced Snappy as speed champion for LessFS.
> 
> http://www.lessfs.com/wordpress/?p=688

I'm preparing a LZ4 on top of Chris' snappy branch to have some testbed
for comparing and benchmarking. I'll send it to list after a few tests.


david
