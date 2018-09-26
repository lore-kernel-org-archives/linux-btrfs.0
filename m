Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377ABC43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 19:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E70F821527
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 19:56:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="PI5O9+HZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E70F821527
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbeI0CKt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 22:10:49 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:39512 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726032AbeI0CKs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 22:10:48 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5FutgzQvdq9Au5Futgj141; Wed, 26 Sep 2018 21:56:13 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1537991773; bh=JuJyJdn2k0U3Lh/YdVkzEmDhy/chaOfX9dt02NWcSEE=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=PI5O9+HZNW9CP3TzbZzs02bbFoBQdRVM09HS0R3c/AepFhmCpTcn3sWxhMi5ZxJvL
         F8Y3DxBvbJouzsRwD3pW9GJpulbp4YzsOLUB8pWakeOdVkuTD57b4bGe8ukLv1RP3/
         GLIX4TulFTja+CXBvOh7lGyNkfeWfcFtrSb3cshhAJdmH9UEYCWJZ3vgM6NfAtz7Au
         bUsYd62PtLU3Xtvnn4wqcE+bd/lI5vTyO+loJ54xBUy0Vu+g1ovAXZdWz0LY0Lywyd
         glEUinY8kTmdOhUSdUGo/pKpqMzrxAyafgp2FlExNelvQnd4DDJlFq2yHsRXYKfG+k
         CoWWDvsBI2DCw==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17
 a=IkcTkHD0fZMA:10 a=mKOXTXn1IpF-MbsE_U4A:9 a=zIqCHynVsgUSJSIY:21
 a=RyUZKyt6Yabo-tBt:21 a=QEXdDO2ut3YA:10
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 9/9] btrfs: Add RAID 6 recovery for a btrfs filesystem.
To:     Daniel Kiper <dkiper@net-space.pl>
Cc:     grub-devel@gnu.org, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <20180919184040.22540-1-kreijack@libero.it>
 <20180919184040.22540-10-kreijack@libero.it>
 <20180925192046.GE30715@router-fw-old.i.net-space.pl>
From:   Goffredo Baroncelli <kreijack@libero.it>
Openpgp: preference=signencrypt
Autocrypt: addr=kreijack@libero.it; prefer-encrypt=mutual; keydata=
 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
Message-ID: <36e9e14c-f694-1d22-34bf-4a28b6c189cd@libero.it>
Date:   Wed, 26 Sep 2018 21:56:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180925192046.GE30715@router-fw-old.i.net-space.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfMaQOGgmO4twMmi8un84uVRi1cguywgWhSbdgF9XQ6MQenfg1VJg+PpqNGdYJhM2vqDsvGwpmnRDBbQEVmx2w9udTTx8btoYrXwz90AVTu7woa2rnzTd
 6K6v9R7w6jN7vhDceJekc5kp0DrwmNKSH7caG2/fTan9lCdL1QDWg1zCLyoYd0XhMYSrrhkOppnTaIXSMeFqiSqNc6MY2j2S6pf6hOCiCcwtN7ROPvHiEMqB
 WkRHxZ9GifyyOlKZc5H/s21NpS4KZGM29TC4HSFne7Y=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 25/09/2018 21.20, Daniel Kiper wrote:
> On Wed, Sep 19, 2018 at 08:40:40PM +0200, Goffredo Baroncelli wrote:
>> From: Goffredo Baroncelli <kreijack@inwind.it>
>>
[....]
>>  	       *  - stripe_offset is the disk offset,
>>  	       *  - csize is the "potential" data to read. It will be reduced to
>>  	       *    size if the latter is smaller.
>> +	       *  - parities_pos is the position of the parity inside a row (
> 
> s/inside/in/> 
>> +	       *    2 for P1, 3 for P2...)

+              *  - nparities is the number of parities (1 for RAID5, 2 for RAID6);
+              *    used only in RAID5/6 code.

>>  	       */
>>  	      block_nr = grub_divmod64 (off, chunk_stripe_length, &low);
>>
>> @@ -1030,6 +1069,9 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>>  	       */
>>  	      grub_divmod64 (high + stripen, nstripes, &stripen);
>>
>> +	      grub_divmod64 (high + nstripes - nparities, nstripes,
>> +			     &parities_pos);
> 
> I think that this math requires a bit of explanation in the comment
> before grub_divmod64(). Especially I am interested in why high +
> nstripes - nparities works as expected.


What about

/*
 * parities_pos is equal to "(high - nparities) % nstripes" (see the diagram above).
 * However "high - nparities" might be negative (eg when high == 0) leading to an
 * incorrect computation.
 * Instead "high + nstripes - nparities" is always positive and in modulo nstripes is
 * equal to "(high - nparities) % nstripes
 */
> 
> Daniel
> 
BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
