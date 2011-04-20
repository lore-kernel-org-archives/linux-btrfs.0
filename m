From: Chris Mason <chris.mason@oracle.com>
Subject: Re: parent transid troubles
Date: Wed, 20 Apr 2011 10:04:52 -0400
Message-ID: <1303308238-sup-3555@think>
References: <sa2k4ep83fv.fsf@techsquare.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Gregory L Shomo <greg@techsquare.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <sa2k4ep83fv.fsf@techsquare.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Gregory L Shomo's message of 2011-04-20 09:20:20 -0400:
> Chris Mason <chris.mason@oracle.com> writes:
> 
> > Excerpts from Gregory L Shomo's message of 2011-04-20 08:56:02 -0400:
> >> Chris Mason <chris.mason@oracle.com> writes:
> >> 
> >> > Excerpts from Gregory L Shomo's message of 2011-04-19 15:08:13 -0400:
> >> >> Hello list-
> >> >> 
> >> >> Under heavy load (i/o), one of our fileservers lost two drives
> >> >> in a raid6 configuration. After the drives were synchronized,
> >> >> we can no longer mount the multiple-device btrfs filesystem
> >> >> due to (at least) parent transid verification.
> >> >> 
> >> >> btrfsck built from git commit 1b444cd2e6ab8dcafdd47dbaeaae369dd1517c17
> >> >> runs for a while and then aborts on 'failed to find block number'.
> >> >> Sample output includes :
> >> >
> >> > Looks like the rebuild gave you older copies of some of the blocks.
> >> > btrfsck will exit out pretty early when it sees problems, but I'd say
> >> > most of your FS is there.
> >> >
> >> > Can you please do a btrfs-debug-tree /dev/xxx > out, I'd like to see how
> >> > far we get.
> >> >
> >> > What errors do you get when trying to mount the FS?
> >> >
> >> > -chris
> >> 
> >> I'm not sure how far we will get, but btrfs-debug-tree
> >> has been running for over 12h now and the screenlog is
> >> at 80Gb. This may not be surprising, as the filesystem 
> >> is large (60T) and has millions of files. 
> >> 
> >> From the logs at boottime, we have
> >> 
> >>   btrfs: failed to read the system array on sdd1
> >>   btrfs: open_ctree failed
> >> 
> >> Should we wait for the btrfs-debug-tree to finish
> >> before executing an other mount command ? 
> >
> > For btrfs-debug-tree to run this long, big parts of your FS must be
> > valid.  Also, btrfs-debug-tree must have been able to read the sys
> > array (which mount was complaining about).
> >
> > How easily can you try a newer kernel?  We need to make sure and do
> > readonly operations (mount -o ro), but we may be able to pull out a
> > bunch of files.
> >
> > -chris
> 
> 
> Sure, we're up for that. Should we rebuild the kernel, or just 
> the btrfs module ? If the kernel, is linux-2.6.38.3 a good
> choice, or should we build 2.6.39-rc4 ? If we only need to
> rebuild the btrfs module, should we use Monday's commit to 
> btrfs-unstable ? 

The best choice right now is 2.6.38 plus the master branch of the btrfs
unstable tree.  There are a lot of fixes to dealing with busted blocks
thanks to Josef and Fujitsu.

It may still have trouble, please make sure to mount -o ro.

-chris
