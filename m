Received: from outbound.ms.icloud.com (ms-2006f-snip4-11.eps.apple.com [57.103.75.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE3A518151
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 10:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.75.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678077; cv=none; b=prHkFqUBQsQTLgECUAG0JL9/rxz6mkH0C5SemHPeRMwsYRDWSO/pfPzZZR9UjJhgx8UbUVQlfjh1Ii4e5d/NxAGwCl2RYuqK+sKSrxAIWp2xdaR0wSOLGN0LxG2+2jxYHDLswUzNNTRV6n5qG9agvirD0Mm8VUoGV8/dIbXU0K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678077; c=relaxed/simple;
	bh=72nA3C1Eu92ER8mstiL19hWt7vaHzx1degOZJX/k5A4=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=tm2GeGvw911fxU/Ghg0N24vda4t3DYp5phUaY5FWF6LlDgaoVLhS+OPy1c/xKwfF1xK9TdA/PStMfQtV4TgXELCGUdEEtRdKwyzvHmd0ovYtS/Gd/iXNZaHhR4lRX5yAASpjzqj++AnxhUUZKqNgV4A6s3JmvtNJDWEaYftmuQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fenski.pl; spf=fail smtp.mailfrom=fenski.pl; dkim=pass (2048-bit key) header.d=fenski.pl header.i=@fenski.pl header.b=MDbWWKtd; arc=none smtp.client-ip=57.103.75.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fenski.pl
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fenski.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fenski.pl header.i=@fenski.pl header.b="MDbWWKtd"
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-10-percent-0 (Postfix) with ESMTPS id 836EE18000E2;
	Tue, 29 Sep 2026 10:34:19 +0000 (UTC)
X-ICL-RepId: 01a0ecba-ca09-7490-9f1f-f5f29363b4b3
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQhABkMFWAZeAUEdXA5SEhVdRVEMRR9dA0M4VQhZGFkZFwhfTVEPDxZcFkAGXkVCHBkKUFACS1oVVRcOAkIfUB9MFldDWhgcGVoUXBhTRVEfVFhDGUVWaUELTx1dGVscQmRYVwkKDVceShNaQ0cHEh1QHA5RVlwARAlBUgsaXwcVX1UHWFMNH0kATwNABQ4BSFsbUV8FDlNGeR5WA0QAW15JFA1NQxJCFQQbRh5DBF8vXRdeDF4F
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fenski.pl; s=sig1; t=1790678060; x=1793270060; bh=FTVzBkyCSvEIOu50l/nQSqYBOeVQJTpUYf3gC0iRFWE=; h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:x-icloud-hme; b=MDbWWKtdCgi6+KX+q5T5M+ZjSLVB2r+mcG3kAWHwWG/d4cmHpp5A3wc6OEZrfMIKLcQhKZ0Xv0He3aa0vJDL6HXEb0nhslwtksojCTNX1y8HLBm0IcvaCzXQ20/v2opVnTDzwPnal1R5W4QagvJx2EMOXmbJJrdHFzhZ1MpDf+mWOTNLlooSMtpPHIWc1EVxp/P/Yx8K5oMAU+TXazuMiOfIippcqUJQqDJApAe3pkOIvbTgKixAE4YeiBSKeeV3VpWsPb2zhzDNYS860Q0r+Y757W0DR8Wy4AVUtEIToE1V1Pb3F7fyD7oQqutBmVNzcSL9kcjlnxYQItwndOn9Ow==
mail-alias-created-date: 1561792305000
Received: from [10.10.10.17] (unknown [17.156.208.39])
	by p00-icloudmta-asmtp-us-west-3a-10-percent-0 (Postfix) with ESMTPSA id 5C57518000BF;
	Tue, 29 Sep 2026 10:34:18 +0000 (UTC)
Message-ID: <a72409af-45ef-45df-9970-2e38bcb22ea6@fenski.pl>
Date: Tue, 29 Sep 2026 12:34:15 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Qu Wenruo <wqu@suse.com>, Chris Mason <mason@kernel.org>
From: Bartosz Fenski <bartosz@fenski.pl>
Subject: [BUG] btrfs: degraded RAID6 preallocated writes return EIO from
 fdatasync
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: jtDnsP2Ck3syt_aojBytZ9RgL4rvjYsx
X-Proofpoint-GUID: jtDnsP2Ck3syt_aojBytZ9RgL4rvjYsx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA0MiBTYWx0ZWRfX8vj7ZuqQzSHl
 hLw2QiJZI6gXP52BR3izPLbakrDmZdA9eYB+KVIP+/36ss60Wr7oO4fX/juPBZiYNspSPweTPZg
 0G7RL6aX8sWS9ocy+P2sGDDv9B55Xstx3Bs/7+sDEk06feWaH4vwDKTMt/FHczdaHjzOApRsetf
 9f/RIvsIsQHGb47VGLDFuqMuXrTnAZfZtfe8zr5Edd2MwGYG2/FgqTjC7gUozcsGj9P0UZj9hYN
 TduwEHkyYAR4VrU40pKKOyABzBqtg2FSLsaXJx8tgcIexMquzH5seF06wXiaVnfN5TyR6ykJ9Ps
 FSo3xvIG0wla23FZYDy2sxnARLwQEE31cfQc4HtP4bmIm3lGpqOExRK0PT+Ne8=
X-Authority-Info-Out: v=2.4 cv=APQmTc5e c=1 sm=1 tr=0 ts=6abb942b
 cx=c_apl:c_pps:t_out a=kRaGL2Q7qLiahLf3O6OaIA==:117
 a=kRaGL2Q7qLiahLf3O6OaIA==:17 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=mifGbWq9AAAA:20 a=NEAV23lmAAAA:8
 a=AimheMhfzcmf2eYMyMsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bA3UWDv6hWIuX7UZL3qL:22
X-JNJ: AAAAAAABUIzh6Qac6KcCl8hezOYHmSajqgmOA3jINZutUTxE8gm93PNDd+EJN48A5nTd5s7CV7YxiQweuvTHCu+6Zn4tG8FJ+VSCgaQLob8SfkLr9ENWBIaaKt9Ye7u4hxzk1Ghcx/vxvy/SpwtaTFmSJTrCBTVtURPpv+1VYtz/6D39OkwebB4jZef71s/c7Y1RQokb1rYZNEYe49atdKDKhvR4eh5J7KAvtxr8axC4RKzvxIgwFmIrkKSNJVsWex11UlCrmJkDi/GzfY6/lbXg3ZJozGxkuM+FI4SrJiXEWKSR1qC3RWiXzaYzNvsnKzaXI/8OPK8L51TSdS1YihH0MKEoVJGAZ1cmYcRpHj3+QKUsGfTnJS9Pju8MrvQ7/Lf6GzTpECs72SKmFXqXJn4pOXsK/y3zJ6a0bpnB0IdvJGxIf/ANacn4jqeojoSV0zs9HOmiPLjXsvVEzvxLMA6WTxnsEcHmBlhaXgoOgDrUGWcB8VpzjrXtSRt5Sy3spSHj1sY7cNW3JUWiNRp3vZqTrdp+aya0FKAQjr2VoaT+6r1t6iuTMCeiiCPH6wzAkNQPDvibbohJ+T+WCC6uquGR4MUhrkyl+XcB9fxTIS+NRQeKpt5eKrFZnHZVONV73+vPej2oxd78h3ynXzE+zM4U18jd5089z9HAmePi4FuQ6VIeTxwuDTLKSnFpmMGGMhoivCyGCmPjrpeeSm4MtD5IvJKdMU4jgb2vR4YkRqoNqvcb9xix5TyxrDE1wgT7RDOBlOWGfkIn+HNNsl6MynQnvDJYlRg4AbTXtQYUIcbYjvqepdOtYQ2siS0GoyMHwAA4a7nzLzCO/1aiXZGnvnC3NJpXPBNSqaEf+dXeGPA30SNyT6egwMX94Qaq2qdeTbhtmEwMuL1gL8MnIzsKzyuHqvNieVcIRdr3dqaGiF41ETdrZ/g0suoD4M3M2o8XJPQUQeZBLBbgllnCfLPvGCjoKIExS2V
 fZvoJKuBys/4zGzTTwk1lLaAqoq1liHXsa5ctGxAh/WESW64+J0GUf3R2NqxKoTm40GL+zjDbhVjxlWDAFSkuLemE6se8i+OOmsHYtD8wc+xqWOglGEy8HlT+IUFWarva8q+BeZpxI2F5RhuXfjMjQtM536qp3MleAKGx7pUq1UJg40++ofTWUPl7r6nT1gnJniJef9wOdHVXOrQc/xjDyb+6JyV2DmLbPzvsjCN5Og==

Hello,

A fresh four-device Btrfs RAID6 filesystem returns EIO from fdatasync()
when writing to a file preallocated by fio after one device is removed.

The filesystem is clean before the device is removed, one missing device
is within RAID6 tolerance, and all surviving-device error counters remain
zero.

I reproduced this twice on unmodified upstream Linux v7.3-rc5. Both
runs failed after exactly the same number of writes and at the same
fdatasync offset. Disabling fio's preallocation makes the same workload
complete successfully.

Test environment
----------------

Kernel:
   Linux v7.3-rc5
   commit 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
   arm64 defconfig with CONFIG_BTRFS_FS=y and CONFIG_BLK_DEV_LOOP=y
   kernel taint before and after test: 0

Userspace:
   btrfs-progs v6.17.1
   fio 3.41
   Ubuntu 26.04 userspace in an arm64 virtual machine

Filesystem:
   four 16 GiB loop devices
   data profile: RAID6
   metadata profile: RAID1C3
   checksum: crc32c
   sector and page size: 4096 bytes

Reproducer
----------

The complete reproducer is available here:

https://github.com/fenio/modern-fs-benchmark/blob/main/scripts/repro-btrfs-raid6-degraded-write.sh

The failing invocation is:

   sudo env \
     PRELOAD_SIZE=0 \
     FALLOCATE_MODE=default \
     SYNC_MODE=fdatasync16 \
     MISSING_INDEX=1 \
     RUNTIME=10 \
     ./scripts/repro-btrfs-raid6-degraded-write.sh

It performs these operations:

1. Creates four sparse 16 GiB files and attaches them to loop devices.
2. Creates Btrfs with:
      mkfs.btrfs -f -d raid6 -m raid1c3 <four loop devices>
3. Mounts the filesystem and creates a subvolume.
4. Unmounts it and detaches device 2.
5. Mounts it with degraded,noatime.
6. Verifies that device 2 is reported as MISSING.
7. Runs fio random 4 KiB writes to a 1 GiB file with:
      --rw=randwrite
      --bs=4k
      --size=1G
      --runtime=10
      --time_based
      --randrepeat=1
      --fdatasync=16

Actual result
-------------

Both v7.3-rc5 runs failed with:

   fio: io_u error on file degraded-write.0.0:
   Input/output error: datasync offset=368435200, buflen=0

The fio JSON output was identical in both runs:

   error:             5 (EIO)
   bytes written:     5439488
   completed writes:  1328
   successful syncs:  82

After the failure, Btrfs still reported exactly one missing device:

   devid 2 size 0 used 0 path <missing disk> MISSING

All Btrfs device error counters, including those for the missing device,
were zero:

   write_io_errs    0
   read_io_errs     0
   flush_io_errs    0
   corruption_errs  0
   generation_errs  0

There was no kernel warning, Oops, transaction abort, checksum error, or
physical I/O error in dmesg.

Control
-------

Running the same test with fio preallocation disabled succeeds:

   sudo env \
     PRELOAD_SIZE=0 \
     FALLOCATE_MODE=none \
     SYNC_MODE=fdatasync16 \
     MISSING_INDEX=1 \
     RUNTIME=10 \
     ./scripts/repro-btrfs-raid6-degraded-write.sh

The control completed the full runtime with:

   error:             0
   bytes written:     409731072
   completed writes:  100032
   successful syncs:  6252

The filesystem still had the same missing member and all device error
counters remained zero.

Independent x86-64 reproductions
---------------------------------

The same result was independently reproduced on GitHub-hosted Ubuntu
26.04 x86-64 runners using Linux 7.0.0-1012-azure:

https://github.com/fenio/modern-fs-benchmark/actions/runs/36482348497
https://github.com/fenio/modern-fs-benchmark/actions/runs/36482737600

In both runs, the fresh-filesystem/default-preallocation variant failed
at exactly the same point as v7.3-rc5:

   datasync offset:   368435200
   bytes written:     5439488
   completed writes:  1328
   successful syncs:  82

The corresponding fallocate=none control succeeded in both GitHub runs.

Thus the failure has reproduced on both arm64 and x86-64, with two
different kernel builds and virtualization environments.

Possible cause
--------------

This appears to involve checksum verification of reconstructed sectors
which do not themselves have a checksum.

fill_data_csums() allocates zeroed csum_buf and csum_bitmap storage for
the whole data stripe. If any sector has a checksum, those buffers are
retained even though some bits in csum_bitmap can remain clear.

verify_one_sector() currently checks only whether csum_bitmap and
csum_buf exist:

   if (!rbio->csum_bitmap || !rbio->csum_buf)
           return 0;

It does not check whether the bit for the specific reconstructed sector
is set before comparing the reconstructed data against its entry in the
zeroed checksum buffer.

fio's default preallocation creates PREALLOC extents containing a mixture
of written sectors with checksums and unwritten sectors without
checksums. filefrag after the failure confirms that written blocks are
interleaved with unwritten extents.

If a checksum-less sector is reconstructed during degraded RAID6 RMW,
verify_one_sector() appears able to compare it against a zero-filled
checksum slot and return -EIO.

A guard similar to the following before accessing csum_buf may be needed:

   if (!test_bit(rbio_sector_index(rbio, stripe_nr, sector_nr),
                 rbio->csum_bitmap))
           return 0;

The relevant checksum verification was introduced by commit:

   7a3150723061 ("btrfs: raid56: do data csum verification during RMW 
cycle")

Current Btrfs for-next still appears to lack the per-sector bitmap check.

I searched the linux-btrfs archive and did not find an existing report
with this combination of a clean filesystem, one missing RAID6 member,
preallocated extents, and sync-time EIO.

I can test a proposed patch on the same v7.3-rc5 VM.

Regards,
Bartosz Fenski

