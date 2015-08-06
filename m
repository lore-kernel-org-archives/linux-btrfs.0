Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35011 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbbHFCA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 22:00:26 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
References: <a2853778dc15eec5eb3b09ddcc3b3e911254c19a.1438763531.git.zhaolei@cn.fujitsu.com> <20150805165038.GD31669@twin.jikos.cz>
In-Reply-To: <20150805165038.GD31669@twin.jikos.cz>
Subject: RE: [PATCH] btrfs-progs: Modify confuse error message in scrub
Date: Thu, 6 Aug 2015 10:00:07 +0800
Message-ID: <0b9601d0cfeb$9edd45b0$dc97d110$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

Thanks for review this patch.

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.com]
> Sent: Thursday, August 06, 2015 12:51 AM
> To: Zhao Lei
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs-progs: Modify confuse error message in scrub
> 
> On Wed, Aug 05, 2015 at 04:32:26PM +0800, Zhao Lei wrote:
> > Scrub output following error message in my test:
> >   ERROR: scrubbing /var/ltf/tester/scratch_mnt failed for device id 5
> > (Success)
> >
> > It is caused by a broken kernel and fs,
> 
> In what way is it broken? Can we turn it into tests?
> 
It is caused by my custom-made condition, created for debugg
another problem in kernel code, and see above outout in xfstests.

It is not a real problem for normal user, so not necessary to add
A testcase to fstests and user-land tests.

But for btrfs-progs, it should not output such message on any case,
this is what this patch fixed.

> > but the we need to avoid
> > outputting both "error and success" in oneline message as above.
> >
> > This patch modified above message to:
> >   ERROR: scrubbing /var/ltf/tester/scratch_mnt failed for device id 5,
> > ret=1, errno=0(Success)
> 
> The net effect of the patch is to add ret=.. and errno=.. to the error message
> but it also changes a series of ifs to a switch. This belongs to a separate patch.
OK, will send v2.

Thanks
Zhaolei


