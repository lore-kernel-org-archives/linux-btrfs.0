Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37499 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752360AbdHQLrx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 07:47:53 -0400
Received: by mail-it0-f45.google.com with SMTP id 76so867996ith.0
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 04:47:52 -0700 (PDT)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: GWB <gwb@2realms.com>, Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
 <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
 <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
 <1502740488.5384.5.camel@scientia.net>
 <20170816131230.GA28619@clm-mbp.thefacebook.com>
 <51e051fa-3731-d2fe-7eab-cb324fd38576@gmx.com>
 <CAJCQCtSgGdsctmiJ4Sq+E5Qr1aoC87EiFUrkH7Eeu8GTZ6XvyQ@mail.gmail.com>
 <CAP8EXU2VnPMp4TdXo=GcNQ6Y1ymTMsO=t8+AEEM=LygRpTUWMA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <118e3a18-bf01-919f-0e21-7101313cd164@gmail.com>
Date: Thu, 17 Aug 2017 07:47:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAP8EXU2VnPMp4TdXo=GcNQ6Y1ymTMsO=t8+AEEM=LygRpTUWMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-17 02:25, GWB wrote:
> <<
> Or else it could be an argument that they
> expect Btrfs to do their job while they watch cat videos from the
> intertubes. :-)
>>>
> 
> My favourite quote from the list this week, and, well, obviously, that
> is the main selling point of file systems like btrfs, zfs, and various
> other lvm and raid set ups.  The need to free up time to watch cat
> videos on the intertubes (whilst at work) has driven most
> technological innovations, going back at least to the time of the
> Roman Empire.
> 
> So, sure, I'll be happy to admit that I like it very much when a file
> system or some other software or hardware component makes my job
> easier (which gives me more time to watch cat videos).  But if hours
> on hours of cat videos have taught me one thing, it is that
> catastrophe (pun intended) awaits those who assume that btrfs (or zfs
> or nilfs or whatever) will magically work well in all use cases.
Agreed, and I will comment that there are far more catastrophes caused 
by sysadmin complacency or not properly understanding what they're 
administering than almost anything else.
> 
> That may be what their customers assumed about btrfs, but did Red Hat
> make that claim implicitly or explicitly?  I don't know, but it seems
> unlikely, and all the things mentioned in this thread make sense to
> me.  It looks like Red Hat is pushing "GFS" (Red Hat Global File
> System) for its clustered file system:
> 
> https://www.redhat.com/whitepapers/rha/gfs/GFS_INS0032US.pdf
Huh, I could have sworn they were pushing Gluster...
> 
> XFS is now the standard "on disk" fs for Red Hat, but I can't tell if
> XFS is the DMU (backing file system or Data Management Unit) for GFS
> (zfs is the dmu for lustre).  Probably, but why does GFS still has a
> file size limit of 100TB, while XFS has a 500TB limit, according to
> Red Hat?
GFS2 (which is what I think they're talking about) has it's own on-disk 
format, and actually works as a single-node filesystem.  It's a lot 
closer to OCFS2 in terms of design than it is to Lustre, though I'm not 
sure if it needs shared storage or not.

Also, both of those file size 'limits' are customer support limits from 
what I can tell.  XFS supports files (in theory at least) up to 8 EB 
minus one byte, and I'm not able to find any other documentation on this 
regarding GFS2, but I seriously doubt that it has a 100TB file size limit.
> 
> https://access.redhat.com/articles/rhel-limits
> 
> And btrfs is gone from that list.
> 
> So does this mean that Red Hat deprecating btrfs have a tangible
> effect on its development, future improvements, and adoption?  It
> doesn't help, but maybe its not too bad.  From reading the list, my
> impression is that the typical Red Hat customer with large data arrays
> might do fine running xfs over lvm2 over hardware raid (or at least
> the customers who are paying attention to the monitor stats between
> cat videos).  That's not for me, because I prefer mirrors, not
> stripes, and "hot spares" that I can pull out of the enclosure, place
> in another machine, and get running again (which points me back to
> btrfs and zfs).  But it must work great for a lot of data silos.
> 
> On the plus side, btrfs is one of the backing file systems in ceph; on
> the minus side, with Red Hat out, btrfs might lose some developers and
> support:
> 
> http://www.h-online.com/open/features/Kernel-Log-Coming-in-2-6-37-Part-2-File-systems-1148305.html%3Fpage=2
I'm pretty certain that Ceph has officially stopped recommending BTRFS 
as a backend filesystem.  TBH, it was never that amazing of an idea to 
begin with, Ceph does a lot of the same things that BTRFS does, so 
you're replicating a not insignificant amount of work, and the big thing 
was really snapshot support anyway.

Also, I don't think I've ever seen any patches posted from a Red Hat 
address on the ML, so I don't think they were really all that involved 
in development to begin with.
> 
> As long as FaceBook keeps using btrfs, I wouldn't worry too much about
> large firm adoption.  Chris (from facebook, post above) points out
> that Facebook runs both xfs and btrfs as backing file systems for
> Gluster:
> 
> https://www.linux.com/news/learn/intro-to-linux/how-facebook-uses-linux-and-btrfs-interview-chris-mason
> 
> And Gluster is... owned by Red Hat (since 2011), which now advertises
> its "Red Hat Global File System", which would be... Gluster?  Chris,
> is that right?  So Facebook runs Gluster (which might be Red Hat
> Global File System) with both xfs and btrfs as the backing fs, and Red
> Hat... advertises Red Hat GFS as a platform for Oracle RAC Database
> Clustering.  But not (presumably) running with btrfs as the backing
> fs, but rather xfs.  So could one Gluster "grid" run over two file
> systems, xfs for the applications, and btrfs for the primary data
> storage?
GFS and GlusterFS are different technologies, unless Red Hat's marketing 
department is trying to be actively deceptive.

GFS is a traditional cluster filesystem which requires fencing hardware 
and has it's own on-disk format.  It originated on IRIX, got ported to 
Linux, got updated to GFS2 to add splice() support and a few other 
things, and hasn't seen much development from what I can tell since that 
happened in 2009 (at least, not much beyond standard bug fixes and 
maintenance).

GlusterFS is a more modern cluster filesystem design, uses separate 
backing storage (like Lustre and Ceph do), has the rather nice advantage 
that the layout on the back-end storage exactly replicates the layout in 
the GlusterFS volume (assuming you're just using replication), and 
doesn't require any special hardware.  It also runs reasonably well on 
top of BTRFS, other than some scalability issues with directories with 
thousands of files in them (both Gluster and BTRFS have issues there, 
and they compound when used in a stack like this).  It doesn't directly 
use any special functionality of BTRFS, although it in theory could make 
use of the snapshotting functionality (the current snapshot support in 
Gluster assumes the use of a backing FS that supports freezefs on top of 
LVM2).
> 
> So Oracle still supports btrfs.  Facebook still uses it.  And it would
> be very funny if Red Hat GFS does use btrfs (eventually, at some point
> in the future) as the backing fs, but their customers probably won't
> notice the difference.
SUSE is also pretty actively involved in the development too, and I 
think Fujitsu is as well.
> 
> I'm not too worried.  I'll keep using btrfs as it is now, within the
> limits of what it can consistently do, and do what I can to help
> support the effort.  I'm not a file system coder, but I very much
> appreciate the enormous amount of work that goes into btrfs.
> 
> Steady on, ButterFS people.  Back now to cat videos.
