Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40816 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751030AbdG0P1b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 11:27:31 -0400
Date: Thu, 27 Jul 2017 17:26:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: prepare for extensions in compression options
Message-ID: <20170727152613.GN2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170717162222.16926-1-dsterba@suse.com>
 <ad1a3fdc-fe64-cf84-ba02-746c3eaa0a3b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ad1a3fdc-fe64-cf84-ba02-746c3eaa0a3b@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 27, 2017 at 03:25:37PM +0800, Anand Jain wrote:
> On 07/18/2017 12:22 AM, David Sterba wrote:
> > This is a minimal patch intended to be backported to older kernels.
> > We're going to extend the string specifying the compression method and
> > this would fail on kernels before that change (the string is compared
> > exactly).
> > 
> > Relax the string matching only to the prefix, ie. ignoring anything that
> > goes after "zlib" or "lzo", regardless of th format extension we decide
> > to use. This applies to the mount options and properties.
> > 
> > That way, patched old kernels could be booted on systems already
> > utilizing the new compression spec.
> 
>   In the view of older kernel with this patch, we need extra logic to
>   continue to fail bad string after lzo..

This would require some validation of the string past 'lzo', which is
intentionally left out of this patch.

>    ----
>          mount -o compress=lzoJUNK /dev/sdb /btrfs
>            mount: wrong fs type, bad option, bad superblock on /dev/sdb,
> 
>            [ 2128.045252] BTRFS error (device sdb): open_ctree failed
>     ----
> 
>    With this patch. I guess the above mount (or for that matter property
>    as well) will be successful. ?

Yes, this will succeed and will behave sanely, lzo will be used.

> > Applicable since commit 63541927c8d11, v3.14.

The patch was not marked for stable so it's up to anybody who wants to
backport it to decide if the relaxed compression algorithm matching is
ok or not.
