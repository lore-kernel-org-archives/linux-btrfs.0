From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: Configuring default mount options..
Date: Mon, 26 Jul 2010 02:23:06 +0100
Message-ID: <1280107386.3327.8.camel@hardline>
References: <1280105806.3327.4.camel@hardline>
	 <AANLkTikNemTBWO8ChQ-XYdP4gp=1zKt5EMyzdzLrxgWq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Sebastian 'gonX' Jensen <gonx@overclocked.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikNemTBWO8ChQ-XYdP4gp=1zKt5EMyzdzLrxgWq@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2010-07-26 at 03:10 +0200, Sebastian 'gonX' Jensen wrote:
> On 26 July 2010 02:56, A. James Lewis <james@fsck.co.uk> wrote:
> > If using BTRFS on a removable drive... it may be a problem for example,
> > to always mount with compression, or always mount with encryption (If
> > supported in future)... perhaps btrfstune could define default mount
> > options, such as compression... so if there is a BTRFS filesystem on a
> > removable hard drive, or flash stick, the filesystem can be configured
> > to mount with compression by default.
> >
> > Maybe there is a way to do this already, but it seems like the
> > filesystem itself should contain preferences for the way it is used
> > under those circumstances.
> >
> > A. James Lewis
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> That's actually a good idea. Perhaps an override flag could be
> specified in case you do not wish to use said default mount options?
> 
Indeed, if any mount options are specified they would override
defaults... but if you plug in a removable drive, you there's no way to
specify mount options, but it's quite likley that you would want some,
like compression for example.


> Regards,
> Sebastian J.


