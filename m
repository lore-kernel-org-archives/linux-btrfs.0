Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A83C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 19:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 300EF21527
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 19:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="C9bOC/wq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 300EF21527
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbeI0CKj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 22:10:39 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:39512 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726107AbeI0CKi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 22:10:38 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5FuigzQpaq9Au5Fukgj12G; Wed, 26 Sep 2018 21:56:04 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1537991764; bh=n+totKcpuO+Iiz43inABlNFXfvWjbql1HRg9GbT5OWc=;
        h=From:Subject:Reply-To:To:Cc:References:Date:In-Reply-To;
        b=C9bOC/wqrvo2ujdKONn7ihf+4GttaTbUBgKxmAYOT/kB8XbwjSWens139+Lfxrs2n
         zT9VVYxMwmU2qummWUJYHGh7FEtFRM98pbbBDX2D6zRAqXzqiOLKLys0Rsv4qyc38L
         8HwDK6yUzXx1BiSlH3lPnjbCQ8C/MYjuOauYSKlugYVFo/mW3lZgIFJaICgFvNF5J/
         4KZhDR2VhGrQNvUNAJsqrVeib3wPiUwKUtvMEV5LxyKSKBjTKTZBV7RfKoIdG9Gm7N
         b7vwg+RGLARAbkMwkiEv/Fjm7Hll+MJxf9l2yoYV8YKsWEgtvMDEsuJkML0qSzbH1X
         tlavySMOOTDzg==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17
 a=IkcTkHD0fZMA:10 a=9jdYIcdj8tBjsKatQBAA:9 a=QEXdDO2ut3YA:10
From:   Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 7/9] btrfs: Add support for recovery for a RAID 5 btrfs
 profiles.
Reply-To: kreijack@inwind.it
To:     Daniel Kiper <dkiper@net-space.pl>
Cc:     grub-devel@gnu.org, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <20180919184040.22540-1-kreijack@libero.it>
 <20180919184040.22540-8-kreijack@libero.it>
 <20180925191032.GD30715@router-fw-old.i.net-space.pl>
Openpgp: preference=signencrypt
Autocrypt: addr=kreijack@libero.it; prefer-encrypt=mutual; keydata=
 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
Message-ID: <e9cd180c-2cc4-e6e2-1b9c-00a3dd353097@libero.it>
Date:   Wed, 26 Sep 2018 21:55:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180925191032.GD30715@router-fw-old.i.net-space.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfEgLGAsgAnlm8uNiLFY/R6Yy/MYxIzdNvqXSQZ54n4HdtVDBGwwuSH4ofxbd8pJvgoqco+wWRcGV7VmPD9egG+sRlsH3PQ/yc8A5G4adHC947rHgVjHT
 A2tjFczpGxQIa2oznKq9/CU4XhgPOk1ogfSZ7LKm/JOoDTFDACcPXIUf1YZ9F+YibJYHvuaQSdAhhGfYKpHtOhgKXpzV28hX3uNmamDy/yGoXUc2150yZ1sj
 kjzV5P9b669NdvC7DHa41sTqpTo/fK8sCUI59VocgmI=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 25/09/2018 21.10, Daniel Kiper wrote:
