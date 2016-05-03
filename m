Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:33660 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbcECJsN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 05:48:13 -0400
Received: by mail-ig0-f196.google.com with SMTP id rc4so1588346igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 May 2016 02:48:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$b939a$5be842ed$a7dd852d$165642d6@cox.net>
References: <CAEr_6SvhqyiyHiyU9CwSP9stN__6SwT-KbF2MXhr8EvFTVyjjQ@mail.gmail.com>
	<pan$b939a$5be842ed$a7dd852d$165642d6@cox.net>
Date: Tue, 3 May 2016 09:48:12 +0000
Message-ID: <CAEr_6Surrc7VH8Qt2OR9AhBDS6OY0jbn-YkBJkdXo1mwFCn7Uw@mail.gmail.com>
Subject: Re: recovery problem raid5
From: Pierre-Matthieu anglade <pierre.matthieu.anglade@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 30, 2016 at 1:25 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Pierre-Matthieu anglade posted on Fri, 29 Apr 2016 11:24:12 +0000 as
> excerpted:

> So while btrfs in general, being still not yet fully stable, isn't yet
> really recommended unless you're using data you can afford to lose,
> either because it's backed up, or because it really is data you can
> afford to lose, for raid56 that's *DEFINITELY* the case, because (as
> you've nicely demonstrated) there are known bugs that can affect raid56
> recovery from degraded, to the point it's known that btrfs raid56 can't
> always be relied upon, so you *better* either have backups and be
> prepared to use them, or simply not put anything on the btrfs raid56 that
> you're not willing to lose in the first place.
>
> That's the general picture.  Btrfs raid56 is strongly negatively-
> recommended for anything but testing usage, at this point, as there are
> still known bugs that can affect degraded recovery.

Thank you for having made the picture clearer. Fortunately my case was
just a test one. And from the information I've been able to gather on
the web, I was wondering first if such a bug (or misdemeanour from the
system administrator that goes undetected by the software) would be of
interest to people developping/using btrfs ; 2) if there is some way
to dig a little more my problem since my goal in testing btrfs is also
to get some knowldge about it.

>> # btrfs fi show
>> warning, device 1 is missing
>> warning, device 1 is missing
>> warning devid 1 not found already
>> bytenr mismatch, want=125903568896, have=125903437824
>> Couldn't read tree root Label: none
>>  uuid: 26220e12-d6bd-48b2-89bc-e5df29062484
>>     Total devices 4 FS bytes used 162.48GiB
>>     devid    2 size 2.71TiB used 64.38GiB path /dev/sdb2
>>     devid    3 size 2.71TiB used 64.91GiB path /dev/sdc2
>>     devid    4 size 2.71TiB used 64.91GiB path /dev/sdd2
>>     *** Some devices missing
>
> Unfortunately you can't get it if the filesystem won't mount, but a btrfs
> fi usage (newer, should work with 4.4) or btrfs fi df (should work with
> pretty much any btrfs-tools, going back a very long way, but needs to be
> combined with btrfs fi show output as well to interpret) would have been
> very helpful, here.  Nothing you can do about it when you can't mount,
> but if you had saved the output before the first device removal/replace
> and again before the second, that would have been useful information to
> have.

Here they are :

# btrfs fi usage /mnt
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
Overall:
    Device size:          10.86TiB
    Device allocated:             0.00B
    Device unallocated:          10.86TiB
    Device missing:             0.00B
    Used:                 0.00B
    Free (estimated):             0.00B    (min: 8.00EiB)
    Data ratio:                  0.00
    Metadata ratio:              0.00
    Global reserve:          80.00MiB    (used: 0.00B)

Data,RAID5: Size:183.00GiB, Used:162.26GiB
   /dev/sda2      61.00GiB
   /dev/sdb2      61.00GiB
   /dev/sdc2      61.00GiB
   /dev/sdd2      61.00GiB

Metadata,RAID5: Size:2.03GiB, Used:228.56MiB
   /dev/sda2     864.00MiB
   /dev/sdb2     352.00MiB
   /dev/sdc2     864.00MiB
   /dev/sdd2     864.00MiB

