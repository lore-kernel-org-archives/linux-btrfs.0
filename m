Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46106 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753574AbdJKRz7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 13:55:59 -0400
Date: Wed, 11 Oct 2017 10:54:19 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: do not add stale device into fs_devices
Message-ID: <20171011165419.GB16979@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20171011002852.2926-1-bo.li.liu@oracle.com>
 <f56dc49b-817b-6655-2215-5bf1552c9d3d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f56dc49b-817b-6655-2215-5bf1552c9d3d@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 11, 2017 at 12:33:15PM +0300, Nikolay Borisov wrote:
> 
> 
> On 11.10.2017 03:28, Liu Bo wrote:
> > If one of btrfs's devices was pulled out and we've replaced it with a
> > new one, then they have the same uuid.
> > 
> > If that device gets reconnected, 'btrfs filesystem show' will show the
> > stale one instead of the new one, but on kernel side btrfs has a fix
> > to not include the stale one, this could confuse users as people may
> > monitor btrfs by running that cli.
> > 
> > This does the similar thing to what kernel side has done.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  volumes.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/volumes.c b/volumes.c
> > index 2f3943d..c7b7a41 100644
> > --- a/volumes.c
> > +++ b/volumes.c
> > @@ -138,7 +138,20 @@ static int device_list_add(const char *path,
> >  		list_add(&device->dev_list, &fs_devices->devices);
> >  		device->fs_devices = fs_devices;
> >  	} else if (!device->name || strcmp(device->name, path)) {
> > -		char *name = strdup(path);
> > +		char *name;
> > +
> > +		/*
> > +		 * The existing device has newer generation, so this
> > +		 * one could be a stale one, don't add it.
> > +		 */
> > +		if (found_transid < device->generation) {
> > +			warning("adding device %s gen %llu but found a existing device %s gen %llu\n",
> > +				path, found_transid, device->name,
> > +				device->generation, found_transid);
> 
> You pass in 5 parameters but have only 4 formatting strings. I don't see
> the same happening on other warning() invocations? Perhaps the last
> found_transid is not necessary?
> 

Oh, thanks for the comments.

I messed it up again, what I was testing is warning("blabla",
device->name, device->generation, path, found_transid), but later I
updated the message but got the parameters wrong.

Will do a v2.

Thanks,

-liubo
> > +			return -EEXIST;
> > +		}
> > +
> > +		name = strdup(path);
> >                  if (!name)
> >                          return -ENOMEM;
> >                  kfree(device->name);
> > 
