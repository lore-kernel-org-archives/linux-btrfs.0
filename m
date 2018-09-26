Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614BDC43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 19:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D908821527
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 19:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="nneKaXUN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D908821527
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbeI0CKg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 22:10:36 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:39512 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726107AbeI0CKf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 22:10:35 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5FudgzQlfq9Au5Fudgj10z; Wed, 26 Sep 2018 21:55:57 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1537991757; bh=zt9A1XmhPVRjluq8XGb2rfmmuan37Zhk5ZgEubloy7A=;
        h=From:Subject:Reply-To:To:Cc:References:Date:In-Reply-To;
        b=nneKaXUNhIMaVvf9qhuoN3cTZYMGTrgxE7YXHRgfU2Vijak5zHdjrKzVKNk8EAWVk
         raDREOscBRxOZC7PGt4N1OD5M4uiMy8ECxqUztHuNbQHhmgvcbGK90GSjvhyEnjvUn
         2BhxkzeJ6dwDQN+sZg8hbm6daFZhQMvHpgQcH/0SFj5LLBiqhm4Nas71h0YugxMZ8f
         nQg8NGn4z7WyPX0ag0U3dx6Cp6H4BgUokNQ4S6Asx4GkKtxVs9hhPhH5vNXFZKlrZq
         Fh0fQhycxOAn4R9fCHNDVXPxsbT4PET4Z7PsLUmBuEjWI3S6HNXnA5rj+A40EqsodJ
         R4sKDme7XkFQw==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17
 a=IkcTkHD0fZMA:10 a=tdgEUAKCtwtIJcxg25wA:9 a=QEXdDO2ut3YA:10
From:   Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 4/9] btrfs: Avoid a rescan for a device which was already not
 found.
Reply-To: kreijack@inwind.it
To:     Daniel Kiper <dkiper@net-space.pl>
Cc:     grub-devel@gnu.org, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <20180919184040.22540-1-kreijack@libero.it>
 <20180919184040.22540-5-kreijack@libero.it>
 <20180925172931.GC30715@router-fw-old.i.net-space.pl>