System,RAID5: Size:64.00MiB, Used:16.00KiB
   /dev/sda2      32.00MiB
   /dev/sdc2      32.00MiB
   /dev/sdd2      32.00MiB

Unallocated:
   /dev/sda2       2.65TiB
   /dev/sdb2       2.65TiB
   /dev/sdc2       2.65TiB
   /dev/sdd2       2.65TiB

#btrfs fi df /mnt
Data, RAID5: total=183.00GiB, used=162.26GiB
System, RAID5: total=64.00MiB, used=16.00KiB
Metadata, RAID5: total=2.03GiB, used=228.56MiB
GlobalReserve, single: total=80.00MiB, used=0.00B


#  btrfs fi show
Label: none  uuid: 26220e12-d6bd-48b2-89bc-e5df29062484
    Total devices 4 FS bytes used 162.48GiB
    devid    1 size 2.71TiB used 61.88GiB path /dev/sda2
    devid    2 size 2.71TiB used 61.34GiB path /dev/sdb2
    devid    3 size 2.71TiB used 61.88GiB path /dev/sdc2
    devid    4 size 2.71TiB used 61.88GiB path /dev/sdd2



>
> Presumably you used btrfs device add and then btrfs balance to do the
> convert.  Do you perhaps remember the balance command you used?

Fortunately the full log (except the parts done with a livecd) is
there. I've tried to filter out irrelevant btrfs commands. Still
keeping the track of my jaggy setup trajectory :

   17  mkfs.btrfs /dev/sdb2
   18  mkfs.btrfs /dev/sdc2
   19  mkfs.btrfs /dev/sdd2
   29  btrfs device add /dev/sdb2 /dev/sc2 /dev/sdd2 /dev/sda2
   30  btrfs device add /dev/sdb2 /dev/sc2 /dev/sdd2 /
   31  btrfs device add /dev/sdb2 /dev/sdc2 /dev/sdd2 /
   32  btrfs device add /dev/sdb2 /dev/sdc2 /dev/sdd2 / -f
   34  btrfs balance start -dconvert=raid5 -mconvert=raid5 /
   41  btrfs fi balance start -dconvert=raid5 -mconvert=raid5  /
   43  btrfs fi balance start -dconvert=single -mconvert=single  /
   44  btrfs fi balance start -dconvert=single -mconvert=single
   45  btrfs fi balance start -dconvert=single -mconvert=single  /dev/sda2
   46  btrfs fi balance start -dconvert=single -mconvert=single  /dev/sdb2
   47  btrfs fi balance start -f  -dconvert=single -mconvert=single  /
   50  btrfs fi balance start -f  -dconvert=single -mconvert=single  /
   57  btrfs fi balance start -f  -dconvert=raid5 -mconvert=raid5  /
  217  btrfs fi balance /
  240  btrfs-find-root
  241  btrfs-find-root  -a
  242  btrfs-find-root  -a /
  243  btrfs-find-root  /dev/sda2
  312  btrfs check /
  313  btrfs check
  321  btrfs-find-root /dev/sda2
  322  btrfs-find-root /dev/sdb2
  323  btrfs scrub status /
  325  btrfs check  /

>
> Or more precisely, were you sure to balance-convert both data AND
> metadata to raid5?

I am. But in front of the previous output, the question may be : are
you ? I wonder. Among the naughty things I did, maybe some were really
harmful ?

>
> Summary to ensure I'm getting it right:
>
> a) You had a working btrfs raid5
> b) You replaced one drive, which _appeared_ to work fine.

smartctl was ok ; and every btrfs checking tool I had at hand also.

> c) Reboot. (So it can't be a simple problem of btrfs getting confused
> with the device changes in memory)

Definitely yes.

> d) You tried to replace a second and things fell apart.

Before trying a second replacement, I did the complete rebuild,
reboot, and checked the btrfs file system.

>
> Unfortunately, an as yet not fully traced bug with exactly this sort of
> serial replace is actually one of the known bug's they're still
> investigating.  It's one of at least two known bugs that are severe
> enough to keep raid56 mode from stabilizing to the general level of the
> rest of btrfs and to continue to force that strongly negative-
> recommendation on anything but testing usage with data that can be safely
> lost, either because it's fully backed up or because it really is trivial
> testing data the loss of which is no big deal.

