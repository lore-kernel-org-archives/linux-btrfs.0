Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0060.outbound.protection.outlook.com ([104.47.116.60]:51260
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932887AbeFRMYW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 08:24:22 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Hugo Mills <hugo@carfax.org.uk>, "dsterba@suse.cz" <dsterba@suse.cz>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: About more loose parameter sequence requirement
Date: Mon, 18 Jun 2018 12:24:18 +0000
Message-ID: <MEXPR01MB12088B720883C928502986C39E710@MEXPR01MB1208.ausprd01.prod.outlook.com>
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz> <20180618114408.GB28972@carfax.org.uk>
In-Reply-To: <20180618114408.GB28972@carfax.org.uk>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org <linux-btrfs-
> owner@vger.kernel.org> On Behalf Of Hugo Mills
> Sent: Monday, 18 June 2018 9:44 PM
> To: dsterba@suse.cz; Qu Wenruo <quwenruo.btrfs@gmx.com>; linux-
> btrfs@vger.kernel.org
> Subject: Re: About more loose parameter sequence requirement
> 
> On Mon, Jun 18, 2018 at 01:34:32PM +0200, David Sterba wrote:
> > On Thu, Jun 14, 2018 at 03:17:45PM +0800, Qu Wenruo wrote:
> > > I understand that btrfs-progs introduced restrict parameter/option
> > > order to distinguish global and sub-command parameter/option.
> > >
> > > However it's really annoying if one just want to append some new
> > > options to previous command:
> > >
> > > E.g.
> > > # btrfs check /dev/data/btrfs
> > > # !! --check-data-csum
> > >
> > > The last command will fail as current btrfs-progs doesn't allow any
> > > option after parameter.
> > >
> > >
> > > Despite the requirement to distinguish global and subcommand
> > > option/parameter, is there any other requirement for such restrict
> > > option-first-parameter-last policy?
> >
> > I'd say that it's a common and recommended pattern. Getopt is able to
> > reorder the parameters so mixed options and non-options are accepted,
> > unless POSIXLY_CORRECT (see man getopt(3)) is not set. With the more
> > strict requirement, 'btrfs' option parser works the same regardless of
> > that.
> 
>    I got bitten by this the other day. I put an option flag at the end of the line,
> after the mountpoint, and it refused to work.
> 
>    I would definitely prefer it if it parsed options in any position. (Or at least,
> any position after the group/command parameters).


Same with me - I do it all the time. I type the arguments as I think of them, which is usually back-to-front of what is required.
Eg. Btrfs check this mountpoint, oh yeah, and use this specific option = fail.
Arrow arrow arrow arrow arrow....


Paul.
