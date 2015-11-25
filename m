Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:49053 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbbKYLwp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 06:52:45 -0500
Received: from localhost
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 25 Nov 2015 17:22:42 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fdmanana@gmail.com
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        chandan@mykolab.com
Subject: Re: [PATCH 06/12] Fix btrfs/094 to work on non-4k block sized filesystems
Date: Wed, 25 Nov 2015 17:17:58 +0530
Message-ID: <1984236.SDzE0v2Uyc@localhost.localdomain>
In-Reply-To: <CAL3q7H5W9LcoVx9MA9dOdGaeDiNYs1scDz3orN6FGjK+3Pgwog@mail.gmail.com>
References: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com> <1448449386-4186-7-git-send-email-chandan@linux.vnet.ibm.com> <CAL3q7H5W9LcoVx9MA9dOdGaeDiNYs1scDz3orN6FGjK+3Pgwog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 25 Nov 2015 11:11:27 Filipe Manana wrote:
> 
> Hi Chandan,
> 
> I can't agree with this change. We're no longer checking that file
> data is correct after the cloning operations. The md5sum checks were
> exactly for that. So essentially the test is only verifying the clone
> operations don't fail with errors, it no longer checks for data
> corruption...
> 
> Same comment applies to at least a few other patches in the series.

Hello Filipe,

All the tests where we had md5sum being echoed into output have been replaced
with code to verify the md5sum values as shown below,

	if [ $foo_orig_hash != $foo_hash ]; then
		echo "Read operation failed on $SCRATCH_MNT/foo: "\
		     "Mimatching hash values detected."
	fi

This will cause a diff between the test's ideal output versus the output
obtained during the test run.

In case of btrfs/094, I have added an associative array to hold the md5sums 
and
the file content verification is being performed by the following code,

for key in "${!src_fs_hash[@]}"; do
	if [ ${src_fs_hash[$key]} != ${dst_fs_hash[$key]} ]; then
		echo "Mimatching hash value detected against \
$(echo $key | tr _ /)"
	fi
done

-- 
chandan

