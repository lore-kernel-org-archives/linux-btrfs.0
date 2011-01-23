From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: snapshot strange behaviour
Date: Sun, 23 Jan 2011 19:02:11 +0100
Message-ID: <4D3C6D23.106@libero.it>
References: <ihgklr$s29$1@dough.gmane.org> <4D3C1C49.8040104@libero.it> <ihhg37$8qj$1@dough.gmane.org>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ihhg37$8qj$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/23/2011 04:05 PM, Lubos Kolouch wrote:
> Goffredo Baroncelli, Sun, 23 Jan 2011 13:17:13 +0100:
> 
>> Hi Lubos,
>>
>> On 01/23/2011 08:17 AM, Lubos Kolouch wrote:
>>> Hello,

>>> Is this a bug or intended behaviour and I am missing something
>>> something? How to snapshot a subvolume, containing another subvolumes?
>>
>> It is the intended behavior. The snapshotting is not recursive about
>> subvolumes. If you snapshot a subvolume which contains another one, you
>> got only the content of the first subvolume. The directory "x/b" which
>> you see, is not the subvolume "b" snapshotted, but only the
>> "mount-point" of "b".
>>
> 
> Hi Goffredo,
> 
> I understand. But then I think btrfs should refuse to do it or at least 
> print a warning. Otherwise it is very inconvenient for the user, having to
> search for any subvolumes down the tree...


Sorry, but I can't agree. To me it seems a reasonable default. There are
a lot of cases where I would not snapshot a sub-sub-subvolume: my rootfs
is a subvolume, my home is in another one. I can snapshot, update the
root fs, then if something goes wrong I can roolback to the old one,
without affecting my home.

This behavior is strictly related to the btrfs internal.

Any way it is true that this behavior should be highlighted in the
documentation.

And more, it is possible to add a "-R" flag to snapshot recursively a
subvolume...

Goffredo

> Lubos
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