So if this is an already known bug, one of the motivations to post
here vanished : I guess the informations about this buggy setup is of
no interest to the developpers. Am I right ?

>
> Btrfs fi usage after the first replace may or may not have displayed a
> problem.  Similarly, btrfs scrub may or may not have detected and/or
> fixed a problem.  And again with btrfs check.  The problem right now is
> that while we have lots of reports of the serial replace bug, we don't
> have enough people confirmably doing these things after the first replace
> and reporting the results to know if they detect and possibly fix the
> issue, allowing the second replace to work fine if fixed, or not.

If you think I can help in anyway, please tell me.


In the meanwhile, I think I'll keep btrfs, but until linux 5.x reaches
the shelves, I may be more conservative and use the raid 1 or raid 10
modes following your advices. The very nice point with btrfs is its
flexibility : I'll be able to switch to an other mode later on. Likely
without any new installation. Nice.

Again, thank you very much for your reply and welcoming here.

On Sat, Apr 30, 2016 at 1:25 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Pierre-Matthieu anglade posted on Fri, 29 Apr 2016 11:24:12 +0000 as
> excerpted:
>
>> Setting up and then testing a system I've stumbled upon something that
>> looks exactly similar to the behaviour depicted by Marcin Solecki here
>> https://www.spinics.net/lists/linux-btrfs/msg53119.html.
>>
>> Maybe unlike Martin I still have all my disk working nicely. So the Raid
>> array is OK, the system running on it is ok. But If I remove one of the
>> drive and try to mount in degraded mode, mounting the filesystem, and
>> then recovering fails.
>>
>> More precisely, the situation is the following :
>> # uname -a
>> Linux ubuntu 4.4.0-21-generic #37-Ubuntu SMP Mon Apr 18
>> 18:33:37 UTC 2016 x86_64 x86_64 x86_64 GNU/Linu
>>
>> # btrfs --version btrfs-progs v4.4
>
> 4.4 kernel and progs.  You are to be commended. =:^)
>
> Unfortunately too many people report way old versions here, apparently
> not taking into account that btrfs in general is still stabilizing, not
> fully stable and mature, and that as a result what they're running is
> many kernels and fixed bugs ago.
>
> And FWIW, btrfs parity-raid, aka raid56 mode, is newer still, and while
> nominally complete for a year with the release of 4.4 (original nominal
> completion in 3.19), still remains less stable than redundancy-raid, aka
> raid1 or raid10 modes.  In fact, there's still known bugs in raid56 mode
> in the current 4.5, and presumably in the upcoming 4.6 as well, as I've
> not seen discussion indicating they've actually fully traced the bugs and
> been able to fix them just yet.
>
> So while btrfs in general, being still not yet fully stable, isn't yet
> really recommended unless you're using data you can afford to lose,
> either because it's backed up, or because it really is data you can
> afford to lose, for raid56 that's *DEFINITELY* the case, because (as
> you've nicely demonstrated) there are known bugs that can affect raid56
> recovery from degraded, to the point it's known that btrfs raid56 can't
> always be relied upon, so you *better* either have backups and be
> prepared to use them, or simply not put anything on the btrfs raid56 that
> you're not willing to lose in the first place.
>
> That's the general picture.  Btrfs raid56 is strongly negatively-
> recommended for anything but testing usage, at this point, as there are
> still known bugs that can affect degraded recovery.
>
> There's a bit more specific suggestions and detail below.
>
>> # btrfs fi show
>> warning, device 1 is missing
>> warning, device 1 is missing
>> warning devid 1 not found already
>> bytenr mismatch, want=125903568896, have=125903437824
>> Couldn't read tree root Label: none
>>  uuid: 26220e12-d6bd-48b2-89bc-e5df29062484
>>     Total devices 4 FS bytes used 162.48GiB
>>     devid    2 size 2.71TiB used 64.38GiB path /dev/sdb2
>>     devid    3 size 2.71TiB used 64.91GiB path /dev/sdc2
>>     devid    4 size 2.71TiB used 64.91GiB path /dev/sdd2
>>     *** Some devices missing
>
> Unfortunately you can't get it if the filesystem won't mount, but a btrfs
> fi usage (newer, should work with 4.4) or btrfs fi df (should work with
> pretty much any btrfs-tools, going back a very long way, but needs to be
> combined with btrfs fi show output as well to interpret) would have been
> very helpful, here.  Nothing you can do about it when you can't mount,
> but if you had saved the output before the first device removal/replace
> and again before the second, that would have been useful information to
> have.
>
>> # mount -o degraded /dev/sdb2 /mnt
>> mount: /dev/sdb2: can't read superblock
>>
>> # dmesg |tail
>> [12852.044823] BTRFS info (device sdd2): allowing degraded mounts
>> [12852.044829] BTRFS info (device sdd2): disk space caching is enabled
>> [12852.044831] BTRFS: has skinny extents
>> [12852.073746] BTRFS error (device sdd2): bad tree block
>> start 196608 125257826304
>> [12852.121589] BTRFS: open_ctree failed
>
> FWIW, tho you may already have known/gathered this, open ctree failed is
> the generic btrfs mount failure message.  The bad tree block error does
> tell you what block failed to read, but that's more an aid to developer
> debugging than help at the machine admin level.
>
>> ----------------
>> In case it may help I came there the following way :
>> 1) *I've installed ubuntu on a single btrfs partition.
>> * Then I have added 3 other partitions
>> * convert the whole thing to a raid5 array
>> * play with the system and shut-down
>
> Presumably you used btrfs device add and then btrfs balance to do the
> convert.  Do you perhaps remember the balance command you used?
>
> Or more precisely, were you sure to balance-convert both data AND
> metadata to raid5?
>
> Here's where the output of btrfs fi df and/or btrfs fi usage would have
> helped, since that would have displayed exactly what chunk formats were
> actually being used.
>
>> 2) * Removed drive sdb and replaced it with a new drive
>> * restored the whole thing (using a livecd, and btrfs replace)
>> * reboot
>> * checked that the system is still working
>> * shut-down
>
>> 3) *removed drive sda and replaced it with a new one
>> * tried to perform the exact same operations I did when replacing sdb.
>> * It fails with some messages (not quite sure they were the same as
>> above).
>> * shutdown
>
>> 4) * put back sda
>> * check that I don't get any error message with my btrfs raid
>
>> 5. So I'm sure nothings looks like being corrupted
>> * shut-down
>
>> 5) * tried again step 3.
>> * get the messages shown above.
>>
>> I guess I can still put back my drive sda and get my btrfs working.
>> I'd be quite grateful for any comment or help.
>> I'm wondering if in my case the problem is not comming from the fact the
>> tree root (or something of that kind living only on sda) has not been
>> replicated when setting up the raid array ?
>
> Summary to ensure I'm getting it right:
>
> a) You had a working btrfs raid5
> b) You replaced one drive, which _appeared_ to work fine.
> c) Reboot. (So it can't be a simple problem of btrfs getting confused
> with the device changes in memory)
> d) You tried to replace a second and things fell apart.
>
> Unfortunately, an as yet not fully traced bug with exactly this sort of
> serial replace is actually one of the known bug's they're still
> investigating.  It's one of at least two known bugs that are severe
> enough to keep raid56 mode from stabilizing to the general level of the
> rest of btrfs and to continue to force that strongly negative-
> recommendation on anything but testing usage with data that can be safely
> lost, either because it's fully backed up or because it really is trivial
> testing data the loss of which is no big deal.
>
> Btrfs fi usage after the first replace may or may not have displayed a
> problem.  Similarly, btrfs scrub may or may not have detected and/or
> fixed a problem.  And again with btrfs check.  The problem right now is
> that while we have lots of reports of the serial replace bug, we don't
> have enough people confirmably doing these things after the first replace
> and reporting the results to know if they detect and possibly fix the
> issue, allowing the second replace to work fine if fixed, or not.
>
> In terms of a fix, I'm not a dev, just a btrfs user (raid1 and dup
> modes), and not sure of the current status based on list discussion.  But
> I do know it has been multi-reported by enough sources to be considered a
> known bug so the devs are looking into it, and that it's considered bad
> enough to keep btrfs parity raid from being considered anything close to
> the stability of btrfs in general, until such time as a fix is merged.
>
> I'd suggest waiting until at least 4.8 (better 4.9) before
> reconsideration for your own use, however, as it doesn't look like the
> fixes will make 4.6, and even if they hit 4.7, a couple of releases
> without any critical bugs before considering it usable won't hurt.
>
> Recommended alternatives? Btrfs raid1 and raid10 modes are considered to
> be at the same stability level as btrfs in general and I use btrfs raid1
> myself.  Because btrfs redundant-raid modes are all exactly two copy,
> four devices (assuming same-size) will give you two devices worth of
> usable space in either raid1 or raid10 mode.  That's down from the three
> devices worth of usable space you'd get with raid5, but unlike btrfs
> raid5, btrfs raid1 and raid10 are actually usably stable and generally
> recoverable from single-device-loss, tho with btrfs itself still
> considered stabilizing, not fully stable and mature, backups are still
> strongly recommended.
>
> Of course there's also mdraid and dmraid, on top of which you can run
> btrfs as well as other filesystems, but neither of those raid
> alternatives do the routine data integrity checks that btrfs does (when
> it's working correctly, of course), and btrfs, seeing a single device,
> will still do them and detect damage, but won't be able to actually fix
> it as it does in btrfs raid1/10 and does when working in raid56 mode.
> Unless you use btrfs dup mode on the single-device upper layer of course,
> but in that case it would be more efficient to use btrfs raid1 on the
> lower layers.
>
> Another possible alternative is btrfs raid1, on a pair of mdraid0s (or
> dmraid if you prefer).  This still gets the data integrity and repair at
> the btrfs raid1 level, while the underlying md/dmraid0s help speed things
> up a bit compared to the not yet optimized btrfs raid10.
>
> Of course you can and may in fact wish to return to older and more mature
> filesystems like ext4, or the reiserfs I use here, possibly on top of md/
> dmraid, but of course neither of them actually do the normal mode
> checksumming and verification that btrfs does, only using their
> redundancy or parity in recovery situations.
>
> And of course there's zfs, most directly comparable to btrfs' feature set
> and much more mature, but with hardware and licensing issues.  Hardware-
> wise, on Linux it requires relatively huge amounts of ECC-RAM, compared
> to btrfs.  (Its data integrity verification depends far more on error-
> free memory than btrfs, and without ECC-RAM, if there is a memory error,
> it can corrupt zfs, where btrfs would simply trigger an error.  So ECC-
> RAM is very strongly recommended and AFAIK no guarantees are made with
> regard to running it without ECC-RAM.)  But for zfs on Linux, if you're
> looking at existing hardware that lacks ECC-memory capacities, it's
> almost certainly cheaper to simply get another couple drives if you
> really need that third drive's space worth and do btrfs raid1 or raid10,
> than to switch to ECC-memory compatible hardware.
>
> As for zfs licensing issues you may or may not care, and apparently
> Ubuntu considers them minor enough to ship zfs now, but I'll just say
> they make zfs a non-option for me.
>
> Of course you can always switch to one of the bsds with zfs support if
> you're more comfortable with than than running zfs on linux.
>
> But regardless of all the above, zfs remains the most directly btrfs
> comparable actually stable and mature filesystem solution out there, so
> if that's your priority above all the other things, you'll probably find
> a way to run it.
>
> (FWIW, the other severe known raid56 bug has to do with (sometimes, not
> always, thus complicating tracing the bug) extremely slow balances in
> ordered to restripe to more or less devices, as one might do instead of
> failed device replacement or simply to change the number of devices in
> the array, to the point that completion could take weeks, so long that
> the chance of a device death during the balance is non-trivial, which
> means while the process technically works, in practice it's not actually
> usable.  Given that similar to the bug you came across, the ability to do
> this sort of thing is one of the traditional uses of parity-raid, being
> so slow as to be practically unusable makes this bug a blocker in terms
> of btrfs raid56 stability and ability to recommend it for use.  Both
> these bugs will need to be fixed, with no others at the same level
> showing up, before btrfs raid56 mode can be properly recommended for
> anything but testing use.)
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Pierre-Matthieu Anglade
