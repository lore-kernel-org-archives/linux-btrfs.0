From: Marc MERLIN <marc@merlins.org>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache off?
Date: Sun, 12 Feb 2012 16:14:00 -0800
Message-ID: <20120213001400.GD31989@merlins.org>
References: <20120130003754.GD4380@merlins.org> <20120201175624.GE16796@shiny> <20120202032345.GB31903@merlins.org> <20120202124241.GW16796@shiny> <20120202152722.GI12429@merlins.org> <20120130003754.GD4380@merlins.org> <20120201175624.GE16796@shiny> <20120202032345.GB31903@merlins.org> <20120212223242.GA31989@merlins.org> <4F384FAA.5060506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	jeff@deserettechnology.com
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F384FAA.5060506@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2012 at 12:47:54AM +0100, Milan Broz wrote:
> On 02/12/2012 11:32 PM, Marc MERLIN wrote:
> >Actually I had one more question.
> >
> >I read this page:
> >http://www.redhat.com/archives/dm-devel/2011-July/msg00042.html
> >
> >I'm not super clear if with 3.2.5 kernel, I need to pass the special
> >allow_discards option for brtfs and dm-crypt to be safe together, or 
> >whether
> >they now talk through an API and everything "just works" :)
> 
> If you want discards to be supported in dmcrypt, you have to enable it 
> manually.
> 
> The most comfortable way is just use recent cryptsetup and add
> --allow-discards option to luksOpen command.
> 
> It will be never enabled by default in dmcrypt for security reasons
> http://asalor.blogspot.com/2011/08/trim-dm-crypt-problems.html

Thanks for the answer.
I knew that it created some security problems but I had not yet found the
page you just gave, which effectively states that TRIM isn't actually that
big a win on recent SSDs (I thought it was actually pretty important to use
it on them until now).

Considering that I have a fairly new crucial 256GB SDD, I'm going to assume
that this bit applies to me:
"On the other side, TRIM is usually overrated. Drive itself should keep good
performance even without TRIM, either by using internal garbage collecting
process or by some area reserved for optimal writes handling."

So it sounds like I should just not give the "ssd" mount option to btrfs,
and not worry about TRIM. 
My main concern was to make sure I wasn't risking corruption with btrfs on
top of dm-crypt, which is now true with 3.2.x, and I now understand that it
is true regardless of whether I use --allow-discards in cryptsetup, so I'm
just not going to use it given the warning page you just posted.

Thanks for the answer.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
