Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:17263 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754786Ab2JaSui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 14:50:38 -0400
Received: from 210.34.21.95.dynamic.jazztel.es ([95.21.34.210] helo=mail.viric.name)
	by mho-02-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1TTdN7-000Jin-Af
	for linux-btrfs@vger.kernel.org; Wed, 31 Oct 2012 18:50:37 +0000
Date: Wed, 31 Oct 2012 19:50:33 +0100
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Can't replace a faulty disk of raid1
Message-ID: <20121031185033.GP2052@vicerveza.homeunix.net>
References: <20121026105721.GU2052@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20121026105721.GU2052@vicerveza.homeunix.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 26, 2012 at 12:57:21PM +0200, Lluís Batlle i Rossell wrote:
> I had a raid1 btrfs (540GB) on vanilla 3.6.3, a disk failed, and removed it at
> power off, plugged in a new one, partitioned it (to 110GB, by error), and added
> it to btrfs.
> 
> I tried to remove the missing device, and it said "Input/output error" after a
> while. Next attempts simply gave "Invalid argument".
> 
> Some data:
> 
> # btrfs fi df /
> Data, RAID1: total=507.62GB, used=417.08GB
> Data: total=25.32GB, used=22.48GB
> System, RAID1: total=32.00MB, used=92.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=19.97GB, used=5.50GB

For the sake of mail archiving and future searches, problem solved; there is
some 'single' data there (22.48GB). Removing the files containing that data
allowed "btrfs device delete missing /" to work.

For what I know, at 3.6 there were no error messages indicating about that.
Then, scrub does not check anything related to missing disks, so it reports that
all works. And I think that btrfsck also does not report anything related to
missing disks.

The way to get what files had the missing data was to run "tar c /", and wait
for the errors report on EIO. Then I removed those files.

Thanks a lot to Josef, who sent me patches adding error reports, to get closer
to the source the errors, and the rest of the helpful people at the #btrfs @
freenode

Regards,
Lluís.
