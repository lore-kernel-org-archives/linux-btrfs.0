From: Roberto Ragusa <mail@robertoragusa.it>
Subject: Re: Number of hard links limit
Date: Sun, 08 Aug 2010 14:32:43 +0200
Message-ID: <4C5EA3EB.802@robertoragusa.it>
References: <20100802114046.GA29926@lh.kyla.fi> <20100802130556.GF30325@jeru.org> <4ad406cb8ee6c52747b67b4c79a6d7dd@smtp.arbitraryconstant.com> <20100802215647.7466601d@simplux> <4C572DDC.5050108@robertoragusa.it> <0362zshcyx.fsf@msgid.viggen.net> <20100806113039.GA18858@lh.kyla.fi> <20100806134607.GB19942@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100806134607.GB19942@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:

> Right, this will get fixed in a future btrfs update.  We're focusing on
> stability with what we have right now, but I do agree we should have
> done this link back reference design differently.

I think people are complaining about this (apparently not too urgent)
limitation, because if the on-disk format has to be changed, it is better
to think about it as soon as possible, before back-compatibility becomes
an issue.

-- 
   Roberto Ragusa    mail at robertoragusa.it
