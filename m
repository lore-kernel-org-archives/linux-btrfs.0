From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Sat, 9 Jul 2011 18:09:59 +0100
Message-ID: <20110709170959.GC4294@yahoo.fr>
References: <20110703190913.GA4474@yahoo.fr>
 <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
 <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310137241-sup-8158@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-08 11:06:08 -0400, Chris Mason:
[...]
> I would do two things.  First, I'd turn off compress_force.  There's no
> explicit reason for this, it just seems like the mostly likely place for
> a bug.
[...]

I couldn't reproduce it with compress_force turned off, the
inode_cache reached 600MB but never stayed high.

Not using compress_force is not an option for me though
unfortunately.

-- 
Stephane
