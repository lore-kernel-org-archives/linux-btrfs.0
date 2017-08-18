Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26875 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750913AbdHRSCy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 14:02:54 -0400
Date: Fri, 18 Aug 2017 10:59:39 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: kreijack@inwind.it
Cc: Josef Bacik <josef@toxicpanda.com>,
        Paulo Dias <paulo.miguel.dias@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
Message-ID: <20170818175939.GA25986@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
 <20170817233916.GA25527@destiny>
 <ceb36a9a-b73f-96c1-cb58-24f149b24001@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ceb36a9a-b73f-96c1-cb58-24f149b24001@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 06:23:18PM +0200, Goffredo Baroncelli wrote:
> On 08/18/2017 01:39 AM, Josef Bacik wrote:
> [...]
> > This is happening because the app (the guest OS in this case, we saw this a lot
> > with windows guests) is changing the pages while they are in flight.  We
> > calculate the checksum of the page before it's written, so if it changes while
> > in flight we'll end up with a csum mismatch.
> > 
> > To fix this change kvm to not use O_DIRECT or set NODATASUM on your qcow2 image.
> > You'll have to re-create the image because NODATASUM won't apply to the already
> > invalid checksums.  Thanks,
> 
> Hi Josef,
> 
> could you elaborate: do you are saying that using O_DIRECT is incompatible with DATASUM ?
>

They're compatible, but applications need to be careful.

O_DIRECT takes userspace page, and it works like
DIO write
  p = get_user_page();
  add p to bio
  #btrfs submits this bio
  calc_checksum(bio);
  submit_bio();

There's a chance that page p got changed between calc_checksum() and
submit_bio(), which then causes the mismatch.

For buffered IO, dirty page cache pages is synchronized with page
fault by page lock and page writeback bit.

thanks,
-liubo
