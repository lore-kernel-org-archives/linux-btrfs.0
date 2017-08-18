Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:38174 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdHRRn7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 13:43:59 -0400
Received: by mail-qt0-f180.google.com with SMTP id t37so57309155qtg.5
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 10:43:59 -0700 (PDT)
Date: Fri, 18 Aug 2017 13:43:57 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: kreijack@inwind.it
Cc: Josef Bacik <josef@toxicpanda.com>,
        Paulo Dias <paulo.miguel.dias@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
Message-ID: <20170818174356.GA1526@destiny>
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

No, I'm saying using O_DIRECT with applications that don't protect in-flight
memory are incompatible with DATASUM.  We have no way of making sure nobody
touches the page while we're writing it out, so after we calculate the checksum
any changes to the page are going to cause a checksum mismatch.  O_DIRECT are
user space pages, there's nothing we can do to stop user space from doing stupid
things.

The options I looked into before were things like detecting the page had changed
since we calculated the checksum, and re-submitting the write.  This punishes
applications that do the right thing (databases for example) by forcing us to
calculate checksums twice.

This is a shit situation because users aren't going to understand this
limitation, and it bites them in the ass with all these weird errors.  I think
maybe we need to go back to the double-checksum thing by default, and have a
flag or something for users to set if they know their application behaves
properly.  Thanks,

Josef
