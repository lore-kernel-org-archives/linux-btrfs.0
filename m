Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:56855 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751853AbdJLOom (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 10:44:42 -0400
Received: by mail-pf0-f175.google.com with SMTP id b85so5105100pfj.13
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 07:44:42 -0700 (PDT)
Date: Thu, 12 Oct 2017 10:44:38 -0400
From: Joseph Dunn <jdunn14@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs seed question
Message-ID: <20171012104438.4304e99a@olive.ig.local>
In-Reply-To: <CAJCQCtREBoFKB6_gS2WpkRuiA4nV1Ar4pcRbDB6Gaf1t8vSkLw@mail.gmail.com>
References: <20171011204759.1848abd7@olive.ig.local>
        <ff596f2f-7232-4ee0-7967-6888236cc831@oracle.com>
        <20171012092028.1fbe79d9@olive.ig.local>
        <CAJCQCtREBoFKB6_gS2WpkRuiA4nV1Ar4pcRbDB6Gaf1t8vSkLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 12 Oct 2017 15:32:24 +0100
Chris Murphy <lists@colorremedies.com> wrote:

> On Thu, Oct 12, 2017 at 2:20 PM, Joseph Dunn <jdunn14@gmail.com> wrote:
> >
> > On Thu, 12 Oct 2017 12:18:01 +0800
> > Anand Jain <anand.jain@oracle.com> wrote:
> >  
> > > On 10/12/2017 08:47 AM, Joseph Dunn wrote:  
> > > > After seeing how btrfs seeds work I wondered if it was possible to push
> > > > specific files from the seed to the rw device.  I know that removing
> > > > the seed device will flush all the contents over to the rw device, but
> > > > what about flushing individual files on demand?
> > > >
> > > > I found that opening a file, reading the contents, seeking back to 0,
> > > > and writing out the contents does what I want, but I was hoping for a
> > > > bit less of a hack.
> > > >
> > > > Is there maybe an ioctl or something else that might trigger a similar
> > > > action?  
> > >
> > >    You mean to say - seed-device delete to trigger copy of only the
> > > specified or the modified files only, instead of whole of seed-device ?
> > > What's the use case around this ?
> > >  
> >
> > Not quite.  While the seed device is still connected I would like to
> > force some files over to the rw device.  The use case is basically a
> > much slower link to a seed device holding significantly more data than
> > we currently need.  An example would be a slower iscsi link to the seed
> > device and a local rw ssd.  I would like fast access to a certain subset
> > of files, likely larger than the memory cache will accommodate.  If at
> > a later time I want to discard the image as a whole I could unmount the
> > file system or if I want a full local copy I could delete the
> > seed-device to sync the fs.  In the mean time I would have access to
> > all the files, with some slower (iscsi) and some faster (ssd) and the
> > ability to pick which ones are in the faster group at the cost of one
> > content transfer.  
> 
> 
> Multiple seeds?
> 
> Seed A has everything, is remote. Create sprout B also remotely,
> deleting the things you don't absolutely need, then make it a seed.
> Now via iSCSI you can mount both A and B seeds. Add local rw sprout C
> to seed B, then delete B to move files to fast local storage.
> 
Interesting thought.  I haven't tried working with multiple seeds but
I'll see what that can do.  I will say that this approach would require
more pre-planning meaning that the choice of fast files could not be
made based on current access patterns to tasks at hand.  This might
make sense for a core set of files, but it doesn't quite solve the
whole problem.

-Joseph

> 
> 
> -- 
> Chris Murphy
