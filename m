From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Sun, 10 Jul 2011 19:37:28 +0100
Message-ID: <20110710183728.GB4277@yahoo.fr>
References: <20110703190913.GA4474@yahoo.fr>
 <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
 <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
 <20110709170959.GC4294@yahoo.fr>
 <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com>
 <20110709203649.GE4294@yahoo.fr>
 <1310301809-sup-9903@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310301809-sup-9903@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-10 08:44:34 -0400, Chris Mason:
[...]
> Great, we're on the right track.  Does it trigger with mount -o compress
> instead of mount -o compress_force?
[...]

It does trigger. I get that same "invalid opcode".

BTW, I tried with CONFIG_SLUB and slub_debug and no more useful
information than with SLAB_DEBUG.

I'm trying now without dmcrypt. Then I won't have much bandwidth
for testing.

-- 
Stephane
