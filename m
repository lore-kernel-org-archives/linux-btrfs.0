From: "Niels de Carpentier" <niels@decarpentier.com>
Subject: Re: Re: Two way mirror in BRTFS
Date: Fri, 30 Dec 2011 16:08:46 +0100
Message-ID: <925a66c275d286669ba618e277e99cc3.squirrel@webmail.decarpentier.com>
References: <135535.24205.61145-582-206632053-1325253564@email.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: jaromir.zdrazil@email.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <135535.24205.61145-582-206632053-1325253564@email.cz>
List-ID: <linux-btrfs.vger.kernel.org>

>>
>> You mean like "zfs send -i"? If yes, why not just use zfs? There's
>> zfsonlinux project, with easy-to-install ppa for ubuntu. Or you could
>> compile it manually.
>>
> Thank you for your suggestion. As I know, there is not everything ported
> yet, and one of the missing important features I plan to use is to crypt
> fs. And if I am not mistaken, current version does not yet support a
> mountable filesystem.

You are mistaken :) The current version is pretty stable, as long as you
don't use compression or dedup. Some problems have been reported with
weird setups (USB disks for example), but I haven't seen any reports of
unrecoverable filesystems.

For btrfs bugs are still fixed on a daily basis, and some reports of
people with corrupted and unrecoverable filesystems.

Neither supports encryption.

I might consider ZFS for a production environment (although it's
officially not production ready), but I don't think btrfs is ready for
that yet. If you want to be safe, use ext4 with drbd or rsync.

Niels



