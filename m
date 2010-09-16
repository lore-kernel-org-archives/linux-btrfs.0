From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH] Add the "btrfs filesystem label" command
Date: Thu, 16 Sep 2010 20:00:08 +0200
Message-ID: <201009162000.08643.kreijack@inwind.it>
References: <201009132124.14402.kreijack@inwind.it> <AANLkTik85y4fbyhqw0DqV9x7TsVwo5uZZhLBHiy-oPsC@mail.gmail.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik85y4fbyhqw0DqV9x7TsVwo5uZZhLBHiy-oPsC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, 16 September, 2010, Mike Fedyk wrote:
> On Mon, Sep 13, 2010 at 12:24 PM, Goffredo Baroncelli
> <kreijack@gmail.com> wrote:
[...]
> > +
> > +       if(ret != 0)
> > +       {
> > +              fprintf(stderr, "FATAL: the filesystem has to be
> > unmounted\n");
> > +              return -2;
> > +       }
> > +       get_label_unmounted(btrfs_dev);
> > +       return 0;
> > +}
> > +
> > +
> 
> Why can't the label be read while the fs is mounted?  It shouldn't
> hurt anything.  I can read the superblock on my ext3 fs while it's
> mounted...  This is what people have come to expect.

The main reason is that if a filesystem is mounted, the data read from 
userspace may be outdated by the internal data.

In the original patch (the one of Morey Roof), there was a kernel space code 
that handled this case. In order to simplify the patch I split the code in two 
step the user space and the kernel space.

This is the user space portion, and because it has to work without the kernel 
space portion, when it is required the code fail explicitly.

I hope to publish the 2nd patch during the next weeks.

Regards
G.Baroncelli

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
