Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59754 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554AbcFQRIL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 13:08:11 -0400
Date: Fri, 17 Jun 2016 13:07:14 -0400
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Btrfs fixes for 4.7-rc4
Message-ID: <20160617170713.GA72371@clm-mbp.thefacebook.com>
References: <cover.1466182369.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <cover.1466182369.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 17, 2016 at 07:02:09PM +0200, David Sterba wrote:
>Hi,
>
>there are a few fixes of things introduced during this dev cycle, the
>supreblock validation was too eager and refuses to mount valid fileystems. We
>need to fix in on the progs side but for the time being the wrong stripesize
>value (4096) must be accepted. Other than that a few more bugfixes. Thanks.
>
>The following changes since commit 719da39a61173c849f70656ed1a302e4b6deaa5b:
>
>  Merge branch 'misc-fixes-4.7' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.7 (2016-06-08 14:36:12 -0700)
>
>are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris
>
>for you to fetch changes up to dd5c93111dc9d26e038ac437f7a403d617e82c62:
>
>  Btrfs: btrfs_check_super_valid: Allow 4096 as stripesize (2016-06-17 18:32:49 +0200)

Thanks Dave, I'm starting test runs here on these.

-chris
