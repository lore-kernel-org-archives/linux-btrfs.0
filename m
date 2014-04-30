Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964791AbaD3Lwf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 07:52:35 -0400
Date: Wed, 30 Apr 2014 13:52:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 07/14] btrfs-progs: Print more info about device sizes
Message-ID: <20140430115233.GH5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1398786620.git.dsterba@suse.cz>
 <cfc78e5581e0142caf9a5fe049213c8e5de90efa.1398786620.git.dsterba@suse.cz>
 <CAMU1PDj3CwYJgiGG27cR+XgZvRFLxY8sAQocRavi8oT9-2Kz+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMU1PDj3CwYJgiGG27cR+XgZvRFLxY8sAQocRavi8oT9-2Kz+Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 29, 2014 at 08:23:08PM +0100, Mike Fleetwood wrote:
> > /dev/sda7, ID: 3
> >    Device size:            10.00GiB
> >    FS occuppied:            5.00GiB
> 
> Spelling mistake.  s/occuppied/occupied/.

> > +void print_device_sizes(int fd, struct device_info *devinfo, int mode)
> > +{
> > +       printf("   Device size: %*s%10s\n",
> > +               (int)(20 - strlen("Device size")), "",
> > +               df_pretty_sizes(devinfo->device_size, mode));
> > +       printf("   FS occuppied:%*s%10s\n",
> 
> Here too.  s/occuppied/occupied/.
> 
> > +               (int)(20 - strlen("FS occupied")), "",
> > +               df_pretty_sizes(devinfo->size, mode));
> > +       }
> >  }
> 
> Same spelling mistake (occuppied) also occurs in the following patches too:
>  [PATCH 08/14] btrfs-progs: compare unallocated space against the correct value
>  [PATCH 12/14] btrfs-progs: replace df_pretty_sizes with pretty_size_mode

Thanks for catching it.

