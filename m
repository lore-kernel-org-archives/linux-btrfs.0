Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55754 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbaCEHO6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Mar 2014 02:14:58 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2570KuU029327
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Mar 2014 15:00:21 +0800
Message-ID: <5316CBEC.7070309@cn.fujitsu.com>
Date: Wed, 05 Mar 2014 15:02:04 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] Btrfs: fix broken free space cache after the
 system crashed
References: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com> <1389787258-10865-5-git-send-email-miaox@cn.fujitsu.com> <5315EEF8.7030908@fb.com>
In-Reply-To: <5315EEF8.7030908@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 4 Mar 2014 10:19:20 -0500, Josef Bacik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 01/15/2014 07:00 AM, Miao Xie wrote:
>> When we mounted the filesystem after the crash, we got the
>> following message: BTRFS error (device xxx): block group 4315938816
>> has wrong amount of free space BTRFS error (device xxx): failed to
>> load free space cache for block group 4315938816
>>
>> It is because we didn't update the metadata of the allocated space
>> until the file data was written into the disk. During this time,
>> there was no information about the allocated spaces in either the
>> extent tree nor the free space cache. when we wrote out the free
>> space cache at this time, those spaces were lost.
>>
>> In ordered to fix this problem, I use a state tree for every block
>> group to record those allocated spaces. We record the information
>> when they are allocated, and clean up the information after the
>> metadata update. Besides that, we also introduce a read-write
>> semaphore to avoid the race between the allocation and the free
>> space cache write out.
>>
>> Only data block groups had this problem, so the above change is
>> just for data space allocation.
>>
> 
> I didn't like this idea at first but I've come around to it.  The only
> thing is the data_rwsem thing, we don't need it as we are protected by
> the transaction being blocked when we do writeout, so nobody can data
> allocations during this time.  Thanks,

But this protection was removed by the patch

  Commit ID: 00361589d2eebd90fca022148c763e40d3e90871

Thanks
Miao

> 
> Josef
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQIcBAEBAgAGBQJTFe73AAoJEANb+wAKly3BMMMP/1yY3WBGzaz5oTyNRRSgnVvl
> sjk7WSN2A0mhrl6lQOBlTvhgFo3gDNAtIwJaJIfWxWXZfM5i1hXSViFIc5NND3lF
> Jm10oaCPiTaYM0S5jqj8oeSXFyb1ny+/D4C1OfC/eRVpu9juO3bFUZYcM1XMFUcI
> mJxXg9Mqi1C6TOocCIdQI7ijXgm8xEPauaQy71EJZmgSjjVAXFG9BHay26L2a3Yu
> XIlnjyHMcgIFZXGVHQ+45S2pwWVgVZBIHLcKFSDFy4aupq/+EAN15oxdeTLBG8hJ
> RFJh15wLQguawlirc7boPzEugSieixbbUjn6CZqikVZke1g1fjGvrTAjiacpTDxv
> jskrCPYaXYWKMqGjugsVSI8GSonuWmmVRBsg4k+52U9AYM8wapjL+RHzBXU1cBqu
> zfyqaJhBj7EOQIu2oQDT2ZF9E+XA8dLcrysasMS+CYmcmR1Bs1fzpP2W3DoOg68F
> YoYuXnaAvIkvUQSsPUNGPjCn+iGCq65ZwiwnwF93RN7zlFIQt12DSn7l/NKnT/p9
> 1jvLkQ2MFmb6QD264mAOL5TULWyyB0AXsitIBJOMs0XWXZheLqqpv1clcaZacBFH
> P1yN51+d8DJmF0x0j1HacWi62WnGCh8GzR5ef5Pqi11/11xknbPugrzfFI9v1vR7
> STfhGs/0sg7oQWYgarOj
> =Y2df
> -----END PGP SIGNATURE-----
> 

