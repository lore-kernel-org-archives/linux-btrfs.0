From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New data=ordered code pushed out to btrfs-unstable
Date: Fri, 18 Jul 2008 20:45:31 -0400
Message-ID: <1216428331.6932.82.camel@think.oraclecorp.com>
References: <1216398992.6932.36.camel@think.oraclecorp.com>
	 <4880F87B.7020908@gmail.com>
	 <1216411969.6932.70.camel@think.oraclecorp.com>
	 <48811ABF.5010606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48811ABF.5010606@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-07-18 at 18:35 -0400, Ric Wheeler wrote:
> Chris Mason wrote:
> > On Fri, 2008-07-18 at 16:09 -0400, Ric Wheeler wrote:
> > 
> >> Just to kick the tires, I tried the same test that I ran last week on 
> >> ext4. Everything was going great, I decided to kill it after 6 million 
> >> files or so and restart.

Well, it looks like I neglected to push all the changesets, especially
the last one that made it less racey.  So, I've just done another push,
sorry.  For the fs_mark workload, it shouldn't change anything.

This code still hasn't really survived an overnight run, hopefully this
commit will.

-chris


