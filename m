Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34147 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbcFDFdE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 01:33:04 -0400
Received: by mail-io0-f172.google.com with SMTP id p194so100501711iod.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 22:33:03 -0700 (PDT)
Received: from [169.254.77.254] ([70.51.159.130])
        by smtp.gmail.com with ESMTPSA id d80sm4289793iod.24.2016.06.03.22.33.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Fri, 03 Jun 2016 22:33:01 -0700 (PDT)
Message-ID: <5752680C.2020606@gmail.com>
Date: Sat, 04 Jun 2016 01:33:00 -0400
From: "B. S." <bs27975@gmail.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Pointers to mirroring partitions (w/ encryption?) help?
References: <5751E8D2.7070001@gmail.com> <CAKZK7uyRSUBp3J=HunPbmFVzLzzH1=QghOD2_p-5+UpyMXuGGg@mail.gmail.com>
In-Reply-To: <CAKZK7uyRSUBp3J=HunPbmFVzLzzH1=QghOD2_p-5+UpyMXuGGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/2016 09:39 PM, Justin Brown wrote:
> Here's some thoughts:
>
>> Assume a CD sized (680MB) /boot
>
> Some distros carry patches for grub that allow booting from Btrfs,
> so no separate /boot file system is required. (Fedora does not;
> Ubuntu -- and therefore probably all Debians -- does.)

OTOH, a separate /boot keeps all possible future options open, and
reduces complexity. e.g. unwinding a /boot from within /, later.
Regardless, no harm in having separate /boot. (Assuming not worried
about partition presence detection.)

>> perhaps a 200MB (?) sized EFI partition
>
> Way bigger than necessary. It should only be 1-2MiB, and IIRC 2MiB
> might be the max UEFI allows.

Thanks for that. https://en.wikipedia.org/wiki/EFI_system_partition,
which I stupidly didn't think to look at at the time, doesn't speak to
size, but does note, for Gummiboot, "Configuration file fragments, 
kernel images and initrd images are required to reside on the EFI System
partition, as Gummiboot does not provide support for accessing files on
other partitions or file systems." So I'm not sure that 2MB is large
enough, and I suspect exceeding 2MB, reasonably, should do no harm
except waste some space.

>> then creates another partition for mirroring, later. IIUC, btrfs
>> add device /dev/sda4 / is appropriate, then. Then running a balance
>> seems recommended.
>
> Don't do this. It's not going to provide any additional protection
> that you can't do in a smarter way. If you only have one device and
> want data duplication, just use the `dup` data profile (settable via
> `balance`). In fact, by default Btrfs uses the `dup` profile for
> metadata (and `single` for data). You'll get all the data integrity
> benefits with `dup`.

Thank you for that. So a data dup'ed fs will overwrite a checksum 
failing file with the (checksum succeeding) 2nd copy, and the weekly 
scrub will ensure the reverse won't happen (likely). Cool!

I wonder if a separate physical partition brings anything to the party.
OTOH, a botched partition, duplicated, is still botched. Hmm.

Having a btrfs partition currently, with / even, can the partition be
grown and dup added after the fact?

