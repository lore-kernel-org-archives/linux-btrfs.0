From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Fri, 8 Jul 2011 17:57:59 +0100
Message-ID: <20110708165759.GE4284@yahoo.fr>
References: <20110703190913.GA4474@yahoo.fr>
 <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
 <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
 <20110708154123.GA17886@yahoo.fr>
 <20110708161103.GD4284@yahoo.fr>
 <1310141768-sup-424@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310141768-sup-424@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-08 12:17:54 -0400, Chris Mason:
[...]
> > Jun  5 00:58:10  BUG: Bad page state in process rsync  pfn:1bfdf
> > Jun  5 00:58:10  page:ffffea000061f8c8 count:0 mapcount:0 mapping:          (null) index:0x2300
> > Jun  5 00:58:10  page flags: 0x100000000000010(dirty)
> > Jun  5 00:58:10  Pid: 1584, comm: rsync Tainted: G      D  C  2.6.38-7-server #35-Ubuntu
> > Jun  5 00:58:10  Call Trace:
> 
> Ok, this one is really interesting.  Did you get this after another oops
> or was it after a reboot?
> 

After the oops above (a few hours after though). The two reports
were together with nothing inbetween in the kern.log.

That was the only occurrence though.

> How easily can you recompile your kernel with more debugging flags?
> That should help narrow it down.  I'm looking for CONFIG_SLAB_DEBUG (or
> slub) and CONFIG_DEBUG_PAGEALLOC
[...]

I can try next week.

-- 
Stephane
