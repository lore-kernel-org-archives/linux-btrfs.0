From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Updating the wiki pages adding btrfs command [Was Re: reserving an IOCTL number; other details]
Date: Wed, 15 Sep 2010 21:29:06 +0200
Message-ID: <201009152129.07222.kreijack@libero.it>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com> <201009151951.04870.kreijack@libero.it> <AANLkTink+VTm9boFmF8kUqqfJ+nL3Z0xC8MQmhDh7KtM@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTink+VTm9boFmF8kUqqfJ+nL3Z0xC8MQmhDh7KtM@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 15 September, 2010, David Nicol wrote:
> btrfs s ... is imprecise, as the operation isn't on a subvolume, but
> on the fi where the s used to be but isn't any more.

ok 
> 
> With your approval I'll go with "filesystem garbage-collection" which
> can be abbrevd to
> 
>    btrfs fi g /butter 30000 || echo there should be some more space now \
>    but it would have taken more than 30 sec to clean it all
> 
> and in some imaginary future might trigger something instead of simply
> waiting for something.

I don't like too much "garbage-collector". It seems that you can start a 
"garbage collector". Instead we wait the finish of the garbage collector 
activity.

I would like also to have the option to wait in "btrfs subvolume delete"

# btrfs subvolume delete --wait /path/to/subvolume

(instead of "--wait", we can use "--sync"...)

In any case could you highlight the behavior of your ioctl when two snapshot 
deletions are performed. Does the ioctl wait the end of both the snapshot 
deletion ? 

Regards
G.Baroncelli

-- 
gpg key@ keyserver.linux.it:Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
