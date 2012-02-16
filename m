From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Premature ENOSPC only with zlib Compression
Date: Thu, 16 Feb 2012 12:55:36 -0500
Message-ID: <20120216175536.GL21896@shiny>
References: <CAKcLGm--EKeAbw7JzBtv7snhXEJSzTMZjn9_QDT+jGRCWsjM2g@mail.gmail.com>
 <CAFDW0jLfLtEpnijsratvGho8RzC9D7nJD8H2y0SdZ6AxYeGpYw@mail.gmail.com>
 <201202162131.38463.chris@csamuel.org>
 <CAFDW0jJgNxNXJHiJxur+QaPAioyAyZ+-ftnTtZ2rR69Tqy0bfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAFDW0jJgNxNXJHiJxur+QaPAioyAyZ+-ftnTtZ2rR69Tqy0bfw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 16, 2012 at 04:05:40PM +0100, Ahmet Inan wrote:
> On Thu, Feb 16, 2012 at 11:31 AM, Chris Samuel <chris@csamuel.org> wrote:
> > On Thursday 16 February 2012 19:06:52 Ahmet Inan wrote:
> >
> >> and got ENOSPC again :(
> >>
> >> so it doesnt matter if lzo or zlib: ENOSPC with compression
> >> enabled!
> >>
> >> my kernel: vanilla 3.2.5
> >
> > I know that there has been an ENOSPC fix go in to the 3.3 RC kernels
> > since the 3.2 release, any chance you'd be able to see if it still
> > happens with the current 3.3 RC ?
> 
> just tested 3.3.0-rc3, and it works like a charm!
> 
> but there are lots of issues with external packages not compiling with 3.3,
> why i wont be able to deploy it to our systems here yet.
> 
> could this one bugfix be backported to 3.2?

All of the btrfs patches in 3.3-rc are against 3.2 in my git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus


> 
> here are some results from my unsquashfs'ing just to show how
> awesome btrfs with lzo is. these results are _not_ from an ssd btw!
> (spinning disks, rebooted between tests)

Very nice ;)

-chris
