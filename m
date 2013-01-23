Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3AWNXt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 08:23:49 -0500
Date: Wed, 23 Jan 2013 14:23:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Pavel Vasilyev <ml@yekm.name>
Cc: Calvin Walton <calvin.walton@kepstin.ca>, linux-btrfs@vger.kernel.org
Subject: Re: Simple btrfs use case
Message-ID: <20130123132347.GH28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAFCsa79Cn65gUFKT9RmCYG1WjP257n+iy0zGh_-vaX4Pc_grVA@mail.gmail.com>
 <1358867297.5681.23.camel@cwalton-XPS-8300>
 <CAFCsa79DrFA18FAApJHXazAwmb2YRWwfKsGQzn_3C36-diGhcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFCsa79DrFA18FAApJHXazAwmb2YRWwfKsGQzn_3C36-diGhcQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 07:29:47PM +0400, Pavel Vasilyev wrote:
> > In "single" data mode, btrfs makes no special attempt to keep files
> > together on the same disk, but if a file is written linearly and never
> > modified there's a chance it might happen. (Each modification will COW
> > the file, putting the modified portion on a random disk.)
> >
> > As a result, yes, you may lose a substantial number - even most - of
> > your files if one disk dies while in single data mode.
> 
> So, on highly fragmented fs reliability in single data mode is near to raid0?
> Rhetorical question, actually.

Correct. The difference against 'single' is that it does not spread the
data by default, depends on actual data layout and is unpredictable in
most cases.

> > The failure mode you are describing would be interesting, and people
> > talk about it now and then, but there is no current support in btrfs for
> > it.
> 
> Is there any plans to support it?

I've added a project to the wiki, if that counts :)

david