> One of the best features and initally confusing things about Btrfs
> is how much is done "within" a file system. (There is a certain "the
> Btrfs way" to it.)

Yep. Thus the questions. And thank you, list, for being here.

>
>> Confusing, however, is having those (both) partitions encrypted.
>> Seems some work is needed beforehand. But I've never done
>> encryption.
>
> (This is moot if you go with `dup`.) It's actually quite easy with
> every major distro. If we're talking about a fresh install, the
> distro installer probably has full support

... don't we wish. Just tried a Kubuntu 16.04 LTS install ... passphrase 
request hidden and broken. Some googling suggests staying away from 
K/Ubuntu at the moment for crypt installs. Installer broken.

So switched to Debian 8, which is bringing its own problems. e.g. 
network can ping locally but not outside. Set static address and it's 
fine - go figure. Broken video and updates, and more. This, I expect, 
has more to do with getting back into the Debian way.

> for passphrase-based
> dm-crypt LUKS encryption, including multiple volumes sharing a
> passphrase.

... and you're back to why I posted the OP. Just sinking into such, and 
the water is murky. No doubt, like so many other things Linux, in a few 
years in will be old hat. Not there yet, though.

> An existing install should be convertable without much
> trouble. It's ususally just a matter of setting up the container with
> `cryptsetup`, populating `/etc/crypttab`, possibly adding crypto
> modules to your initrd and/or updating settings, and rebuilding the
> initrd. (I have first-hand experience doing this on a Fedora install
> recently, and it took about half an hour and I knew nothing about
> Fedora's `dracut` initrd generator tool.)

Hmmm. Interesting thought. Perhaps I should clone a current install, and 
go through the exercise. Then trying to do it all at once on a new 
install should have a lower learning curve / botch risk.

> If you do need multiple encrypted file systems, simply use the same
> passphrase for all volumes (but never do this by cloning the LUKS
> headers). You'll only need to enter it once at boot.

Good to know, thank you. That's not obvious / made readily apparent when 
googling.

Let alone, if trying to reduce complexity by ignoring LVM, it isn't 
readily apparent that dmcrypt involves LUKS. Too many terms and 
technologies flying by, cross-pollinating, even.

>> The additional problem is most articles reference FDE (Full Disk
>> Encryption) - but that doesn't seem to be prudent. e.g. Unencrypted
>> /boot. So having problems finding concise links on the topics, -FDE
>> -"Full Disk Encryption".
>
> Yeah, when it comes to FDE, you either have to make your peace with
> trusting the manufacturer, or you can't. If you are going to boot
> your system with a traditional boot loader, an unencrypted partition
> is mandatory. That being said, we live in a world with UEFI Secure
> Boot.

Another learning curve (UEFI) to swallow at the same time as all the 
other here. Current install is the first time it has occurred to me to 
try to incorporate SecureBoot, UEFI, crypt, and all such 'goodness' on a 
fresh (raw) install. Debian is bringing apt-secure along for the ride on 
me, too.

> While your EFI parition must be unencrypted vfat, you can sign
> the kernels (or shims), and the UEFI can be configured to only boot
> signed executables, including only those signed by your own key. Some
> distros already provide this feature, including using keys probably
> already trusted by the default keystore.
>
>> mirror subvolumes (or it inherently comes along for the ride?)
>
> Yes, that is correct. Just to give some more background: the data
> and metadata profiles control "mirroring," and they are set at the
> file system level. Subvolumes live entirely within one file system,
> so whatever profile is set in the FS applies to subvolumes.

Gotcha, thus your dup observation.

However ... the question was aimed at a crypto sda3, thus containing @, 
and probably @home, sda4 created ... how might one kick in to (btrfs) 
mirror sda3 in sda4, including @ and @home.

I would guess, from your comment, once one adds sda4 to the sda3 set, 
all that (sda3) profile applies, gets applied to sda4, and all the btrfs 
magic goodness ... just happens.

Particularly after running balance to force all that goodness to happen 
at once / now, rather than upon next write.

>> So, I could take an HD, create partitions as above (how? e.g. Set
>> up encryption / btrfs mirror volumes), then clonezilla (?)
>> partitions from a current machine in.
>
> Are you currently using Btrfs? If so, use Btrfs' `send` and
> `receive` commands.

Yeah. Ick. :-) Have had better luck in the past just cloning or mounting 
and cp -a. Likely, my lack of experience was the issue.

In any case, here, the question was pointed at a new install.

 > That should be lot friendlier to your SSD. (I'll
> take this opportunity to say that you need to consider the `discard`
> mount *and* `/etc/crypttab` options. Discard -- or scheduling
> `fstrim` -- is extremely important to maintain optimal performance of
> a SSD, but there are some privacy trade-offs on encrypted systems.)
> If not, then `cp -a` or similar will work.

SSD not yet in play here, but I do take your point. I had to work 
through all that on the SSD I do have, so I do know to peek at such 
whenever an SSD come into play.

Didn't know about the /etc/crypttab options, thanks for that. Heck, 
hadn't gotten as far as knowing there was an /etc/crypttab.

- thus, I think part of my OP question is what all am I attempting to 
swallow in one go on a fresh install here? I get dmcrypt and uefi is 
involved, so I can start to break down the googling into component 
pieces. Thus, I think, the request for an appropriate link. Something 
that does it all on a fresh install in one go would be good, 
particularly if it identifies the major sub-topics, and has 'links to 
more info'.

> Obviously, you'll have to
> get your boot mechanism and file system identifiers updated in
> addition to `/etc/crypttab` described above.
>
> Lastly, strongly consider `autodefrag` and possibly setting some
> highly violatile -- but *unimportant* -- directories to `nodatacow`
> via purging and `chattr +C`. (I do this for ~/.cache and
> /var/cache.)

Yep, autodefrag is in the mount options. I have a number of home systems 
running btrfs for some years now. Started with Kubuntu 12.04 LTS (since 
running hwe kernels to get later btrfs tools), and a couple of 14.04's. 
GB rsyncs and mondoarchives fly all about the house in cascading 
archives, nightly.

A recent 4TB HD failure is part of the reason for the OP questions. A 
scrub at the time revealed many failures, and dealing with that and 
figuring out which files to fetch from secondary archives was a 
challenge. BUT, FANTASTICALLY, for the first time (pre-btrfs days), at 
least btrfs / something specifically identified WHICH files were 
botched. I wasn't left wondering what botched file will reveal itself 
months from now ... after the botched file had cascaded to all backups!

Having been bitten, and facing a new install, thought I'd better OP.

>> Yet not looking to put in a 2nd HD
>
> If you change your mind and decide on a backup device, or even if
> you just want local backup snapshots, one of the best snapshot
> managers is btrfs-sxbackup (no association with the FS project).

Thank you for that!

Thus far, keeping only the OS on / and mondoarchiving it nightly, and 
rsync'ing /everythingelse seems to be doing the job. Perhaps even 
keeping the 'after the failure' complexity level down.

> On Fri, Jun 3, 2016 at 3:30 PM, B. S. <bs27975@gmail.com> wrote:
>> Hallo. I'm continuing on sinking in to btrfs, so pointers to
>> concise help articles appreciated. I've got a couple new home
>> systems, so perhaps it's time to investigate encryption, and given
>> the bit rot I've seen here, perhaps time to mirror volumes so the
>> wonderful btrfs self-healing facilities can be taken advantage of.
>>
>> Problem with today's hard drives, a quick look at Canada Computer
>> shows the smallest drives 500GB, 120GB SSDs, far more than the 20GB
>> or so an OS needs. Yet not looking to put in a 2nd HD, either. It
>> feels like mirroring volumes makes sense.
>>
>> (EFI [partitions] also seem to be sticking their fingers in here.]
>>
>> Assume a CD sized (680MB) /boot, and perhaps a 200MB (?) sized EFI
>> partition, it seems to me one sets up / as usual (less complex
>> install), then creates another partition for mirroring, later.
>> IIUC, btrfs add device /dev/sda4 / is appropriate, then. Then
>> running a balance seems recommended.
>>
>> Confusing, however, is having those (both) partitions encrypted.
>> Seems some work is needed beforehand. But I've never done
>> encryption. I have come across
>> https://github.com/gebi/keyctl_keyscript, so I understand there
>> will be gotchas to deal with - later. But not there yet, and not
>> real sure how to start.
>>
>> The additional problem is most articles reference FDE (Full Disk
>> Encryption) - but that doesn't seem to be prudent. e.g. Unencrypted
>> /boot. So having problems finding concise links on the topics, -FDE
>> -"Full Disk Encryption".
>>
>> Any good links to concise instructions on building / establishing
>> encrypted btrfs mirror volumes? dm_crypt seems to be the basis, and
>> not looking to add LVM, seems an unnecessary extra layer of
>> complexity.
>>
>> It also feels like I could mkfs.btrfs /dev/sda3 /dev/sda4, then
>> mirror subvolumes (or it inherently comes along for the ride?) - so
>> my confusion level increases. Especially if encryption is added to
>> the mix.
>>
>> So, I could take an HD, create partitions as above (how? e.g. Set
>> up encryption / btrfs mirror volumes), then clonezilla (?)
>> partitions from a current machine in. I assume mounting a live cd
>> then cp -a from old disk partition to new disk partition won't
>> 'just work'. (?)
>>
>> Article suggestions? -- To unsubscribe from this list: send the
>> line "unsubscribe linux-btrfs" in the body of a message to
>> majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
