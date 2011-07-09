From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Sat, 9 Jul 2011 18:11:47 +0100
Message-ID: <20110709171147.GD4294@yahoo.fr>
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
> How easily can you recompile your kernel with more debugging flags?
> That should help narrow it down.  I'm looking for CONFIG_SLAB_DEBUG (or
> slub) and CONFIG_DEBUG_PAGEALLOC
[...]

I tried that (with CONFIG_DEBUG_SLAB_LEAK as well) but no
difference whatsoever

-- 
Stephane
