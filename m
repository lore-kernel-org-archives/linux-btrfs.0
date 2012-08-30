Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63931 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2H3PSI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 11:18:08 -0400
Received: by obbuo13 with SMTP id uo13so3462962obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2012 08:18:08 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Aug 2012 10:18:07 -0500
Message-ID: <CAKcLGm_MKEdTiHFBd-b-v2sN5gJmgFRqsykzWRXTVqUw4O6Acw@mail.gmail.com>
Subject: Varying Leafsize and Nodesize in Btrfs
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been trying out different leafsize/nodesize settings by
benchmarking some typical operations.

These changes had more impact than I expected.  Using a
leafsize/nodesize of either 8192 or 16384 provided a noticeable
improvement in my limited testing.

These results are similar to some that Chris Mason has already
reported:  https://oss.oracle.com/~mason/blocksizes/

I noticed that metadata allocation was more efficient with bigger
block sizes.  My data was git kernel sources, which will utilize
btrfs' inlining.  This may have tilted the scales.

Read operations seemed to benefit the most.  Write operations seemed
to get punished when the leafsize/nodesize was increased to 64K.

Are there any known downsides to using a leafsize/nodesize bigger than
the default 4096?


Time (seconds) to finish 7 simultaneous copy operations on a set of
Linux kernel git sources.

Leafsize/
Nodesize    Time (Std Dev%)
4096         124.7 (1.25%)
8192         115.2 (0.69%)
16384        114.8 (0.53%)
65536        130.5 (0.3%)


Time (seconds) to finish 'git status' on a set of Linux kernel git sources.

Leafsize/
Nodesize    Time (Std Dev%)
4096          13.2 (0.86%)
8192          11.2 (1.36%)
16384          9.0 (0.92%)
65536          8.5 (1.3%)


Time (seconds) to perform a git checkout of a different branch on a
set of Linux kernel sources.

Leafsize/
Nodesize    Time (Std Dev%)
4096          19.4 (1.1%)
8192          16.94 (3.1%)
16384         14.4 (0.6%)
65536         16.3 (0.8%)


Time (seconds) to perform 7 simultaneous rsync threads on the Linux
kernel git sources directories.

Leafsize/
Nodesize    Time (Std Dev%)
4096         410.3 (4.5%)
8192         289.8 (0.96%)
16384        250.7 (3.8%)
65536        227.0 (1.2%)


Used Metadata (MB) as reported by 'btrfs fi df'

Leafsize/
Nodesize    Size (Std Dev%)
4096         484 MB (0.13%)
8192         443 MB (0.2%)
16384        424 MB (0.2%)
65536        411 MB (0.2%)
