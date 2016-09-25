Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17.italiaonline.it ([212.48.25.145]:39115 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752265AbcIYN5s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 09:57:48 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Does data checksumming remain for files with No_COW file
 attribute?
References: <767591474719974@web21o.yandex.ru> <20160924174012.51d44caa@natsu>
 <20160924124323.GS7138@carfax.org.uk> <1474740691.7196.6.camel@scientia.net>
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <53bd018f-1d45-41e4-ef28-9fe632cf4002@inwind.it>
Date: Sun, 25 Sep 2016 15:49:32 +0200
MIME-Version: 1.0
In-Reply-To: <1474740691.7196.6.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/24/2016 08:11 PM, Christoph Anton Mitterer wrote:
> On Sat, 2016-09-24 at 12:43 +0000, Hugo Mills wrote:
>>    It's because you can't update the data and the checksum atomically
>> -- at some point in the writing process, they must be inconsistent.
>> This is considered a Bad Thing.
> 
> It's not worse at all than simply not cheksuming... in both cases you
> have no guarantee whether the data is bogus or not, but in with csums,
> you can at least tell - only at the little cost, of false positives
> when the data was fully and correctly written, but the csums not.
> 

I think that the bigger cost is the lower performance due to the write of checksums.
> 
> Cheers.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
