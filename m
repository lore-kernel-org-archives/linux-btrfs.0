Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [65.55.116.102] ([65.55.116.102]:57302 "EHLO
	BLU004-OMC3S27.hotmail.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751113AbaJ0Rjd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 13:39:33 -0400
Message-ID: <BLU436-SMTP15073535AC9D2748E0B7180DA9E0@phx.gbl>
References: <DUB406-EAS294A0E4ED8B326281AFD7C6DA9E0@phx.gbl> <53BBD40F-B9F3-492C-9F56-15EAFC00119D@colorremedies.com> <DUB118-W201FD897C8121E783F626CDA9E0@phx.gbl> <3E982444-5500-45BB-A04F-CF16D735CDF7@colorremedies.com> <DUB118-W2969E1F5128902D7B08B61DA9E0@phx.gbl> <CB626F05-ABC0-4EDA-9285-004F08585F75@colorremedies.com>
MIME-Version: 1.0 (1.0)
In-Reply-To: <CB626F05-ABC0-4EDA-9285-004F08585F75@colorremedies.com>
Content-Type: text/plain; charset="utf-8"
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jasper Verberk <jverberk@hotmail.com>
Subject: Re: Problem converting data raid0 to raid1: enospc errors during balance
Date: Mon, 27 Oct 2014 18:38:27 +0100
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I already tried balancing with dusage=1. This removed all the allocated space.

It still doesn't allow me to do the conversion though, as it then reallocates the space.



> On 27 okt. 2014, at 18:28, Chris Murphy <lists@colorremedies.com> wrote:
> 
> 
>> On Oct 27, 2014, at 10:54 AM, Jasper Verberk <jverberk@hotmail.com> wrote:
>> 
>> I actually tried going to raid1 with kernel 3.10 before....the reason I updated to 3.17 was to see if this would fix the error. 
>> 
>> It still remained though….
> 
> If you have btrfs-progs you could do a btrfs check without repair and see if that's enlightening. Can you do a normal balance successfully, without conversion? If you haven't tried it recently with a newer kernel you might try for starters:
> 
> btrfs balance start -musage=100 -dusage=5
> 
> Any data chunks less than 50% full will be balanced, and all the metadata chunks will be balanced. This line:
> Data, RAID1: total=2.85TiB, used=790.46GiB
> Is suspiciously high for allocated chunks compared to the data stored in it. Maybe releasing some chunks will solve the problem and permit conversion to proceed.
> 
> 
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
