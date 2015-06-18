Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22225 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752194AbbFRJ0V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 05:26:21 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5I9OfCA023487
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 17:24:41 +0800
Subject: Unified output for btrfs? Fwd: Re: [Libguestfs] [PATCH] New API:
 btrfs_device_stats
To: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55828EB7.5030705@cn.fujitsu.com>
Date: Thu, 18 Jun 2015 17:26:15 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

My colleagues are working on adding btrfs support to libguestfs.

But just like  Pino's complain, even in v4.1-rc1 btrfs-progs we reworked 
some UI of mkfs, the output from other btrfs subcommands still have 
their own output format.

Any idea to provide a unified output format for all btrfs commands?
Maybe a json output will be quite good?
Or an independent btrfs user-space library?

Or this is just what higher level program should do?
Just like the btrfs filters in fstests?

Thanks,
Qu

-------- Forward Message --------
Subject: Re: [Libguestfs] [PATCH] New API: btrfs_device_stats
Date: Thu, 18 Jun 2015 10:41:56 +0200
From: Pino Toscano <ptoscano@redhat.com>
TO: libguestfs@redhat.com

Hi,

On Thursday 18 June 2015 11:01:37 Cao jin wrote:
> > Speaking of this: you said that you have a colleague working on
> > btrfs-progs? What about suggesting to create some machine-parseable
> > output (csv, xml, yaml, json, whatever) so extracting the results of
> > btrfs tools is a lot more easy?
> >
>
> Yes, I forward your suggestion and consult him, the result is not
> surprised:( Here is what I learned from him:
>    For the btrfs-progs cmds who output strings, the output are plain,
> don`t have patterns. Seen some guys who want a formatted output, they do
> a filter by themself, it not reasonable to ask btrfs-progs to output
> formatted strings.

This is exactly the issue here: every btrfs command has a totally
different formatting for its output. Just let him take a look at all
the commands implemented so far in libguestfs, you can easily spot
that:
- btrfs subvolume list
- btrfs subvolume show
- btrfs qgroup show
- btrfs balance status
- btrfs scrub status
- btrfs device stats
all have different custom parsers for each of their outputs.

Compare that to e.g. the -m parameter for parted, so it outputs fields
separated by semi-colon.

-- 
Pino Toscano

_______________________________________________
Libguestfs mailing list
Libguestfs@redhat.com
https://www.redhat.com/mailman/listinfo/libguestfs



