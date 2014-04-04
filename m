Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63749 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaDDMdE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 08:33:04 -0400
Received: by mail-ie0-f178.google.com with SMTP id lx4so3274505iec.37
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Apr 2014 05:33:04 -0700 (PDT)
Message-ID: <533EA686.5030909@gmail.com>
Date: Fri, 04 Apr 2014 08:33:10 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
References: <2692878.dRG1K49eOP@fnix>
In-Reply-To: <2692878.dRG1K49eOP@fnix>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-04-04 04:02, Swâmi Petaramesh wrote:
> Hi,
> 
> I'm going to receive a new small laptop with a 500 GB 5400 RPM mechanical 
> "ole' rust"  HD, and I plan ton install BTRFS on it.
> 
> It will have a kernel 3.13 for now, until 3.14 gets released.
> 
> However I'm still concerned with chronic BTRFS dreadful performance and still 
> find that BRTFS degrades much over time even with periodic defrag and "best 
> practices" etc.
I keep hearing this from people, but i personally don't see this to be
the case at all.  I'm pretty sure the 'big' performance degradation that
people are seeing is due to how they are using snapshots, not a result
using BTRFS itself (I don't use them for anything other than ensuring a
stable system image for rsync and/or tar based backups).
> 
> So I'd like to start with the best possible options and have a few questions :
> 
> - Is it still recommended to mkfs with a nodesize or leafsize different 
> (bigger) than the default ? I wouldn't like to lose too much disk space anyway 
> (1/2 nodesize per file on average ?), as it will be limited...
This depends on many things, the average size of the files on the disk
is the biggest factor.  In general you should get the best disk
utilization by setting nodesize so that a majority of the files are less
than the leafsize minus 256 bytes, and all but a few are smaller than
two times the leafsize minus 256 bytes.  However, if you want to really
benefit from the data compression, you should just use the smallest
leaf/nodesize for your system (which is what mkfs defaults to), as data
that gets as BTRFS stores files whose size is at least (roughly) 256
bytes less than the leafsize inline with the metadata, and doesn't
compress such files.
> 
> - Is it recommended to alter the FS to have "skinny extents" ? I've done this 
> on all of my BTRFS machines without problem, still the kernel spits a notice 
> at mount time, and I'm worrying kind of "Why is the kernel warning me I have 
> skinny extents ? Is it bad ? Is it something I should avoid ?"
I think that the primary reason for the warning is that it is backward
incompatible, older kernels can't mount filesystems using it.
> 
> - Are there other optimization tricks I should perform at mkfs time because 
> thay can't be changed later on ?
> 
> - Are there other btrfstune or mount options I should pass before starting to 
> populate the FS with a system and data ?
Unless you are using stuff like QEMU or Virtualbox, you should probably
have autodefrag and space_cache on from the very start.
> 
> - Generally speaking, does LZO compression improve or degrade performance ? 
> I'm not able to figure it out clearly.
As long as your memory bandwidth is significantly higher than disk
bandwidth (which is almost always the case, even with SSD's), this
should provide at least some improvement with respect to IO involving
large files.  Because you are using a traditional hard disk instead of
an SSD, you might get better performance using zlib (assuming you don't
mind slightly higer processor usage for IO to files larger than the
leafsize).  If you care less about disk utilization than you do about
performance, you might want to use compress_force instead of compress,
as the performance boost comes from not having to write as much data to
disk.
> 
> TIA for the insight.
> 
