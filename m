Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF11BC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 13:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79F64218AC
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 13:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437116AbfBONSR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 08:18:17 -0500
Received: from mout.gmx.net ([212.227.17.22]:57655 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfBONSQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 08:18:16 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MMpYB-1gzpdw3WiF-008c3v; Fri, 15
 Feb 2019 14:18:09 +0100
Subject: Re: [PATCH v5 00/12] btrfs: Enhancement to tree block validation
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190215105044.17619-1-wqu@suse.com>
 <2ebcb996-dd7a-2662-811a-5526fccb03b7@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <18beb5f9-48f5-e519-6abf-08bd1509cde5@gmx.com>
Date:   Fri, 15 Feb 2019 21:18:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <2ebcb996-dd7a-2662-811a-5526fccb03b7@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:H/wURUzG9ay77LdwJL+NgDAgzbO3XctP88Rue6AkYcIgsunctVV
 RDf+mrnPZ3DGbTZzXwUGR2HMVkC+Re4tFL1b8q9qF4DwvGJHdjq3pLMoC/EppwwQXh5hPP6
 QJoRMpHYaDaBU2foEyNKNnx3u472AmXXDLoJ7RtbLChAYTUiVCQN3LG60MOYqqdMG8XQFMP
 DidhSJS42vKdpE1k+iGow==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jAZzxoqVisM=:MaMrGwMr5qVWG7RbUehkev
 GZ44HVBvwTOKvHgyBFMi2SGBclhX71Aplpg6UqxG4etw5yh8nzbAuaLl6GGlKsihGz59Nyumm
 fwJUDaPOorqVonQi9V85GNX8R7BSbRUtmXMVwSSdHbg9p3DI0BssA3pbE8BZlVAIdWrg5DfGm
 iIG8sn8OvtIPvcPMadgDSg0TlxjGiK7vA8F8htALu4dKBnWJRCJnQGs6sDnPIQU5r23nXKlgX
 vurLaq35jLNZPxBJaHEVCeuOCgSqFdybotv61nm0Pv3d0o3RimmgoNnI7XbNxmxIn4m0wSmxo
 S5DWMgxW5L505DJNXwPsKqnGjbXJZmi/bR6RJ/i8KmsROy95sr+URPw5hgEMPBISkHsP0+tTf
 6TI6R1rF5E/oUgJI8U/FrAVr2K1Kk92HD1gwu1Q/5xWVlZlb+iUNccIyTN8D3kv1+kje07OX+
 gCMW2n1HoKWjbT3D96i9qBqwBMQoY/zg2vbJ34YRTZsxFhU/81IEteqmXrZYgXUpEZAwupYHQ
 W5PfIBocKdhqDeyVabzxfuuczEWNUDTAmdctHYmCTBje8/iODrl2/yMTSPwsIeEzxc8ZIt2t1
 5/DM5hLVfoeVy9nKhzU2N34IYk5HA1nyI52+Dul046e9McyKL/VVF++1IYQO5Q7Xj7rOjsHQU
 jemlPzLhctz1QoJYywnqgfrmpF7FHus0xhuul6ZI2jkAdq1yC+yaozPWIrhgd9cTPb76DoV5e
 f5g+PbQsG8CjUUhJ13lXIofQHYo9aSEDompEVrnLGjrdWFQah3QA4/MbYMupf3f/P+qI2u8Wx
 LP9QIkoMc20XYz8ekfTyoF2KRQYGCeMRyE1yH4XCeoF0XxIR9yw2aa2/hfvOnlwt7KEa24Szt
 1CLHMhB+DVLaygXI9O/hpsNE2U3JxlDt02Ky3K6PjCROLZ3/wpr1g+I/eB1IkgApDbo+QFD7o
 rVUu7A7zGyA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/2/15 下午9:10, Nikolay Borisov wrote:
> 
> 
> On 15.02.19 г. 12:50 ч., Qu Wenruo wrote:
>> Patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/write_time_tree_checker
>> Which is based on v5.0-rc1 tag.
>> Also there is no conflict rebasing the patchset to misc-next.
>>
>> This patchset has the following 3 features:
>> - Tree block validation output enhancement
>>   * Output validation failure timing (write time or read time)
>>   * Always output tree block level/key mismatch error message
>>     This part is already submitted and reviewed.
>>
>> - Write time tree block validation check
>>   To catch memory corruption either from hardware or kernel.
>>   Example output would be:
>>
>>     BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
>>     BTRFS error (device dm-3): write time tree block corruption detected
> This is not good.  Those two error messages should be collapsed into
> one. Otherwise it's hard to actually match them up.

That shouldn't be a problem, since the error won't happen so frequently
there is no other error message that could interrupt these 2 lines.

> Better output will
> be "Corrupt leaf detected during writing: root=..." and eliminate "write
> time tree block corruption detected" line. Is that feasible?

Feasible, currently tree checker only get called in 3 locations:
1) read time full checker
2) mark dirty time basic checker
3) write time full checker

