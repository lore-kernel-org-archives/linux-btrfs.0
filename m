Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:48123 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758918Ab3DAQQv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 12:16:51 -0400
Received: by mail-bk0-f45.google.com with SMTP id j10so976474bkw.32
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Apr 2013 09:16:50 -0700 (PDT)
Message-ID: <5159B2F0.9060704@gmail.com>
Date: Mon, 01 Apr 2013 19:16:48 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Online dedup for Btrfs
References: <20130401125034.GG1876@localhost.localdomain> <20130401153859.GJ1876@localhost.localdomain>
In-Reply-To: <20130401153859.GJ1876@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/4/2013 6:38 μμ, Josef Bacik wrote:
> On Mon, Apr 01, 2013 at 08:50:34AM -0400, Josef Bacik wrote:
>> Hello,
>>
>> I was bored this weekend so I hacked up online dedup for Btrfs.  It's working
>> quite well so I think it can be more widely tested.  There are two ways to use
>> it
>>
>> 1) Compatible mode - this is a bit slower but will handle being used by older
>> kernels.  We use the csum tree to find duplicate blocks.  Since it is relatively
>> easy to have crc32c collisions this also involves reading the block from disk
>> and doing a memcmp with the block we want to write to verify it has the same
>> data.  This is way slow but hey, no incompat flag!
>>
>> 2) Incompatible mode - so this is the way you probably want to use it if you
>> don't care about being able to go back to older kernels.  You select your
>> hashing function (at the momement I only support sha1 but there is room in the
>> format to have different functions).  This creates a btree indexed by the hash
>> and the bytenr.  Then we lookup the hash and just link the extent in if it
>> matches the hash.  You can use -o paranoid-dedup if you are paranoid about hash
>> collisions and this will force it to do the memcmp() dance to make sure that the
>> extent we are deduping really matches the extent.
>>
>> So performance wise obviously the compat mode sucks.  It's about 50% slower on
>> disk and about 20% slower on my Fusion card.  We get pretty good space savings,
>> about 10% in my horrible test (just copy a git tree onto the fs), but IMHO not
>> worth the performance hit.
>>
>> The incompat mode is a bit better, only 15% drop on disk and about 10% on my
>> fusion card.  Closer to the crc numbers if we have -o paranoid-dedup.  The space
>> savings is better since it uses the original extent sizes, we get about 15%
>> space savings.  Please feel free to pull and try it, you can get it here
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git dedup
>>
>> Thanks!
>>
> It's been pointed out to me that this is probably too serious, so just FYI it's
> April 1st where I am.  Thanks,
Well I believed it too, and was writing an email with questions etc. I 
almost sent it, but then I saw git was downloading hundreds and hundreds 
of MB of data :)

Well done anyway!
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

