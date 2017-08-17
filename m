Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34136 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbdHQG0d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 02:26:33 -0400
Received: by mail-vk0-f54.google.com with SMTP id n125so19378878vke.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 23:26:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSgGdsctmiJ4Sq+E5Qr1aoC87EiFUrkH7Eeu8GTZ6XvyQ@mail.gmail.com>
References: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com> <1502496618.6092.6.camel@scientia.net>
 <20170812074248.GA3352@infradead.org> <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net> <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net> <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
 <1502740488.5384.5.camel@scientia.net> <20170816131230.GA28619@clm-mbp.thefacebook.com>
 <51e051fa-3731-d2fe-7eab-cb324fd38576@gmx.com> <CAJCQCtSgGdsctmiJ4Sq+E5Qr1aoC87EiFUrkH7Eeu8GTZ6XvyQ@mail.gmail.com>
From: GWB <gwb@2realms.com>
Date: Thu, 17 Aug 2017 01:25:51 -0500
Message-ID: <CAP8EXU2VnPMp4TdXo=GcNQ6Y1ymTMsO=t8+AEEM=LygRpTUWMA@mail.gmail.com>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

<<
Or else it could be an argument that they
expect Btrfs to do their job while they watch cat videos from the
intertubes. :-)
>>

My favourite quote from the list this week, and, well, obviously, that
is the main selling point of file systems like btrfs, zfs, and various
other lvm and raid set ups.  The need to free up time to watch cat
videos on the intertubes (whilst at work) has driven most
technological innovations, going back at least to the time of the
Roman Empire.

So, sure, I'll be happy to admit that I like it very much when a file
system or some other software or hardware component makes my job
easier (which gives me more time to watch cat videos).  But if hours
on hours of cat videos have taught me one thing, it is that
catastrophe (pun intended) awaits those who assume that btrfs (or zfs
or nilfs or whatever) will magically work well in all use cases.

That may be what their customers assumed about btrfs, but did Red Hat
make that claim implicitly or explicitly?  I don't know, but it seems
unlikely, and all the things mentioned in this thread make sense to
me.  It looks like Red Hat is pushing "GFS" (Red Hat Global File
System) for its clustered file system:

https://www.redhat.com/whitepapers/rha/gfs/GFS_INS0032US.pdf

XFS is now the standard "on disk" fs for Red Hat, but I can't tell if
XFS is the DMU (backing file system or Data Management Unit) for GFS
(zfs is the dmu for lustre).  Probably, but why does GFS still has a
file size limit of 100TB, while XFS has a 500TB limit, according to
Red Hat?

https://access.redhat.com/articles/rhel-limits

And btrfs is gone from that list.

So does this mean that Red Hat deprecating btrfs have a tangible
effect on its development, future improvements, and adoption?  It
doesn't help, but maybe its not too bad.  From reading the list, my
impression is that the typical Red Hat customer with large data arrays
might do fine running xfs over lvm2 over hardware raid (or at least
the customers who are paying attention to the monitor stats between
cat videos).  That's not for me, because I prefer mirrors, not
stripes, and "hot spares" that I can pull out of the enclosure, place
in another machine, and get running again (which points me back to
btrfs and zfs).  But it must work great for a lot of data silos.

On the plus side, btrfs is one of the backing file systems in ceph; on
the minus side, with Red Hat out, btrfs might lose some developers and
support:

http://www.h-online.com/open/features/Kernel-Log-Coming-in-2-6-37-Part-2-File-systems-1148305.html%3Fpage=2

As long as FaceBook keeps using btrfs, I wouldn't worry too much about
large firm adoption.  Chris (from facebook, post above) points out
that Facebook runs both xfs and btrfs as backing file systems for
Gluster:

https://www.linux.com/news/learn/intro-to-linux/how-facebook-uses-linux-and-btrfs-interview-chris-mason

And Gluster is... owned by Red Hat (since 2011), which now advertises
its "Red Hat Global File System", which would be... Gluster?  Chris,
is that right?  So Facebook runs Gluster (which might be Red Hat
Global File System) with both xfs and btrfs as the backing fs, and Red
Hat... advertises Red Hat GFS as a platform for Oracle RAC Database
Clustering.  But not (presumably) running with btrfs as the backing
fs, but rather xfs.  So could one Gluster "grid" run over two file
systems, xfs for the applications, and btrfs for the primary data
storage?

So Oracle still supports btrfs.  Facebook still uses it.  And it would
be very funny if Red Hat GFS does use btrfs (eventually, at some point
in the future) as the backing fs, but their customers probably won't
notice the difference.

I'm not too worried.  I'll keep using btrfs as it is now, within the
limits of what it can consistently do, and do what I can to help
support the effort.  I'm not a file system coder, but I very much
appreciate the enormous amount of work that goes into btrfs.

Steady on, ButterFS people.  Back now to cat videos.

Gordon

 Aug 16, 2017 at 11:54 AM, Peter Grandi <pg@btrfs.list.sabi.co.uk> wrote:
> [ ... ]
>
>> But I've talked to some friend at the local super computing
>> centre and they have rather general issues with CoW at their
>> virtualisation cluster.
>
> Amazing news! :-)
>
>> Like SUSE's snapper making many snapshots leading the storage
>> images of VMs apparently to explode (in terms of space usage).
>
> Well, this could be an argument that some of your friends are being
> "challenged" by running the storage systems of a "super computing
> centre" and that they could become "more prepared" about system
> administration, for example as to the principle "know which tool to
> use for which workload". Or else it could be an argument that they
> expect Btrfs to do their job while they watch cat videos from the
> intertubes. :-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
