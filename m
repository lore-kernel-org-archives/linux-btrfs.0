Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([125.16.236.5]:54835 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbcB2FxB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Feb 2016 00:53:01 -0500
Received: from localhost
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 29 Feb 2016 11:22:58 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u1T5qshw45350928
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Feb 2016 11:22:55 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u1T5qpqq023268
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Feb 2016 11:22:53 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com
Cc: jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH V15 00/15] Btrfs: Subpagesize-blocksize: Allow I/O on blocks whose size is less than page size
Date: Mon, 29 Feb 2016 11:22:48 +0530
Message-ID: <2493765.95l8sSnlWq@localhost.localdomain>
In-Reply-To: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 11 Feb 2016 23:17:38 Chandan Rajendra wrote:
> Btrfs assumes block size to be the same as the machine's page
> size. This would mean that a Btrfs instance created on a 4k page size
> machine (e.g. x86) will not be mountable on machines with larger page
> sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
> incompatibility.
> 
> This patchset continues with the work posted previously at
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/52815.
> 
> I have reverted the upstream commit "btrfs: fix lockups from
> btrfs_clear_path_blocking" (f82c458a2c3ffb94b431fc6ad791a79df1b3713e)
> since this led to soft-lockups when the patch "Btrfs:
> subpagesize-blocksize: Prevent writes to an extent buffer when
> PG_writeback flag is set" is applied. During 2015's Vault Conference
> Btrfs meetup, Chris Mason had suggested that he will write up a
> suitable locking function to be used when writing dirty pages that map
> metadata blocks. Until we have a suitable locking function available,
> this patchset temporarily disables the commit
> f82c458a2c3ffb94b431fc6ad791a79df1b3713e.
> 
> The commits for the Btrfs kernel module can be found at
> https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.
> 
> To create a filesystem with block size < page size, a patched version
> of the Btrfs-progs package is required. The corresponding fixes for
> Btrfs-progs can be found at
> https://github.com/chandanr/btrfs-progs/tree/btrfs/subpagesize-blocksize.
> 
> Fstests run status:
> 1. x86_64
>    - With 4k sectorsize, all the tests that succeed with
>      linux-btrfs/integration-4.5 branch also do so with the patches
>      applied.
>    - With 2k sectorsize, all the *generic* tests that succeed with
>      linux-btrfs/integration-4.5 branch also do so with the patches
>      applied.
> 2. ppc64
>    - With 4k sectorsize, 16k nodesize and with "nospace_cache" mount
>      option, all the *generic* tests that succeed with
>      linux-btrfs/integration-4.5 branch also do so with the patches
>      applied.
>    - With 64k sectorsize & nodesize, all the tests that succeed with
>      linux-btrfs/integration-4.5 branch also do so with the patches
>      applied.
>

Hi Chris/Josef,

Can you please look into the patchset and provide review comments if any. I am
hoping to get the patchset merged by linux-4.6.

-- 
chandan

