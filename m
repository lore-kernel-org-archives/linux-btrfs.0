Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40408 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752465AbdKCH4n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 03:56:43 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eAWq4-0003Et-Mi
        for linux-btrfs@vger.kernel.org; Fri, 03 Nov 2017 08:56:28 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs seed question
Date: Fri, 3 Nov 2017 08:56:29 +0100
Message-ID: <20171103085629.2f6ea82a@jupiter.sol.kaishome.de>
References: <20171011204759.1848abd7@olive.ig.local>
        <ff596f2f-7232-4ee0-7967-6888236cc831@oracle.com>
        <20171012092028.1fbe79d9@olive.ig.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 12 Oct 2017 09:20:28 -0400
schrieb Joseph Dunn <jdunn14@gmail.com>:

> On Thu, 12 Oct 2017 12:18:01 +0800
> Anand Jain <anand.jain@oracle.com> wrote:
> 
> > On 10/12/2017 08:47 AM, Joseph Dunn wrote:  
> > > After seeing how btrfs seeds work I wondered if it was possible
> > > to push specific files from the seed to the rw device.  I know
> > > that removing the seed device will flush all the contents over to
> > > the rw device, but what about flushing individual files on demand?
> > > 
> > > I found that opening a file, reading the contents, seeking back
> > > to 0, and writing out the contents does what I want, but I was
> > > hoping for a bit less of a hack.
> > > 
> > > Is there maybe an ioctl or something else that might trigger a
> > > similar action?    
> > 
> >    You mean to say - seed-device delete to trigger copy of only the 
> > specified or the modified files only, instead of whole of
> > seed-device ? What's the use case around this ?
> >   
> 
> Not quite.  While the seed device is still connected I would like to
> force some files over to the rw device.  The use case is basically a
> much slower link to a seed device holding significantly more data than
> we currently need.  An example would be a slower iscsi link to the
> seed device and a local rw ssd.  I would like fast access to a
> certain subset of files, likely larger than the memory cache will
> accommodate.  If at a later time I want to discard the image as a
> whole I could unmount the file system or if I want a full local copy
> I could delete the seed-device to sync the fs.  In the mean time I
> would have access to all the files, with some slower (iscsi) and some
> faster (ssd) and the ability to pick which ones are in the faster
> group at the cost of one content transfer.
> 
> I'm not necessarily looking for a new feature addition, just if there
> is some existing call that I can make to push specific files from the
> slow mirror to the fast one.  If I had to push a significant amount of
> metadata that would be fine, but the file contents feeding some
> computations might be large and useful only to certain clients.
> 
> So far I found that I can re-write the file with the same contents and
> thanks to the lack of online dedupe these writes land on the rw mirror
> so later reads to that file should not hit the slower mirror.  By the
> way, if I'm misunderstanding how the read process would work after the
> file push please correct me.
> 
> I hope this makes sense but I'll try to clarify further if you have
> more questions.

You could try to wrap something like bcache ontop of the iscsi device,
then make it a read-mostly cache (like bcache write-around mode). This
probably involves rewriting the iscsi contents to add a bcache header.
You could try mdcache instead.

Then you sacrifice a few gigabytes of local SSD storage of the caching
layer.

I guess that you're sharing the seed device with different machines. As
bcache will add a protective superblock, you may need to thin-clone the
seed image on the source to have independent superblocks per each
bcache instance. Not sure how this applies to mdcache as I never used
it.

But the caching approach is probably the easiest way to go for you. And
it's mostly automatic once deployed: you don't have to manually
choose which files to move to the sprout...


-- 
Regards,
Kai

Replies to list-only preferred.

