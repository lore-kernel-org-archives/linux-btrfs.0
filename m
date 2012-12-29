Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:52125 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329Ab2L2Pwp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Dec 2012 10:52:45 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: parent transid verify failed on -- After moving btrfs closer to the beginning of drive with dd
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE5mzvjDycff5X7sL=WGPRcLi2BJOMVDE2gQZJmkVOSBhRsC_A@mail.gmail.com>
Date: Sat, 29 Dec 2012 08:52:44 -0700
Message-Id: <2B432411-484A-4414-A761-99504CC743B0@colorremedies.com>
References: <CACCfv7ot+WTV1eiBCujcyPkSt7SGqVvVCKpFo4rn8Y=FEZu_7w@mail.gmail.com> <CAE5mzvhOMZopeVqb4A7PihLuyM2zo_ETN1G3wE_OJi27NfSzVg@mail.gmail.com> <CACCfv7oFanOd1Yg=UgqEVhfHbD=JGkGT3CZy9KpQMgrsWixX=w@mail.gmail.com> <CACCfv7r5zVx7UGWNLyeHT9t6VT8rWW8WgQwAb+ffjiUOyi6C2g@mail.gmail.com> <CAE5mzvjDycff5X7sL=WGPRcLi2BJOMVDE2gQZJmkVOSBhRsC_A@mail.gmail.com>
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 29, 2012, at 8:38 AM, cwillu <cwillu@cwillu.com> wrote:

> On Sat, Dec 29, 2012 at 7:14 AM, Jordan Windsor <jordanw2@gmail.com> wrote:
>> Also here's the output of btrfs-find-root:
>> 
>> ./btrfs-find-root /dev/sdb1
>> Super think's the tree root is at 1229060866048, chunk root 1259695439872
>> Went past the fs size, exiting
>> 
>> Not sure where to go from here.
> 
> I can't say for certain, but that suggests that the move-via-dd didn't
> succeed / wasn't correct, and/or the partitioning changes didn't
> match, and/or the dd happened from a mounted filesystem (which would
> also explain the transid errors, if there wasn't an unclean umount
> involved).
> 
> btrfs-restore might be able to pick out files, but you may be in
> restore-from-backup territory.

Yeah I'm vaguely curious about how the move was done, in particular if it was dd'd from a mounted fs. 

Chris Murphy