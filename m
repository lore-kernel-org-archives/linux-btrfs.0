Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43790 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751743AbaFVSrO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 14:47:14 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:62649 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WymnI-002lhx-2K
	for linux-btrfs@vger.kernel.org; Sun, 22 Jun 2014 12:47:12 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs on whole disk (no partitions)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53A6DDAD.8070804@chinilu.com>
Date: Sun, 22 Jun 2014 12:47:10 -0600
Message-Id: <99AD3EFE-AF9A-44A1-912E-07B1E934239B@colorremedies.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>	<2316027.LZEnVG8laK@xev>	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com> <CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com> <53A6DDAD.8070804@chinilu.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 22, 2014, at 7:44 AM, George Mitchell <george@chinilu.com> wrote:
> This is a problem related to Western Digital drives.  They lie in order to be compatible with older versions of Windows.  Seagate AF drives report 4K, not 512B.  Western Digital took this path in order to make the drives work with older Windows operating systems because Microsoft chose not to include support for AF drives until the last minute.  

What a number of drive manufacturers did was have a Windows XP jumper setting which caused a +1 offset to all LBAs. That is, with the juper set the on-disk LBA 0 would not get used, an OS request of LBA 0 actually accessed LBA 1. What this did was it caused partition 1, which on XP and older starts at LBA 63, to actually start on disk at LBA 64 which is 8 sector aligned. This resolved the alignment problem for XP but then would cause an alignment problem if used with a partition tool that properly aligned, which is why it had to be unset for those systems.

Merely having a drive report physical sector size of 512 does not solve the alignment problem with AF disks so I don't know why any drive manufacturer would be motivated to do this. But then, many of us have SSDs which we know do not have such a thing as a physical sector, the closest structure that comes to that is maybe the page, and this varies among models maybe the most common being 4096 bytes but some write ups have said they are up to 16KB. Yet all SSD's report physical sector size of 512 bytes.


> As far as I know, btrfs defaults to 4K UNLESS you specify 512B

I'm not sure what this means. The Btrfs sector size minimum is 4096 bytes. I can use -s to make it bigger, but not less than 4096 on 512/512 or 512/4096 byte drives. I actually don't know what Btrfs sector size is but it's not the same thing as drive logical or physical sector size.

Chris Murphy

