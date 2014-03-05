Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42290 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757518AbaCEPDE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Mar 2014 10:03:04 -0500
Message-ID: <53173C95.5030103@fb.com>
Date: Wed, 5 Mar 2014 10:02:45 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 5/5] Btrfs: fix broken free space cache after the
 system crashed
References: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com> <1389787258-10865-5-git-send-email-miaox@cn.fujitsu.com> <5315EEF8.7030908@fb.com> <5316CBEC.7070309@cn.fujitsu.com>
In-Reply-To: <5316CBEC.7070309@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/05/2014 02:02 AM, Miao Xie wrote:
> On Tue, 4 Mar 2014 10:19:20 -0500, Josef Bacik wrote: On 01/15/2014
> 07:00 AM, Miao Xie wrote:
>>>> When we mounted the filesystem after the crash, we got the 
>>>> following message: BTRFS error (device xxx): block group
>>>> 4315938816 has wrong amount of free space BTRFS error (device
>>>> xxx): failed to load free space cache for block group
>>>> 4315938816
>>>> 
>>>> It is because we didn't update the metadata of the allocated
>>>> space until the file data was written into the disk. During
>>>> this time, there was no information about the allocated
>>>> spaces in either the extent tree nor the free space cache.
>>>> when we wrote out the free space cache at this time, those
>>>> spaces were lost.
>>>> 
>>>> In ordered to fix this problem, I use a state tree for every
>>>> block group to record those allocated spaces. We record the
>>>> information when they are allocated, and clean up the
>>>> information after the metadata update. Besides that, we also
>>>> introduce a read-write semaphore to avoid the race between
>>>> the allocation and the free space cache write out.
>>>> 
>>>> Only data block groups had this problem, so the above change
>>>> is just for data space allocation.
>>>> 
> 
> I didn't like this idea at first but I've come around to it.  The
> only thing is the data_rwsem thing, we don't need it as we are
> protected by the transaction being blocked when we do writeout, so
> nobody can data allocations during this time.  Thanks,
> 
>> But this protection was removed by the patch
> 
>> Commit ID: 00361589d2eebd90fca022148c763e40d3e90871
> 

Excellent point, then I'm good overall, I'll pull it in once I finish
qgroups.  Thanks,

Josef
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFzyJAAoJEANb+wAKly3BFHMP+wctKXDuKxP4kI27bfRlfJmV
QB5i6qXr4WvQQw04FF3BtxCW9Z36l/1cFLFK0OaQ8Q54+4s0FUXNAynXFkf41TJz
XWhkjTq0hJmzM95tB2+B2HwtEDI6m0l6fnOhsyiiSHF8V1g7V9VRwkeqpB9ZGu4/
ZryAUkSJGXFDvtFgTmRvOAclwD0R6oCXCw3f/AgtZQL1H9ucaogI2XKmllllcsFC
jOIbn7L+gtFmTAJdvSFlRQAYaV2g69rf0Q5bVHZMAaLKN5rMIXBC2xFOCUxwg3si
ZyOl72ojaGbCt7MI/s2X0uZ5d+xWYjaG+tF2K+XLjFoIUkny3RndFfU6pKk54gHP
9O/GXiilq2t3qZUn3zMuLXIG+cCaYTt3QsHnNyJisqOVLL95LbIvsINm0Xgu6bF/
cJ0acApJr6y2EdEbfVU/mrB06K81bxnZez8rOgyFXKD4yWoTMG23xttKZHG5LbdT
xkwrJWPeJ77mI0+V/MPWePgomcH5cDs0IckSOXXwy8gZF4HJzVbXklcq22BfgIQA
SLVgJYxqIlzIHYHZPisWJHUwFXe4C58YCDP2w4FI32g5LZuzhlus/wFI9Tg1543w
sYf23ZYxlDUYAiD+zb+UipEA4CLtdZgZGonoG9lxK9JkgU2VHzXuTgty2+B0F9kt
l3B5jpy1H2cP2TUskkbZ
=E0en
-----END PGP SIGNATURE-----
