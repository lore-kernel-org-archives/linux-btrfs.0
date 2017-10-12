Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:48244 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754886AbdJLNUb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 09:20:31 -0400
Received: by mail-qt0-f179.google.com with SMTP id f8so13541803qta.5
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 06:20:31 -0700 (PDT)
Date: Thu, 12 Oct 2017 09:20:28 -0400
From: Joseph Dunn <jdunn14@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs seed question
Message-ID: <20171012092028.1fbe79d9@olive.ig.local>
In-Reply-To: <ff596f2f-7232-4ee0-7967-6888236cc831@oracle.com>
References: <20171011204759.1848abd7@olive.ig.local>
        <ff596f2f-7232-4ee0-7967-6888236cc831@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 12 Oct 2017 12:18:01 +0800
Anand Jain <anand.jain@oracle.com> wrote:

> On 10/12/2017 08:47 AM, Joseph Dunn wrote:
> > After seeing how btrfs seeds work I wondered if it was possible to push
> > specific files from the seed to the rw device.  I know that removing
> > the seed device will flush all the contents over to the rw device, but
> > what about flushing individual files on demand?
> > 
> > I found that opening a file, reading the contents, seeking back to 0,
> > and writing out the contents does what I want, but I was hoping for a
> > bit less of a hack.
> > 
> > Is there maybe an ioctl or something else that might trigger a similar
> > action?  
> 
>    You mean to say - seed-device delete to trigger copy of only the 
> specified or the modified files only, instead of whole of seed-device ? 
> What's the use case around this ?
> 

Not quite.  While the seed device is still connected I would like to
force some files over to the rw device.  The use case is basically a
much slower link to a seed device holding significantly more data than
we currently need.  An example would be a slower iscsi link to the seed
device and a local rw ssd.  I would like fast access to a certain subset
of files, likely larger than the memory cache will accommodate.  If at
a later time I want to discard the image as a whole I could unmount the
file system or if I want a full local copy I could delete the
seed-device to sync the fs.  In the mean time I would have access to
all the files, with some slower (iscsi) and some faster (ssd) and the
ability to pick which ones are in the faster group at the cost of one
content transfer.

I'm not necessarily looking for a new feature addition, just if there is
some existing call that I can make to push specific files from the slow
mirror to the fast one.  If I had to push a significant amount of
metadata that would be fine, but the file contents feeding some
computations might be large and useful only to certain clients.

So far I found that I can re-write the file with the same contents and
thanks to the lack of online dedupe these writes land on the rw mirror
so later reads to that file should not hit the slower mirror.  By the
way, if I'm misunderstanding how the read process would work after the
file push please correct me.

I hope this makes sense but I'll try to clarify further if you have
more questions.

-Joseph

> 
> Thanks, Anand
> 
> 
> > Thanks,
> > -Joseph
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >   
