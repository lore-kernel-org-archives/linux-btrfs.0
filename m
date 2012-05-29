Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36124 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab2E2NJP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 09:09:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SZMAk-0001sn-Jx
	for linux-btrfs@vger.kernel.org; Tue, 29 May 2012 15:09:14 +0200
Received: from cpc4-stap10-2-0-cust490.12-2.cable.virginmedia.com ([217.137.143.235])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 15:09:14 +0200
Received: from m_btrfs by cpc4-stap10-2-0-cust490.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 15:09:14 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Will big metadata blocks fix # of hardlinks?
Date: Tue, 29 May 2012 14:09:03 +0100
Message-ID: <jq2hpf$c6r$1@dough.gmane.org>
References: <20120526182211.GA16059@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20120526182211.GA16059@sli.dy.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for noting this one. That is one very surprising and unexpected
limit!... And a killer for some not completely rare applications...

On 26/05/12 19:22, Sami Liedes wrote:
> Hi!
> 
> I see that Linux 3.4 supports bigger metadata blocks for btrfs.
> 
> Will using them allow a bigger number of hardlinks on a single file
> (i.e. the bug that has bitten at least git users on Debian[1,2], and
> BackupPC[3])? As far as I understand correctly, the problem has been
> that the hard links are stored in the same metadata block with some
> other metadata, so the size of the block is an inherent limitation?
> 
> If so, I think it would be worth for me to try Btrfs again :)
> 
> 	Sami
> 
> 
> [1] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/13603
> [2] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=642603
> [3] https://bugzilla.kernel.org/show_bug.cgi?id=15762

One example fail case is just 13 hard links. Even x4 that (16k blocks)
only gives 52 links for that example fail case.


The brief summary for those are:

* It's a rare corner case that needs a format change to fix, so "won't-fix";

* There are real world problem examples noted in those threads for such
as: BackupPC (backups); nnmaildir mail backend in Gnus (an Emacs package
for reading news and email); and a web archiver.

* Also, Bacula (backups) and Mutt (email client) are quoted as problem
examples in:

Btrfs File-System Plans For Ubuntu 12.10
http://www.phoronix.com/scan.php?page=news_item&px=MTEwMDE


For myself, I have a real world example for deduplication of identical
files from a proprietary data capture system where the filenames change
(timestamp and index data stored in the filename) yet there are periods
where the file contents change only occasionally... The 'natural' thing
to do is hardlink together all the identical files to then just have the
unique filenames... And you might have many files in a particular
directory...

Note that for long filenames (surprisingly commonly done!), one fail
case noted above is just 13 hard links.


Looks like I'm stuck on ext4 with an impoverished "cp -l" for a fast
'snapshot' for the time being still... (Or differently, LVM snapshot and
copy.)


For btrfs, rather than a "break everything" format change, can a neat
and robust 'workaround' be made so that the problem-case hardlinks to a
file within the same directory perhaps spawn their own transparent
subdirectory for the hard links?... Worse case then is that upon a
downgrade to an older kernel, the 'transparent' subdirectory of hard
links becomes visible as a distinct subdirectory? (That is a 'break' but
at least data isn't lost.)

Or am I chasing the wrong bits? ;-)


More seriously: The killer there for me is that running rsync or running
a deduplication script might hit too many hard links that were perfectly
fine when on ext4.

Regards,
Martin


