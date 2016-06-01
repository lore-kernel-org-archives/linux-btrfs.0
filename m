Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6563 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755474AbcFAROR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 13:14:17 -0400
Subject: Re: [PATCH V2 0/8] Btrfs: self-tests: Support non-4k page size
To: Feifei Xu <xufeifei@linux.vnet.ibm.com>, <linux-btrfs@vger.kernel.org>
References: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
CC: <steve.capper@linaro.org>, <chandan@mykolab.com>, <dsterba@suse.com>,
        <chandan@linux.vnet.ibm.com>, <feifeixu.sh@gmail.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <a019c0ce-29cc-a719-0920-a77965654f9f@fb.com>
Date: Wed, 1 Jun 2016 13:13:47 -0400
MIME-Version: 1.0
In-Reply-To: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/01/2016 11:51 AM, Feifei Xu wrote:
> Hi,
>
> Btrfs self-test module assumed that both sectorsize and PAGE_SIZE are 4K.
> Thus many self-tests fail on non-4K page size systems, like ppc64. This
> patchset enables self-tests to be executed on non-4k page size systems.
>
> This patchset enables us to easily add support for possible sectorsizes and
> nodesizes (e.g. for future subpage-blocksize support).
>
> This patchset also fixes the following bugs in self-tests:
>  1) Fix integer overflow when calculating bytes_per_bitmap
>  2) Fix infinite loop when searching for free space
>  3) Fix extent test_bitmaps fail on 64k sectorsize system
>  4) Fix extent buffer bitmap test fail on big-endian system
>
> Also use macros instead of constants add add missing newline
> when print strings in self-tests codes.
>
> -----
> V1->V2:
>   1) use rb_next(&tmp->offset_index)/rb_prev(&tmp->offset_index) instead
>      of doing the info = tmp thing. As suggested by Josef Bacik.
>
>   2) Separate V1 patch "[PATCH 3/5] Btrfs: self-tests: Support non-4k
>      page size" to following  patches in V2.
> 	- [PATCH V2 3/8] Btrfs: self-tests: Support non-4k page size
> 	- [PATCH V2 4/8] Btrfs: self-tests: Execute page straddling
> 		test only when nodesize < PAGE_SIZE
> 	- [PATCH V2 5/8] Btrfs: self-tests: Support testing all
> 		possible sectorsizes and nodesizes
> 	- [PATCH V2 6/8] Btrfs: self-tests: Use macros instead of
> 		constants and add missing newline
>      As suggested by David Sterba that separate all change that are not
>      related to hardcoded 4096/sectorsize/PAGE_SIZE.
>
>   3) fix some coding style issue

You can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

