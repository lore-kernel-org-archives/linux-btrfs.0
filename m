Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11780 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752822AbaEHCFG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 22:05:06 -0400
Message-ID: <536AE6BE.5040505@cn.fujitsu.com>
Date: Thu, 8 May 2014 10:06:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2 10/10] Btrfs: reclaim the reserved metadata space at
 background
References: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com> <1394085304-32589-10-git-send-email-miaox@cn.fujitsu.com> <531DBF91.60701@fb.com>
In-Reply-To: <531DBF91.60701@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 10 Mar 2014 09:35:13 -0400, Josef Bacik wrote:
> On 03/06/2014 12:55 AM, Miao Xie wrote:
>> Before applying this patch, the task had to reclaim the metadata
>> space by itself if the metadata space was not enough. And When the
>> task started the space reclamation, all the other tasks which
>> wanted to reserve the metadata space were blocked. At some cases,
>> they would be blocked for a long time, it made the performance
>> fluctuate wildly.
>>
>> So we introduce the background metadata space reclamation, when the
>> space is about to be exhausted, we insert a reclaim work into the
>> workqueue, the worker of the workqueue helps us to reclaim the
>> reserved space at the background. By this way, the tasks needn't
>> reclaim the space by themselves at most cases, and even if the
>> tasks have to reclaim the space or are blocked for the space
>> reclamation, they will get enough space more quickly.
>>
>> We needn't worry about the early enospc problem because all the
>> reclaim work is serialized by the lock.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> 
> This causes generic/015 to fail with early enospc, I'm kicking this
> patch out, I'll take the rest.  Thanks,

It is not early enospc problem.

This test is to check that the space of the file is released immediately
or not after the file is deleted. In fact, the result of the test is
unstable, because the kernel may be syncing the file data when we delete
it, if so the space of file would not be released immediately.

But the case I said above is rare because the size of fs in this test is
just 50MB, and the memory size of the most machine is very large(maybe > 1GB),
that is the dirty pages is not so many, the background flusher may not
be waked up immediately, so no one holds the inode of the test file after
we delete it, and then the space of it can be released immediately.

After applying this patch, we will flush the dirty pages because our background
metadata space reclaimer finds that the metadata space is going to be used up
(< 5% of the total metadata size), and need flush dirty pages to reclaim some
delalloc metadata space. that is this patch makes the above case happen easily.

Anyway, we need improve this patch though it is not a bug. I will send out
a new one.

Thanks
Miao

> 
> Josef
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQIcBAEBAgAGBQJTHb+NAAoJEANb+wAKly3BCcUP/jGmW85hiurfTF7eom+wzDcr
> nxqvdTB/F21UJU1RRrb92CdYRYb9d4hHKhXE5OK+qamE+K55GEtgCUWCLQgDfJJL
> Wx0aUD/pTqv3J5S5zM43UBJkn2ZR99Q7hJzm9PPMSMn7hBgK87QUEme8HerCPUgY
> 0VS4OcqUGhg88qO8GjdEFLnHawhjMDw9iGPUi+tMdCEmr9aQQo8ntiahdVKyTHej
> vSRQRs0igvAt73OWHXiP6vc4LOQdu1vKCFdbxhgg+duKjNOHfUoaiiaUiGhWIA9l
> BcTWd62bEJNOaXd6k06GzhpCWzMM6faTLfjI6XADUFY0VZ79akzk2KAO6YdaLz8w
> 3IAKN1chTpr7q7oPuRDgDQuwwdeLPImN29CKlAF3jlSRJEblM8CKoXYD1fyqVwDy
> c1mA6mMUJnEnXrkJ/Pb5zuNIZMAlU+v3d6CCjYKHMACORvJeZVlg9gLLMATaAJIA
> xLjFlzbgSbp/OUNuBuS4YGIaa51aAyODd2h1T3E+T5JYbVkA39N3Ni9HODE8AuSE
> E6U/06FK47L0e5uGFrM3tMTL0XBF62C1iml4NsjOWgiERz8lFDdFVArgXamCVacM
> 1+VdeLLS88RHFEuwlMBy/ZQBdnvWCVsNVjYukuxntmWbSWrsLUFUSzExWnp+7TAO
> xkEd2yMw75yasTVGKSXU
> =Q/fM
> -----END PGP SIGNATURE-----
> 

