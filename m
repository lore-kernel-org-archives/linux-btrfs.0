Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48079 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbcDZPWa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 11:22:30 -0400
Subject: Re: [PATCH V18 00/18] Allow I/O on blocks whose size is less than
 page size
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
CC: <dsterba@suse.cz>, <clm@fb.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <e8e4fc53-93ee-cd46-474d-02fe935802ea@fb.com>
Date: Tue, 26 Apr 2016 11:22:14 -0400
MIME-Version: 1.0
In-Reply-To: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/26/2016 09:26 AM, Chandan Rajendra wrote:
> Btrfs assumes block size to be the same as the machine's page
> size. This would mean that a Btrfs instance created on a 4k page size
> machine (e.g. x86) will not be mountable on machines with larger page
> sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
> incompatibility.
>
> This patchset continues with the work posted previously at
> https://urldefense.proofpoint.com/v2/url?u=http-3A__thread.gmane.org_gmane.comp.file-2Dsystems.btrfs_55257&d=CwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=HOo9J04GyB-3WnF7O0oScGWuin-MaYuh9OMQrAFNE-0&s=ZGXiVRRSCQha83XunflDOkpffSfDEy8OKzFHRud6oXw&e= .
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
>    - With 4k sectorsize, all the tests that succeed with the master
>      branch at git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
>      branch also do so with the patches applied.
> 2. ppc64
>    - With 4k sectorsize, 16k nodesize and with "nospace_cache" mount
>      option, except for scrub and compression tests, all the tests
>      that succeed with the master branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
>      branch also do so with the patches applied.
>    - With 64k sectorsize & nodesize, all the tests that succeed with
>      the master branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
>      branch also do so with the patches applied.
>
> TODO:
> 1. The selftests code needs to be fixed to work in subpage-blocksize
>    scenario. I have currently disabled self-tests from my kernel
>    configuration. We can expect an mail from kbuild indicating a
>    build failure for self-tests code.
> 2. I am planning to fix Scrub & Compression via a separate patchset.
>

The selftests need to pass, I don't want to have to deal with kbuild 
failures and have to remember it's because selftests don't work right 
with sub page blocksizes.  Thanks,

Josef

