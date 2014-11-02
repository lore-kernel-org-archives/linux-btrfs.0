Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:47629 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbaKBE0P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Nov 2014 00:26:15 -0400
Message-ID: <5455B25E.2070703@pobox.com>
Date: Sat, 01 Nov 2014 21:26:06 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID1 fails to recover chunk tree
References: <544FFD52.6010604@gmail.com> <5451699B.4020507@pobox.com> <54517338.7090606@pobox.com> <54523D86.5040906@gmail.com> <58060F93-3CB7-4575-9AF7-59DAF895CE7B@colorremedies.com> <pan$2cd78$85acd913$95d42126$8a9a4137@cox.net> <FC480E52-012E-41E7-902E-2EE3ECFFB90B@colorremedies.com>
In-Reply-To: <FC480E52-012E-41E7-902E-2EE3ECFFB90B@colorremedies.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/30/2014 07:09 PM, Chris Murphy wrote:
> Is hard to say. If a balance hasn't recently been done, the original device may have a good amount of free space in allocated chunks. I'm pretty sure Btrfs will write first to already allocated chunks with free space before allocating new chunks? So a bunch of stuff could actually still be on the original device - it just needs -o degraded,ro to get access to it. And if the current version of the file isn't retrievable because all or part of it's on the other drive, it'll just cause an error to occur. I think rsync and the like can be set to not fail on such errors, so anything that can be retrieved, is.

Way back when he said that he "set the metadata to raid1" (or the 
equivalent). That is, he didn't just rely on the default duplicaiton 
onto the second drive. The only way I know to explicitly do that is with 
the mfilter option to balance. So I'm pretty sure that, statistically, 
about half his data is gone.