Openpgp: preference=signencrypt
Autocrypt: addr=kreijack@libero.it; prefer-encrypt=mutual; keydata=
 mQINBFCBjk8BEADu0/Wq3RUaW9xXLkvv10HPt13XeA5Kso23CVg6ngNvpNy2jDyBAxKxgYpe
 D0YzGHB1p/TKP5/XXe5WPkNGHEYebo0WxjSBujFhDp1HCeuClieLH/itT92OFbw5MMa3EGRk
 pqOV/4EGslgdNaSwxLr6JGjRCOabweKIDBs44fGPUKVbT6D3q3i+l+ZGabREzlGzvmtztPyr
 PMcnWc2UPDqzj0s4w7nOH5wHzVD6yee7GotWF8BzWrYNytHQknO7YbTF9dpcyTCVNWFxL9U7
 6iweJL1CZONgLxjsl7uWFKM0zL24hhekMoghOOUyoT+UQa0h3EaXO6HH62fd+tqXM4vH67dX
 s/ToK+qvSbZQfFh8hZsNUxCLBsKKAP7N7nNLaxuMVEfpupqjrbGSvJUI3lngCAMrRPd7IkyT
 FUppDMjVlmA+oOMJs/MAfJ9CdsA14+2a+8Hoqrt2XU/gk19GGtAiZ6JG8V8xOx8ha2pCuQ9u
 2UM/kRc97k/cAsibxwGZE/TdUFv0uGMR2KjAbPlsRg8fQcyuVA8FnJwfoBRXRCSEWe/riuip
 cFc8UjcPZcfGXSifzIpWFc3q3WIF67CCEhwgQLPgkq5y6/KONY2we2hYXiucE0l6JNLUcIi1
 ZI0HAqo9ZsQTuRX+OoM0Er6gf4KTrgtEiXGB1sQ9ZAZiIU+4+QARAQABtDBHb2ZmcmVkbyBC
 YXJvbmNlbGxpIChnaGlnbykgPGtyZWlqYWNrQGxpYmVyby5pdD6JAlUEEwECAD8CGwMGCwkI
 BwMCBhUIAgkKCwQWAgMBAh4BAheAFiEEu/UWEAtk2sZffReyDtqbN4uC4LUFAlrjTTQFCQxC
 8lwACgkQDtqbN4uC4LU90g//SRp5t42BfzKm6u26FIKJPNTt4QXaAgyAGMVN549I0l+YROzG
 ITgk27K/Br4nSpqGJljqfrcZHDKeHtgQ4ris7u/DUS6rlvVv9NmF35NpR3zxUmBT6MPXVl/u
 3B22L+/bsD9D1dtDbCqwJITaXz+4txnAmKM+qUt7myx7ZPJDVHVKi//67yf4JBxtG6in+KZ9
 5zs52I+xxRQs0vYEqK41N34VYiXIJP1rXxuxZ3gHVJP+tYDcDR7PInJ+rMlucBUd6PcV/D6M
 pnB3yz2C3HH+8Rl1jemXDgLeOazRXiJ7H/1dw7xRcCNq1wdv3DBkWQ57do3+hLe6br2zyEC5
 MG1TYhtoXTI3qL/uejB+ldIkFIwAW7ViUshN28coMUqE17f/0O8nLgNMZQ0ZwxXSo+mitHAy
 DkooxlOpwVD1l7/EEk97i3+OmAF+5h/b1rLWzmZcD/gHx3ac8sPx83ftAXoeZCrI5wVQRfvL
 fV4RA9uAmtNKMu20VVVBCWsJbeJ6P0hZglNbCQeuWkkjeiLFG8i/MmXhWm5Pd7aUf4mTeOzw
 KCBZdzfU82Yh/1uTOb6PZMRIrnxguO1rh4FYKGzyBa88mPU6xXu6Wn7monTOiDpgxIWv8XUm
 txROWya0/O74rGPZxD6FQv3t4bROUO3G6fXreQYACsF5mrgPOWOHv47p2SS5Ag0EUIGOTwEQ
 AMMPbyrahlAtk2sr5APDPLXuDaIKw5h5dcuWaQj9yuOhDtnd0nGi9OYROMs6M4lfy4HK0mfO
 Ruw3cvMrzBUMozS54WIWPzkYfUXN87Jy9zEZ+T+FwRI2QEWPp3k2iZLkGqXaLREqvwHLXfcm
 dyJbRinI7sCBgAWh48S3vdIiXIcER18LaNBlLaCxyWZcMfSOoIS8x0LlTEjlXFhwCq+OvCL1
 3AV10dgCT2TZnknbIdf6nFBXiSqg1hDhopevMkXetuKMytSEwlE4Ik6CPO35RrG+ApxhryQk
 MG/+kk/RnI80A54POtU8IkHyh/hpNzu3PNWQ4sc6klOY4eBoXBc5oSLzXJXCAP8usALJ8tan
 8wjGv6OYQxxpPUqKiCOmdLkQY8Q254cyNAx4akW4D1CasTqyHQu529AagXogFN8Ou9b+iTSt
 sEMGMROQlAwtTywU27XdZO1RJFr8jw8ikk0EoZEy+KOajjyUWR/V+BhrtEbbKNr3oENZP5Bg
 r4otUlxpCFPyTTnBb2wcTTn9pbfz78UvmtCDyBeZuixnsRQ3oaGFq5g16jPHZaMawDNtwAUZ
 cbjHIleMGAtagFmRJqeqUOqS4zcotwafKDoaesbr8970D2xF8SblRS6RkI31q6xxgs87n7Gl
 oQYOAjJf8rc89+9r3e2yqfTrstuCxQIqgYMPABEBAAGJAh8EGAECAAkCGwwFAlaGex0ACgkQ
 DtqbN4uC4LXNbRAA1qhcKi/wLf3HCsevNqvYCnZLo4/u/ZgIOKkUK2Ebajb314zN93UeJQZX
 dyhCDKFWgboeL8OySLze5/kT944NhJbn40LI7fHE1qEtSCDjCIi3SU+zRpJTM0mx4kuw3d9b
 6swzuWybSrAoxZuq24R9BKfVwUvZ+IIjasNkAxDTXoY3jsEHFzEv8qZBrR1BWcdhJbIAtnb2
 zKug/HGZ5aAmlBlYggoX+XqGKlZg6jnF4d6BjV2SSxaKuEyTY+KwYQ8dY8754sxhCvv1LZal
 l8pDvoEfF/6dyOMA7K2IuD5uYf90cOjrgM1TaMTKvdvS6hm6TveYXXXK582XeU7C0G/BvWYn
 BM3MdMVsnTMp50HRE4/rMdLzgFxcdiAnqTB4RDfcTcUdlMY4lQfTOSKVS8iuLQYbNyjc80vu
 FKc5qNRAnzQrXk9BkCuSzJaNXvoKrHknDGqzM1MHjarfkQofMMKwg90Ji/bKHoHVGzp8rfKY
 hfOTIAnzXIyegjQWXmnXiZ17OnCnSNIJuCw6OduueVSXtXqbUX1D8M28VLfrh3HWpCLLUR+j
 zcbKI1trRLZsFjj5uBkiTT/f/3jnp8OPiEywQ6vcm5YVZfYbHIx1sM1fKH0HrvfFCx4ANVAA
 5jG0MHwu2J/zJsFM0V7L9V9sRCgXNbLjeL/OJ8PLNY7UTVFAEaw=
