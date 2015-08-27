Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56417 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511AbbH0Bpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 21:45:51 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
References: <981687019fcca4b4f7455b7a755e48888cbd24ff.1440510311.git.zhaolei@cn.fujitsu.com> <20150826171949.GA11834@twin.jikos.cz>
In-Reply-To: <20150826171949.GA11834@twin.jikos.cz>
Subject: RE: [PATCH] btrfs: scrub: set error stats when tree block spanning stripes
Date: Thu, 27 Aug 2015 09:44:05 +0800
Message-ID: <03b601d0e069$ddd50ee0$997f2ca0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Thursday, August 27, 2015 1:20 AM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs: scrub: set error stats when tree block spanning
> stripes
> 
> On Tue, Aug 25, 2015 at 09:45:27PM +0800, Zhao Lei wrote:
> > It is better to show error stats to user when we found tree block
> > spanning stripes.
> >
> > On a btrfs created by old version of btrfs-convert:
> > Before patch:
> >   # btrfs scrub start -B /dev/vdh
> >   scrub done for 8b342d35-2904-41ab-b3cb-2f929709cf47
> >           scrub started at Tue Aug 25 21:19:09 2015 and finished after
> 00:00:00
> >           total bytes scrubbed: 53.54MiB with 0 errors
> >   # dmesg
> >   ...
> >   [  128.711434] BTRFS error (device vdh): scrub: tree block 27054080
> spanning stripes, ignored. logical=27000832
> >   [  128.712744] BTRFS error (device vdh): scrub: tree block 27054080
> spanning stripes, ignored. logical=27066368
> >   ...
> >
> > After patch:
> >   # btrfs scrub start -B /dev/vdh
> >   scrub done for ff7f844b-7a4e-4b1a-88a9-8252ab25be1b
> >           scrub started at Tue Aug 25 21:42:29 2015 and finished after
> 00:00:00
> >           total bytes scrubbed: 53.60MiB with 2 errors
> >           error details:
> >           corrected errors: 0, uncorrectable errors: 2, unverified errors: 0
> >   ERROR: There are uncorrectable errors.
> 
> I agree that reporting that is a good thing so the syslog is consistent with the
> status output. Is the error really uncorrectable? I'd have to re-read the reports
> and root cause analysis again, but can we do it at least via checker?
> 
This type of error-filesystem is created by old btrfs-convert,
Reported by: Chris Murphy <lists@colorremedies.com>
In maillist, with title:
[BUG] kernel BUG at fs/btrfs/scrub.c:1956!, when scrubbing freshly convert

Then we get the reason: It is caused by bug in btrfs-convert.
Detail is in maillist titled:
RE: [BUG] kernel BUG at fs/btrfs/scrub.c:1956!, when scrubbing freshly converted ext
In 2015-7-23

And fixed btrfs-progs, to avoid creating such a wrong filesystem
with btrfs-convert, and report this type of error in fsck.
With patch titled:
[PATCH 0/4] Metadata crossing stripe boundary fixes
[PATCH 1/4] btrfs: print-tree: print stripe len of a chunk
[PATCH 2/4] btrfs: fsck: Check if a metadata tree block crossing stripe boundary
[PATCH 3/4] btrfs: extent-tree: Avoid allocating tree block that cross stripe boundar
[PATCH 4/4] btrfs: convert: Avoid allocating metadata extent crossing stripe boundary
In 2015-7-23

Also fixed kernel code to avoid panic with:
[PATCH] btrfs: Fix scrub panic when leaf accross stripes in btrfs maillist.
In 2015-7-23

Above patchs are in current btrfs-progs and integration-4.3
branch.

But it is still uncorrectable because neither kernel nor btrfsck can fix
it(only can report).

In short, it is caused by old version of btrfs-convert, and already fixed,
and this patch is used to make scrub report it in output.

Thanks
Zhaolei

> The uncorrectable errors are especially worrisome so I'd like to know what kind
> of answer should we give.

