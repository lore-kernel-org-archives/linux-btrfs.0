From: jim owens <jowens@hp.com>
Subject: Re: Btrfs conf call
Date: Wed, 13 Aug 2008 16:22:52 -0400
Message-ID: <48A3429C.5040000@hp.com>
References: <1218645196.15342.363.camel@think.oraclecorp.com> <48A31DEA.5090903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Morey Roof <moreyroof@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48A31DEA.5090903@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Morey Roof wrote:
> Could someone write a quick recap of this for those of us who are 
> interested and happened to miss it?

Everyone on the call seems to be waiting for someone else
to respond.  I'll do it just to make up for dedup :)

- Chris said he saw major performance problems from pdflush
   and he is currently working on a btrfs thread to fix this.

- Eric has been testing v0.16 single-stream-write performance
   and is seeing kswapd issues (also part of Chris's fix)
   and will take Chris's code as soon as it is ready.

- Josef is rewriting the in-memory extent allocator to make
   it perform much better and will also fix multithreading.

- Ming Ming and Chris will try to arrange a general
   breakout session for all filesystems at the plumber's
   conference in september. (Chris is presenting a talk
   on btrfs at the conference)

- I listened and contributed only this synopsis.

jim
