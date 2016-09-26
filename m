Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38722 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966089AbcIZLLm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 07:11:42 -0400
Received: by mail-it0-f54.google.com with SMTP id n143so71357356ita.1
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 04:11:42 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id f131sm3666098itc.8.2016.09.26.04.11.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Sep 2016 04:11:40 -0700 (PDT)
Subject: Re: Does data checksumming remain for files with No_COW file
 attribute?
To: linux-btrfs@vger.kernel.org
References: <767591474719974@web21o.yandex.ru> <20160924174012.51d44caa@natsu>
 <20160924124323.GS7138@carfax.org.uk> <1474740691.7196.6.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <dadc90ae-7e18-a430-013c-f31a82b94b53@gmail.com>
Date: Mon, 26 Sep 2016 07:11:29 -0400
MIME-Version: 1.0
In-Reply-To: <1474740691.7196.6.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-24 14:11, Christoph Anton Mitterer wrote:
> On Sat, 2016-09-24 at 12:43 +0000, Hugo Mills wrote:
>>    It's because you can't update the data and the checksum atomically
>> -- at some point in the writing process, they must be inconsistent.
>> This is considered a Bad Thing.
>
> It's not worse at all than simply not cheksuming... in both cases you
> have no guarantee whether the data is bogus or not, but in with csums,
> you can at least tell - only at the little cost, of false positives
> when the data was fully and correctly written, but the csums not.
Except that without checksums, you don't lose all the data in that block 
when torn write happens, with checksums without COW, you do.  Also, 
IIUC, due to how BTRFS implements checksums, you have a bad block for 
the entire duration of the write, because the stored checksum is for the 
old block, not the current one.  Whether or not that matters is of 
course usage dependent, but it's still worth noting.  Personally, I'd 
rather be able to read the file and see that it's corrupted instead of 
getting -EIO trying to do so (I also would rather we had something other 
than -EIO to return when checksum verification fails, but that's a 
separate issue).
