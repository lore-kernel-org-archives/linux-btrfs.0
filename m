Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbcDYL7r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 07:59:47 -0400
Date: Mon, 25 Apr 2016 13:59:35 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/4] btrfs-progs: "device ready" accepts just one device
Message-ID: <20160425115935.GE23222@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56E5FF9A.4020609@jp.fujitsu.com>
 <56E6056A.4020307@jp.fujitsu.com>
 <20160314120515.GZ18908@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160314120515.GZ18908@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 01:05:15PM +0100, David Sterba wrote:
> On Mon, Mar 14, 2016 at 09:27:22AM +0900, Satoru Takeuchi wrote:
> > * actual result
> > 
> >   =======================================
> >   # ./btrfs device ready /dev/sdb foo
> >   #
> >   =======================================
> > 
> > * expecting result
> > 
> >   =======================================
> >   # ./btrfs device ready /dev/sdb foo
> >   btrfs device ready: too many arguments
> >   usage: btrfs device ready <device>
> > 
> >       Check device to see if it has all of its devices in cache for mounting
> > 
> >   #
> >   =======================================
> > 
> > Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> > ---
> >  cmds-device.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/cmds-device.c b/cmds-device.c
> > index 33da2ce..23656c3 100644
> > --- a/cmds-device.c
> > +++ b/cmds-device.c
> > @@ -326,7 +326,7 @@ static int cmd_device_ready(int argc, char **argv)
> > 
> >  	clean_args_no_options(argc, argv, cmd_device_ready_usage);
> > 
> > -	if (check_argc_min(argc - optind, 1))
> > +	if (check_argc_exact(argc - optind, 1))
> 
> This silently changes the semantics, so far it accepts multiple values
> though it contradicts the documentation. I'm not yet sure how to resolve
> that.

More than one argument did not work before, so I think it's ok to expect
just one device. Applied.
