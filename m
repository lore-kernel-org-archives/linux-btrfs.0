Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41586 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751413AbdG0PiM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 11:38:12 -0400
Date: Thu, 27 Jul 2017 17:36:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
        Roman Mamedov <rm@romanrm.net>,
        Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: add skeleton code for compression heuristic
Message-ID: <20170727153653.GO2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170717135258.15865-1-nefelim4ag@gmail.com>
 <20170717183035.GR2866@twin.jikos.cz>
 <f85d6fa7-4d1e-bfb8-7e64-ef02c468e42d@oracle.com>
 <20170721233749.5175d611@natsu>
 <20170721210027.3qoexc63zcbbnqxl@angband.pl>
 <20170724145356.GX2866@twin.jikos.cz>
 <950a249d-9fb2-103a-0101-d37e6609ba8f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <950a249d-9fb2-103a-0101-d37e6609ba8f@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 11:40:17PM +0800, Anand Jain wrote:
> 
> > Eg. files that are already compressed would increase the cpu consumption
> > with compress-force, while they'd be hopefully detected as
> > incompressible with 'compress' and clever heuristics. So the NOCOMPRESS
> > bit would better reflect the status of the file.
> 
>   current NOCOMPRESS is based on trial and error method and is more
>   accurate than heuristic also loss of cpu power is only one time ?

Curreently, force-compress beats everything, so even a file with
NOCOMPRESS will be compressed, all new writes will be passed to the
compression and stored uncompressed eventually. Each time the
compression code will run and fail, so it's not one time.

Although you can say it's more 'accurate', it's also more expensive.

>   May be the only opportunity that heuristic can facilitate is at the
>   logic to monitor and reset the NOCOMPRESS, as of now there is no
>   such a logic.

The heurictic can be made adaptive, and examine data even for NOCOMPRESS
files, but that's a few steps ahead of where we are now.
