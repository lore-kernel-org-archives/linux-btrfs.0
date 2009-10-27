From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: btrfsck aborts after transid verify failed?
Date: Tue, 27 Oct 2009 23:23:43 +0100
Message-ID: <200910272323.43797.johannes.hirte@fem.tu-ilmenau.de>
References: <4ADF1117.6020903@ubuntu.com> <20091026094104.GG5564@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: John Dong <jdong@ubuntu.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091026094104.GG5564@think>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag 26 Oktober 2009 10:41:04 schrieb Chris Mason:
> > On 10/21/2009 09:44 AM, Yan, Zheng wrote:
> > >On Wed, Oct 21, 2009 at 9:21 PM, John Dong<jdong@ubuntu.com>  wrote:
> > >>>  On Oct 21, 2009, at 3:47 AM, Yan, Zheng wrote:
> > >>>>>  Did you run btrfsck on mounted FS ?
> > >>>>>
> > >>>>>  Yan, Zheng
> > >>>
> > >>>  Yes, I did. I thought it was okay to do so?
> > >
> > >No, btrfs doesn't support that.
> >
> > Whoops! My bad then!
> >
> > BTW, the wiki still says
> >
> > http://btrfs.wiki.kernel.org/index.php/Btrfsck:
> >
> > Do a limited check of the FS extent trees. Can be run on mounted and
> > unmounted FS.
> 
> Thanks!, I've updated the docs.

Will this be added in future or is this feature completely thrown away?
