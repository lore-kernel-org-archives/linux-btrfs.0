Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56283 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2JLKc5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 06:32:57 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Varying Leafsize and Nodesize in Btrfs
Date: Fri, 12 Oct 2012 12:32:55 +0200
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
References: <CAKcLGm_MKEdTiHFBd-b-v2sN5gJmgFRqsykzWRXTVqUw4O6Acw@mail.gmail.com> (sfid-20120830_172515_413469_B4014793)
In-Reply-To: <CAKcLGm_MKEdTiHFBd-b-v2sN5gJmgFRqsykzWRXTVqUw4O6Acw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210121232.55415.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 30. August 2012 schrieb Mitch Harder:
> I've been trying out different leafsize/nodesize settings by
> benchmarking some typical operations.
> 
> These changes had more impact than I expected.  Using a
> leafsize/nodesize of either 8192 or 16384 provided a noticeable
> improvement in my limited testing.
> 
> These results are similar to some that Chris Mason has already
> reported:  https://oss.oracle.com/~mason/blocksizes/
> 
> I noticed that metadata allocation was more efficient with bigger
> block sizes.  My data was git kernel sources, which will utilize
> btrfs' inlining.  This may have tilted the scales.
> 
> Read operations seemed to benefit the most.  Write operations seemed
> to get punished when the leafsize/nodesize was increased to 64K.
> 
> Are there any known downsides to using a leafsize/nodesize bigger than
> the default 4096?
> 
> 
> Time (seconds) to finish 7 simultaneous copy operations on a set of
> Linux kernel git sources.
> 
> Leafsize/
> Nodesize    Time (Std Dev%)
> 4096         124.7 (1.25%)
> 8192         115.2 (0.69%)
> 16384        114.8 (0.53%)
> 65536        130.5 (0.3%)

Thanks for your testing, Mitch.

I would be interested in results for 32768 bytes as well.

Why?

It improves until 16384 bytes but then it gets worse with 65536 bytes. It 
would be interesting to know whether it improves for 32768 or already gets 
worse with that value :)

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