Message-ID: <1a37b16b-0693-05fd-3a67-6b0242608a26@libero.it>
Date:   Wed, 26 Sep 2018 21:55:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180925172931.GC30715@router-fw-old.i.net-space.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfD25/FHxaTx+7i7oB7a78s+YFsbtTH/jMGOyjez3gafeZJeYzWQA2hZpyeWubUtBYnU3pLPQv2subK+s/dyLGoKwMpZPu0g0qxly06weTr08McioWF7a
 aJfRSQlg+GsWnSGkwu+vzJqAOremUqIQH3OcbXeccK9KEg8UVL5dLqt6y5JLxq6oZEC/3mVXpOHgTJlLAvs70EKcyEHp790BPAgFQ5RJz++u174PPzhWmffX
 KRDUOmPtaAV1Qf2smVPJjYPweq0J96ObbMoq/DkzAVs=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 25/09/2018 19.29, Daniel Kiper wrote:
> On Wed, Sep 19, 2018 at 08:40:35PM +0200, Goffredo Baroncelli wrote:
>> From: Goffredo Baroncelli <kreijack@inwind.it>
>>
>> If a device is not found, do not return immediately but
>> record this failure by storing NULL in data->devices_attached[].
> 
> Still the same question: Where the store happens in the code?
> I cannot find it in the patch below. This have to be clarified.
> 
> Daniel


What about the following commit description
---------------------------------------------
Change the behavior of find_device(): before the patch, a read of a missed device might trigger a rescan. However, it is never recorded that a device is missed, so each single read of a missed device might triggers a rescan.
It is the caller who decides if a rescan is performed in case of a missed device. And it does quite often, without considering if in the past a devices was already found as "missed"
This behavior causes a lot of unneeded rescan, causing a huge slowdown in case of a missed device.

After the patch, the "missed device" information is stored in the cache (as a NULL value). A rescan is triggered only if no information at all is found in the cache. This means that only the first time a read of a missed device triggers a rescan.

The change in the code is done removing "return NULL" when the disk is not found. So it is always executed the code which stores in the cache the value returned by grub_device_iterate(): NULL if the device is missed, or a valid data otherwise.
---------------------------------------------
> 
>> This way we avoid unnecessary devices rescan, and speedup the
>> reads in case of a degraded array.
>>
>> Signed-off-by: Goffredo Baroncelli <kreikack@inwind.it>
>> ---
>>  grub-core/fs/btrfs.c | 19 +++++++++----------
>>  1 file changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
>> index 0cdfaf7c0..6e42c33f6 100644
>> --- a/grub-core/fs/btrfs.c
>> +++ b/grub-core/fs/btrfs.c
>> @@ -588,7 +588,7 @@ find_device_iter (const char *name, void *data)
>>  }
>>
>>  static grub_device_t
>> -find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
>> +find_device (struct grub_btrfs_data *data, grub_uint64_t id)
>>  {
>>    struct find_device_ctx ctx = {
>>      .data = data,
>> @@ -600,12 +600,9 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
>>    for (i = 0; i < data->n_devices_attached; i++)
>>      if (id == data->devices_attached[i].id)
>>        return data->devices_attached[i].dev;
>> -  if (do_rescan)
>> -    grub_device_iterate (find_device_iter, &ctx);
>> -  if (!ctx.dev_found)
>> -    {
>> -      return NULL;
>> -    }
>> +
>> +  grub_device_iterate (find_device_iter, &ctx);
>> +
>>    data->n_devices_attached++;
>>    if (data->n_devices_attached > data->n_devices_allocated)
>>      {
>> @@ -617,7 +614,8 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
>>  			* sizeof (data->devices_attached[0]));
>>        if (!data->devices_attached)
>>  	{
>> -	  grub_device_close (ctx.dev_found);
>> +	  if (ctx.dev_found)
>> +	    grub_device_close (ctx.dev_found);
>>  	  data->devices_attached = tmp;
>>  	  return NULL;
>>  	}
>> @@ -892,7 +890,7 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>>  			      " for laddr 0x%" PRIxGRUB_UINT64_T "\n", paddr,
>>  			      addr);
>>
>> -		dev = find_device (data, stripe->device_id, j);
>> +		dev = find_device (data, stripe->device_id);
>>  		if (!dev)
>>  		  {
>>  		    grub_dprintf ("btrfs",
>> @@ -969,7 +967,8 @@ grub_btrfs_unmount (struct grub_btrfs_data *data)
>>    unsigned i;
>>    /* The device 0 is closed one layer upper.  */
>>    for (i = 1; i < data->n_devices_attached; i++)
>> -    grub_device_close (data->devices_attached[i].dev);
>> +    if (data->devices_attached[i].dev)
>> +        grub_device_close (data->devices_attached[i].dev);
>>    grub_free (data->devices_attached);
>>    grub_free (data->extent);
>>    grub_free (data);
>> --
>> 2.19.0
>>
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5