And they all have different internal bool to indicate the timing, so
it's possible to output the timing.

But that needs to pass the internal bool down a long long way, for all
the output help to accept an extra string.
I'm not a big fan for that, and prefer a timing neutral tree checker.

Thanks,
Qu

> 
>>     BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
>>     BTRFS info (device dm-3): forced readonly
>>     BTRFS warning (device dm-3): Skipping commit of aborted transaction.
>>     BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=-5 IO failure
>>     BTRFS info (device dm-3): delayed_refs has NO entry
>>
>> - Better error handling before calling flush_write_bio()
>>   One hidden reason of calling flush_write_bio() under all cases is,
>>   flush_write_bio() will trigger endio function and endio function of
>>   epd->bio will free the bio under all cases.
>>   So we're in fact abusing flush_write_bio() as cleanup.
>>
>>   Since now flush_write_bio() has its own return value, we shouldn't call
>>   flush_write_bio() no-brain, here we introduce proper cleanup helper,
>>   end_write_bio(). Now we call flush_write_bio() like:
>>               New                 |           Old
>>   --------------------------------------------------------------
>>   ret = do_some_evil(&epd);       | ret = do_some_evil(&epd);
>>   if (ret < 0) {                  | flush_write_bio(&epd);
>>   	end_write_bio(&epd, ret); | ^^^ submitting half-backed epd->bio?
>>   	return ret;               | return ret;
>>   }                               |
>>   ret = flush_write_bio(&epd);    |
>>   return ret;                     |
>>
>>   Above code should be more streamline for the error handling part.
>>
>> Changelog:
>> v2:
>> - Unlock locked pages in lock_extent_buffer_for_io() for error handling.
>> - Added Reviewed-by tags.
>>
>> v3:
>> - Remove duplicated error message.
>> - Use IS_ENABLED() macro to replace #ifdef.
>> - Added Reviewed-by tags.
>>
>> v4:
>> - Re-organized patch split
>>   Now each BUG_ON() cleanup has its own patch
>> - Dig much further into the call sites to eliminate unexpected >0 return
>>   May be a little paranoid and abuse some ASSERT(), but it should be
>>   much safer against further code change.
>> - Fix the false alert caused by balance and memory pressure
>>   The fix it skip owner checker for non-essential tree at write time.
>>   Since owner root can't always be reliable, either due to commit root
>>   created in current transaction or balance + memory pressure.
>>
>> v5:
>> - Do proper error-out handling other than relying on flush_write_bio()
>>   to clean up.
>>   This has a side effect that no Reviewed-by tags for modified patches.
>> - New comment for why we don't need to do anything about ebp->bio when
>>   submit_one_bio() fails.
>> - Add some Reviewed-by tag.
>>
>> Qu Wenruo (12):
>>   btrfs: Always output error message when key/level verification fails
>>   btrfs: extent_io: Kill the forward declaration of flush_write_bio()
>>   btrfs: disk-io: Show the timing of corrupted tree block explicitly
>>   btrfs: extent_io: Move the BUG_ON() in flush_write_bio() one level up
>>   btrfs: extent_io: Handle error better in extent_write_full_page()
>>   btrfs: extent_io: Handle error better in btree_write_cache_pages()
>>   btrfs: extent_io: Kill the dead branch in extent_write_cache_pages()
>>   btrfs: extent_io: Handle error better in extent_write_locked_range()
>>   btrfs: extent_io: Kill the BUG_ON() in lock_extent_buffer_for_io()
>>   btrfs: extent_io: Kill the BUG_ON() in extent_write_cache_pages()
>>   btrfs: extent_io: Handle error better in extent_writepages()
>>   btrfs: Do mandatory tree block check before submitting bio
>>
>>  fs/btrfs/disk-io.c      |  21 +++--
>>  fs/btrfs/extent_io.c    | 168 ++++++++++++++++++++++++++++------------
>>  fs/btrfs/tree-checker.c |  24 +++++-
>>  fs/btrfs/tree-checker.h |   8 ++
>>  4 files changed, 162 insertions(+), 59 deletions(-)
>>
