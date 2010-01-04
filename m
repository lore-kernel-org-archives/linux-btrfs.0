From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: btrfs-progs: New utility to swap subvolumes
Date: Mon, 04 Jan 2010 09:49:44 +0900
Message-ID: <4B413B28.7090604@jp.fujitsu.com>
References: <4B32CF4D.90406@jp.fujitsu.com> <200912272123.37585.kreijack@alice.it> <4B380C22.4010809@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org
To: kreijack@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B380C22.4010809@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Buon anno, Goffredo.

Taking snapshot in btrfs is very easy, but handling snapshots is
very confusing. So, we must make a rule of snapshotting such as
your proposal, which seems to me very good and useful.
If rules like this are forced regardless of operator's preference,
this utility may become a deadwood.

Identification with non-filesystem-related identifier seems to me
a good idea. But because subvolume is unique idea in btrfs,
identifying subvolumes can be unique, too.
Subvolume ID represents some information belong to subvolume
(like snapshot date/time... not data which subvolume contains),
and not variable. It becomes useful information/identifier
to handle snapshots although it's not friendly to human being.

Regards,
taruisi

>Hi Taruisi,
>
>On Monday 28 December 2009, TARUISI Hiroaki wrote:
>[...]
>
>> We can swap subvolumes regardless of mounted-subvolume. (only
>> when we mount other subvolume than fs tree)
>I resolved this kind of problem as described in my previous email ([RFC]
>proposal for a btrfs filesystem layout - 20/Nov/2009): I used a sub-volume as
>root of my system, but I mounted also the root of the btrfs filesystem for
>handling the sub-volumes under "/var/btrfs". It work quiet well:
>1) I can swap the sub-volumes only with the mv commands
>2) I can switch to an old snapshot of the root at boot time, because my
>scripts update the grub entries with the list of the valid snapshots
>3) I can switch permanently two sub-volumes exchanging their names
>4) I can remove a sub-volume quite easily
>
>> And, because we can identify snapshot (its date or target subvol)
>> with subvolume ID, it is suitable to swap with ID.
>Why you want to to identify a sub-volume with its id ?
>I like the idea to identify a sub-volumes with an identifier which is not
>file-system related. To me the fact that a sub-volume is identified with its
>"mount point" seems to me a limit instead that an advantage. But it seems that
>I am alone to thinking that :-(
>So I am curious about your reasons.
>
>BR
>Goffredo
>
>--
>gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
>Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

