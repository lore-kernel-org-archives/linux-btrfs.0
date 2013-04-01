Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:32960 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab3DAPvC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 11:51:02 -0400
Received: by mail-lb0-f173.google.com with SMTP id w20so2079201lbh.32
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Apr 2013 08:51:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130401153859.GJ1876@localhost.localdomain>
References: <20130401125034.GG1876@localhost.localdomain> <20130401153859.GJ1876@localhost.localdomain>
From: Harald Glatt <mail@hachre.de>
Date: Mon, 1 Apr 2013 17:50:40 +0200
Message-ID: <CAFWF=akuVKaiaWYSAWkKTDh1ygdpC7nTk8HV9i3Yjh2OJnQm1A@mail.gmail.com>
Subject: Re: [RFC] Online dedup for Btrfs
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh man :D It was so elaborate that I really believed it.... :P

On Mon, Apr 1, 2013 at 5:38 PM, Josef Bacik <jbacik@fusionio.com> wrote:
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
>
> It's been pointed out to me that this is probably too serious, so just FYI it's
> April 1st where I am.  Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
