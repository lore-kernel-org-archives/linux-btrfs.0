Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54458 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132AbbLGDcg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Dec 2015 22:32:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a5mXR-0002Uo-5U
	for linux-btrfs@vger.kernel.org; Mon, 07 Dec 2015 04:32:33 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 04:32:33 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 04:32:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Very various speed of grep operation on btrfs partition
Date: Mon, 7 Dec 2015 03:32:27 +0000 (UTC)
Message-ID: <pan$32096$b80946db$17712ee2$b02a79d4@cox.net>
References: <CABXGCsMYdfSpZeUbWut1p542XA-L99iXM0Ero8tAFVhU9xhzkw@mail.gmail.com>
	<56618E4A.2000905@gmail.com>
	<CABXGCsONoHDYX-deg=2s5xNsQ1XjrL=o1t4CbRJqEt=TR4y5Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Михаил Гаврилов posted on Mon, 07 Dec 2015 02:16:08 +0500
as excerpted:

> 2015-12-04 17:59 GMT+05:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
>> Well, what other things are accessing the filesystem at the same time?
>> If you've got something like KDE running with the 'semantic desktop'
>> stuff turned on, than that will seriously impact the performance of
>> other things using that filesystem.
>>
>> The other thing to keep in mind, is that caching may be impacting
>> things somewhat.  To really get a good idea of performance for
>> something like this,
>> you should run 'sync' followed by 'echo 3 > /proc/sys/vm/drop_caches'
>> (you'll need to be root for the second one) prior to each run, and
>> ideally have nothing else running on that filesystem.
> 
> Thanks for clarifying.
> 
> I was able to further clarify:
> 
> After resetting the cache on a clean machine after a reboot grep
> operation was take:
> real 2m54.549s user 0m0.662s sys 0m1.062s
> 
> After turning off the indexing service (tracker) result improved: real
> 2m12.182s user 0m0.657s sys 0m1.021s
> 
> 
> If the cache is not cleaned:
> real 0m0.575s user 0m0.467s sys 0m0.108s
> 
> 
> And the result is stable and all subsequent launches, even when the
> indexing service is enabled.

FWIW, I build kde without the semantic-desktop stuff even enabled at 
build-time (gentoo offers that option) here.  All the kdepim stuff (kmail, 
etc) uses it, so I dumped the several kdepim related apps (kmail, 
akregator, kaddressbook) I used here and found alternatives.  I don't 
normally need the indexing, which only takes space for the index and 
lowers performance, so it's all turned off at build-time.

> A day later noticed that the effect of the cache is missing:
> real 4m33.940s user 0m0.862s sys 0m1.711s

That's probably due to something knocking it out of cache overnite.  If 
you have a cronjob running nitely to update the locate-variant database, 
for example, as many distros do by default, that'd do it, as that scans 
pretty much the entire filesystem, typically many times the size of RAM, 
thus trashing cache.

The indexer could potentially wipe out cache too, particularly on lower 
memory machines, if it's actively indexing files, as that would normally 
pull what it's indexing into cache, throwing something else that hasn't 
been used for awhile away, unless the indexer is smart enough to do 
direct access and thus not disturb cache, since it's single-time access 
and caching it isn't going to do anything but force stuff from cache you 
use more frequently.

> As I understand to solve my problem just need to do the cache is always
> effective, even if memory occupied by other applications.
> 
> Is possible to specify minimal size of disk cache?

AFAIK, not directly.  What happens is that rather than leave the memory 
empty, the kernel caches stuff as it reads it.  If the memory is needed 
for apps, it's reclaimed from cache and used for apps.  So Linux systems 
tend to run close to zero really free memory, unless you just dropped 
caches or rebooted, or you just used some memory hog and it's done and 
just freed its memory, and you haven't read enough files since then to 
fill that memory back up with cache.

However, if you're running swap, there's an adjustment, file
/proc/sys/vm/swappiness, but would be set on most distros using the 
sysctrl config (/etc/sysctl.conf and/or /etc/sysctl.d/*), 0-100, that 
normally controls the balance preference between swapping apps out to 
keep cache (nearer 100) vs. dumping cache to keep more apps in RAM 
instead of swapped out (near 0). IIRC the default is 60.

Obviously if you're not running swap, all app memory must be kept in 
physical RAM as it can't be swapped out, and cache simply uses what's 
left.

> Pity that I can't do 'echo 3 > /proc/sys/vm/drop_caches' on Windows
> machine. It be interesting how fast grep would be work without cache.

FWIW, I jumped off of MS when they started shipping malware[1] as part of 
the OS, with eXPrivacy.  So I've no idea if they've something similar, 
tho I'd be somewhat surprised if they didn't, at least as some obscure 
and possibly undocumented system call, so you'd have to call it from a 
program written for that purpose, instead of having it exposed such that 
any admin with suitable privs can do it with a single line command using 
only shell builtins, as Linux does.

>> Additionally, do you have some particular reason that you absolutely
>> _need_ nodatacow to be enabled for the FS?  It usually has no impact on
>> performance, but it removes any kind of error correction for file data
>> (checksums can't be used safely without COW semantics).  It probably
>> has no direct impact on what you're seeing here, but it is something
>> that really shouldn't be used in most cases at the filesystem level (it
>> can be done on given subvolumes or directories, and that's the
>> recommended way to do it if you don't want to go down to the per-file
>> level).
>>
>>
> I see that some issue with btrfs still not closed:
> https://code.google.com/p/chromium/issues/detail?id=284738 And
> gnome-boxes still very slow when COW is enable.

You're dumping the baby out with the bath water.

Only in cases where the entire filesystem purpose is as a dedicated VM 
image and/or database file host, or similar, without regular files, would 
mounting the entire filesystem nodatacow make sense, and the option is 
there for that use-case.  But in that case, why use btrfs at all, instead 
of some other more mature filesystem, since setting nodatacow turns off 
or cripples many of the features you likely selected btrfs for in the 
first place, and you might as well be using a fully stable and mature 
filesystem instead?

The much saner alternative, if you're going to the trouble of choosing 
btrfs in the first place, is to set nocow on specific subdirs and/or 
files using the chattr command as outlined in your link (taking into 
account the at-creation or no-content/zero-length condition if set on 
specific files), or even mount specific dedicated-use subvolumes as 
nodatacow, while mounting the rest of the filesystem without that option.

The link you referenced, and the link to the archlinux wiki it in turn 
references, are actually reasonably sane recommendations, but those 
recommendations /don't/ include setting the mount option for the entire 
filesystem, unless it is indeed a purpose-dedicated filesystem hosting 
only files where access is of the described random-rewrite-pattern, not a 
general purpose filesystem hosting all sorts of files.

Among other effects of nocow/nodatacow, it turns off btrfs data 
checksumming as with rewrite-in-place it's impossible to atomically 
update both the file and its checksum, so there's a race period during 
every write where the checksum and data don't match.

Additionally, because btrfs snapshotting depends on cow (snapshots lock 
in place the old data so new changes MUST be written elsewhere), 
snapshots force otherwise nocow data to cow1, that is, copy-on-first-
write of a block, after which the new copy is again rewritten in-place 
until the next snapshot.  If you're doing any sort of scheduled 
snapshotting, this means nocow files will eventually fragment anyway, tho 
it may take longer, depending on how frequent the snapshotting is vs. how 
busily the nocow data is being rewritten.

So say goodbye to btrfs scrub being of any use on your data (tho it'll 
still work for metadata, as that's always cow), as with nodatacow you 
just disabled checksumming as well (and see the warning about /that/ on 
the wiki!), and while snapshots will still work, every snapshot weakens 
your nocow/nodatacow and increases fragmentation due to the forced cow1s.

Which is why I said setting it for the filesystem isn't a particularly 
sane thing to do, unless of course it's a dedicated-purpose filesystem 
only hosting files of the target type.  Set it for specific files or 
subdirs as necessary, or for dedicated-purpose subvolumes.  Because 
otherwise, it's likely you'd be better off just using a more traditional, 
mature and stable filesystem that doesn't depend on and assume cow in the 
first place.

---
[1] Malware: Defined here as any feature deliberately designed to act 
outside of the best interest of the machine's legal owner -- note that I 
didn't say software or operating system owner, as MS considers that to be 
them, they only sell you an extremely limited right to use it while still 
under their ultimate control, and it's definitely acting in /their/ 
interest.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

