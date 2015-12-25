Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0200.smtp25.com ([174.37.170.200]:47731 "EHLO
	mail0200.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbbLYVu5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Dec 2015 16:50:57 -0500
From: covici@ccs.covici.com
To: Henk Slager <eye1tm@gmail.com>
cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs problems on new file system
In-reply-to: <CAPmG0jbOu6BmKfbaoJ6pzprWzbch3tf7=zbBS8AcDz4MQVEJZA@mail.gmail.com>
References: <16107.1451037790@ccs.covici.com> <CAPmG0jbOu6BmKfbaoJ6pzprWzbch3tf7=zbBS8AcDz4MQVEJZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 25 Dec 2015 16:14:58 -0500
Message-ID: <18552.1451078098@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager <eye1tm@gmail.com> wrote:

> On Fri, Dec 25, 2015 at 11:03 AM,  <covici@ccs.covici.com> wrote:
> > Hi.  I created a file system using 4.3.1 version of btrfsprogs and have
> > been using it for some three days.  I have gotten the following errors
> > in the log this morning:
> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> > transid verify failed on 51776421888 wanted 4983 found 4981
> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> > transid verify failed on 51776421888 wanted 4983 found 4981
> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> > transid verify failed on 51776421888 wanted 4983 found 4981
> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> > transid verify failed on 51776421888 wanted 4983 found 4981
> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> > transid verify failed on 51776421888 wanted 4983 found 4981
> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> > transid verify failed on 51776421888 wanted 4983 found 4981
> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> > transid verify failed on 51776421888 wanted 4983 found 4981
> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> > transid verify failed on 51776421888 wanted 4983 found 4981
> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> > transid verify failed on 51776421888 wanted 4983 found 4981
> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> > transid verify failed on 51776421888 wanted 4983 found 4981
> >
> > The file system was then made read only.  I unmounted, did a check
> > without repair which said it was fine, and remounted successfully in
> > read/write mode, but am I in trouble?  This was on a solid state drive
> > using lvm.
> What kernel version are you using?
> I think you might have some hardware error or glitch somewhere,
> otherwise I don't know why you have such errors. These kind of errors
> remind me of SATA/cable failures over quite a period of time (multipe
> days). Or something with lvm or trim of SSD.
> Any unusual with the SSD if you run  smartctl?
> A btrfs check will indeed likely result in an OK for this case.
> What about running read-only scrub?
> Maybe running  memtest86+  can rule-out the worst case.

I am running 4.1.12-gentoo and btrfs progs 4.3.1.  Same thing happened
on another filesystem, so I switched them over to ext4 and no troubles
since.  As far as I know the ssd drives are fine, I have been using them
for months.  Maybe btrfs needs some more work.  I did do scrubs on the
filesystems after I went offline and remounted them, and they were
successful, and I got no errors from the lower layers at all.  Maybe
I'll try this in a year or so.



-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
