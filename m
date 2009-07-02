From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Latest tree?
Date: Thu, 2 Jul 2009 12:24:48 -0400
Message-ID: <20090702162448.GF9498@think>
References: <4A4CDC43.2020300@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A4CDC43.2020300@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 02, 2009 at 11:11:47AM -0500, Steven Pratt wrote:
> What is the latest experimental tree to pull from?  We had an  
> experimental branch, plus the newformat and newformat2 branches.  Which  
> has the very latest stuff?

Right now the master branch and the newformat2 branch are the same.  The
master branch is what I ask Linus to pull from and the newformat2 branch
is the dedicated backport of all the critical newformat fixes against
2.6.30.

There's one bug in both branches around the nodatacow and nodatasum
modes (both are ignored).  I plan on pushing that out today.

-chris
