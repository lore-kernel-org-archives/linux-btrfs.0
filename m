From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: snapshot strange behaviour
Date: Sun, 23 Jan 2011 20:06:10 +0000 (UTC)
Message-ID: <ihi1ni$o13$1@dough.gmane.org>
References: <ihgklr$s29$1@dough.gmane.org> <4D3C1C49.8040104@libero.it>
	<ihhg37$8qj$1@dough.gmane.org> <4D3C6D23.106@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli, Sun, 23 Jan 2011 19:02:11 +0100:

> On 01/23/2011 04:05 PM, Lubos Kolouch wrote:
>> Goffredo Baroncelli, Sun, 23 Jan 2011 13:17:13 +0100:
>> 
>>> Hi Lubos,
>>>
>>> On 01/23/2011 08:17 AM, Lubos Kolouch wrote:
>>>> Hello,
> 
>>>> Is this a bug or intended behaviour and I am missing something
>>>> something? How to snapshot a subvolume, containing another
>>>> subvolumes?
>>>
>>> It is the intended behavior. The snapshotting is not recursive about
>>> subvolumes. If you snapshot a subvolume which contains another one,
>>> you got only the content of the first subvolume. The directory "x/b"
>>> which you see, is not the subvolume "b" snapshotted, but only the
>>> "mount-point" of "b".
>>>
>>>
>> Hi Goffredo,
>> 
>> I understand. But then I think btrfs should refuse to do it or at least
>> print a warning. Otherwise it is very inconvenient for the user, having
>> to search for any subvolumes down the tree...
> 
> 
> Sorry, but I can't agree. To me it seems a reasonable default. There are
> a lot of cases where I would not snapshot a sub-sub-subvolume: my rootfs
> is a subvolume, my home is in another one. I can snapshot, update the
> root fs, then if something goes wrong I can roolback to the old one,
> without affecting my home.
> 
> This behavior is strictly related to the btrfs internal.
> 
> Any way it is true that this behavior should be highlighted in the
> documentation.
> 
> And more, it is possible to add a "-R" flag to snapshot recursively a
> subvolume...
> 
> Goffredo

The -R would be nice... two use cases :

1) directory many_small_files under the /home subvolume, that you need 
only for a while - it is easier to for example delete it when it is 
subvolume as well

2) backups

subvolume backups -> subvolumes 20110122, 20110123, ...
you want to delete backups older than x years -> it is much faster to do 
if it is a subvolume as well. But - you may as well want to be able 
snapshot or delete the whole backups subvolume.

Lubos

