From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfsck aborts after transid verify failed?
Date: Mon, 2 Nov 2009 16:44:05 -0500
Message-ID: <20091102214405.GF4560@think>
References: <4ADF1117.6020903@ubuntu.com>
 <20091026094104.GG5564@think>
 <200910272323.43797.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: John Dong <jdong@ubuntu.com>, linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910272323.43797.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 27, 2009 at 11:23:43PM +0100, Johannes Hirte wrote:
> Am Montag 26 Oktober 2009 10:41:04 schrieb Chris Mason:
> > > On 10/21/2009 09:44 AM, Yan, Zheng wrote:
> > > >On Wed, Oct 21, 2009 at 9:21 PM, John Dong<jdong@ubuntu.com>  wrote:
> > > >>>  On Oct 21, 2009, at 3:47 AM, Yan, Zheng wrote:
> > > >>>>>  Did you run btrfsck on mounted FS ?
> > > >>>>>
> > > >>>>>  Yan, Zheng
> > > >>>
> > > >>>  Yes, I did. I thought it was okay to do so?
> > > >
> > > >No, btrfs doesn't support that.
> > >
> > > Whoops! My bad then!
> > >
> > > BTW, the wiki still says
> > >
> > > http://btrfs.wiki.kernel.org/index.php/Btrfsck:
> > >
> > > Do a limited check of the FS extent trees. Can be run on mounted and
> > > unmounted FS.
> > 
> > Thanks!, I've updated the docs.
> 
> Will this be added in future or is this feature completely thrown away?

It is definitely on the list to be added in the future.  Online fsck is
a big part of my plans for keeping btrfs usable in the long term.

-chris