> On Wed, Sep 19, 2018 at 08:40:38PM +0200, Goffredo Baroncelli wrote:
>> From: Goffredo Baroncelli <kreijack@inwind.it>
>>
>> Add support for recovery for a RAID 5 btrfs profile. In addition
>> it is added some code as preparatory work for RAID 6 recovery code.
>>
>> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
>> ---
>>  grub-core/fs/btrfs.c | 169 +++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 164 insertions(+), 5 deletions(-)
>>
>> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
>> index 5c1ebae77..55a7eeffc 100644
>> --- a/grub-core/fs/btrfs.c
>> +++ b/grub-core/fs/btrfs.c
>> @@ -29,6 +29,7 @@
>>  #include <minilzo.h>
>>  #include <grub/i18n.h>
>>  #include <grub/btrfs.h>
>> +#include <grub/crypto.h>
>>
>>  GRUB_MOD_LICENSE ("GPLv3+");
>>
>> @@ -665,6 +666,148 @@ btrfs_read_from_chunk (struct grub_btrfs_data *data,
>>      return err;
>>  }
>>
>> +struct raid56_buffer {
>> +  void *buf;
>> +  int  data_is_valid;
>> +};
>> +
>> +static void
>> +rebuild_raid5 (char *dest, struct raid56_buffer *buffers,
>> +	       grub_uint64_t nstripes, grub_uint64_t csize)
>> +{
>> +  grub_uint64_t i;
>> +  int first;
>> +
>> +  i = 0;
>> +  while (buffers[i].data_is_valid && i < nstripes)
>> +    ++i;
> 
> for (i = 0; buffers[i].data_is_valid && i < nstripes; i++);
> 
>> +  if (i == nstripes)
>> +    {
>> +      grub_dprintf ("btrfs", "called rebuild_raid5(), but all disks are OK\n");
>> +      return;
>> +    }
>> +
>> +  grub_dprintf ("btrfs", "rebuilding RAID 5 stripe #%" PRIuGRUB_UINT64_T "\n",
>> +	        i);
> 
> One line here please.
> 
>> +  for (i = 0, first = 1; i < nstripes; i++)
>> +    {
>> +      if (!buffers[i].data_is_valid)
>> +	continue;
>> +
>> +      if (first) {
>> +	grub_memcpy(dest, buffers[i].buf, csize);
>> +	first = 0;
>> +      } else
>> +	grub_crypto_xor (dest, dest, buffers[i].buf, csize);
>> +
>> +    }
> 
> Hmmm... I think that this function can be simpler. You can drop first
> while/for and "if (i == nstripes)". Then here:
> 
> if (first) {
>   grub_dprintf ("btrfs", "called rebuild_raid5(), but all disks are OK\n");
> 
> Am I right?

Ehm.. no. The "if" is an internal check to avoid BUG. rebuild_raid5() should be called only if some disk is missed.
To perform this control, the code checks if all buffers are valid. Otherwise there is an internal BUG.

Checking "first" is a completely different test.

>> +}
>> +
>> +static grub_err_t
>> +raid56_read_retry (struct grub_btrfs_data *data,
>> +		   struct grub_btrfs_chunk_item *chunk,
>> +		   grub_uint64_t stripe_offset,
>> +		   grub_uint64_t csize, void *buf)
>> +{
>> +  struct raid56_buffer *buffers;
>> +  grub_uint64_t nstripes = grub_le_to_cpu16 (chunk->nstripes);
>> +  grub_uint64_t chunk_type = grub_le_to_cpu64 (chunk->type);
>> +  grub_err_t ret = GRUB_ERR_NONE;
> 
> s/GRUB_ERR_NONE/GRUB_ERR_OUT_OF_MEMORY/ and then you can drop at
> least two relevant assigments and some curly brackets. Of course
> before cleanup label you have to add ret = GRUB_ERR_NONE.
> 
>> +  grub_uint64_t i, failed_devices;
>> +
>> +  buffers = grub_zalloc (sizeof(*buffers) * nstripes);
>> +  if (!buffers)
>> +    {
>> +      ret = GRUB_ERR_OUT_OF_MEMORY;
>> +      goto cleanup;
>> +    }
>> +
>> +  for (i = 0; i < nstripes; i++)
>> +    {
>> +      buffers[i].buf = grub_zalloc (csize);
>> +      if (!buffers[i].buf)
>> +	{
>> +	  ret = GRUB_ERR_OUT_OF_MEMORY;
>> +	  goto cleanup;
>> +	}
>> +    }
>> +
>> +  for (failed_devices = 0, i = 0; i < nstripes; i++)
>> +    {
>> +      struct grub_btrfs_chunk_stripe *stripe;
>> +      grub_disk_addr_t paddr;
>> +      grub_device_t dev;
>> +      grub_err_t err2;
> 
> s/err2/err/?

Ok

> 
>> +
>> +      stripe = (struct grub_btrfs_chunk_stripe *) (chunk + 1);
>> +      stripe += i;
> 
> Why not stripe = ((struct grub_btrfs_chunk_stripe *) (chunk + 1)) + i;?

Make sense
> 
> Daniel
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5


