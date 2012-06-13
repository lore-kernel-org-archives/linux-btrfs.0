Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38827 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2FMVmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 17:42:01 -0400
Received: by yenl2 with SMTP id l2so418150yen.19
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 14:42:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20120612T222541-400@post.gmane.org>
References: <1339456922.32583.YahooMailNeo@web160802.mail.bf1.yahoo.com>
	<loom.20120612T013031-188@post.gmane.org>
	<20120612133311.58af9d8f@natsu>
	<loom.20120612T162801-407@post.gmane.org>
	<loom.20120612T222541-400@post.gmane.org>
Date: Wed, 13 Jun 2012 23:42:00 +0200
Message-ID: <CAD=4a=XVosacvO1bGm=nGjuakmKhkKFUdJHcjd1MREEV+rqnrA@mail.gmail.com>
Subject: Re: KVM on top of BTRFS
From: =?UTF-8?Q?Ernst_Sj=C3=B6strand?= <ernstp@gmail.com>
To: steamraven <steamraven@yahoo.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

you can't beat the benchmarks that Serge Hallyn did, really thorough!

http://s3hh.wordpress.com/2012/05/02/first-round-of-kvm-performance-tests/

Regards
//Ernst

2012/6/12 steamraven <steamraven@yahoo.com>:
>>
>> Seems a little unfair on btrfs to just to look at absolutes in this context.
>> Prior reports said that the fs ground to a halt,
>> it isn't doing that by any stretch.
>
>
> I agree.  What I am mostly looking for is the best setup
> for using KVM snapshots:
>
> KVM qcow2 on top of something like ext4  or
> raw on top of btrfs
>
>
>>
>> I haven't let any of these installs complete and used it as intended.
>> So that's what I intend to do next; after all one doesn't install every day.
>>
>
> I am going to try to benchmark a couple variations and flags
> qcow2 on ext4  (noatime)
> raw on btrfs (defaults)
> raw on btrfs (noatime,space_cache)
> raw on btrfs (noatime,nospace_cache)
> raw on btrfs (noatime,nodatacow)
>
> Any other options that might be good to try?
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
