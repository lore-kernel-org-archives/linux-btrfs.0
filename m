From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
Date: Mon, 19 Sep 2011 18:55:13 -0400
Message-ID: <1316472864-sup-500@shiny>
References: <20110916154815.GA27150@infradead.org> <4E7439EB.7080100@oracle.com> <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca> <20110918014608.GA16198@alboin.amr.corp.intel.com> <4E759DE5.3020907@oracle.com> <4E75AEFD.105@gmail.com> <8444301C-856F-44FA-94A3-D3583DFA0FFB@oracle.com> <1316357705-sup-2667@shiny> <20110919175203.GK7761@one.firstfloor.org> <1316460509-sup-1132@shiny> <20110919195952.GL7761@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Cc: Jeff liu <jeff.liu@oracle.com>,
	Marco Stornelli <marco.stornelli@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@infradead.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110919195952.GL7761@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andi Kleen's message of 2011-09-19 15:59:52 -0400:
> On Mon, Sep 19, 2011 at 03:30:02PM -0400, Chris Mason wrote:
> > Excerpts from Andi Kleen's message of 2011-09-19 13:52:03 -0400:
> > > > Thanks everyone, I've put Jeff's last version of this in my queue.
> > > 
> > > Can you post the version you merged? The previous ones all had issues.
> > 
> > https://github.com/chrismason/linux/commit/48802c8ae2a9d618ec734a61283d645ad527e06c
> > 
> > This was the last one sent, I thought it combined all the fixes.
> 
> Ok looks good, but it will be all obsolete once my patchkit lseek
> get in (except for the SEEK_DATA/HOLE hunk)

Yeah, it's similar to yours except for the hole hunk.  Your gotos are
fine by me, whatever makes your patch cleaner.

-chris
