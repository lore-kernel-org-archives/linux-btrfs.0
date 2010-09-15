From: David Nicol <davidnicol@gmail.com>
Subject: Re: Updating the wiki pages adding btrfs command [Was Re: reserving
 an IOCTL number; other details]
Date: Wed, 15 Sep 2010 13:35:54 -0500
Message-ID: <AANLkTink+VTm9boFmF8kUqqfJ+nL3Z0xC8MQmhDh7KtM@mail.gmail.com>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
 <201009142125.56710.kreijack@libero.it> <AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
 <201009151951.04870.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201009151951.04870.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs s ... is imprecise, as the operation isn't on a subvolume, but
on the fi where the s used to be but isn't any more.

With your approval I'll go with "filesystem garbage-collection" which
can be abbrevd to

   btrfs fi g /butter 30000 || echo there should be some more space now \
   but it would have taken more than 30 sec to clean it all

and in some imaginary future might trigger something instead of simply
waiting for something.
