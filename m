Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35695 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932454AbcJLWNn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 18:13:43 -0400
Received: by mail-oi0-f43.google.com with SMTP id d132so77300928oib.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 15:13:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <602501d224b2$519b3330$f4d19990$@com>
References: <5cde01d2230f$fa1e3150$ee5a93f0$@com> <CAJCQCtQ0SCZi36RG32NiHVYJRz8gHCtfhWYEqM93y2twX4C4JA@mail.gmail.com>
 <5ce201d22364$96702780$c3507680$@com> <CAJCQCtR_zOd=1hVrKAD_kKfE_EKZQ2omfWQV556Rg=OSbvEd0w@mail.gmail.com>
 <5e8501d223d7$715a9bb0$540fd310$@com> <CAJCQCtQ12AZQ9x2ddSSceGHpWYvB7sSVE0qty+=Ln9oibmiHRw@mail.gmail.com>
 <5e8601d223da$0cbf6c00$263e4400$@com> <CAJCQCtSBn1+CqqDkeHx+bBR8zSbN8hYQ9R4p9C2EtpBoVBP+Ww@mail.gmail.com>
 <5e8701d223f1$c7ea0960$57be1c20$@com> <CAJCQCtT4g0kQ3bhEmOGfyEM62r8a1w4B6S_AqW3Q-e+k+QHgag@mail.gmail.com>
 <602501d224b2$519b3330$f4d19990$@com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 12 Oct 2016 13:36:33 -0600
Message-ID: <CAJCQCtT8Lmo1k=PV0arYGmZqpo0k3MOABbXrR4MZ73=viQh1+Q@mail.gmail.com>
Subject: Re: raid6 file system in a bad state
To: "Jason D. Michaelson" <jasondmichaelson@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 11:59 AM, Jason D. Michaelson
<jasondmichaelson@gmail.com> wrote:

> With the bad disc in place:
>
> root@castor:~/btrfs-progs# ./btrfs restore -t 4844272943104 -D  /dev/sda /dev/null
> parent transid verify failed on 4844272943104 wanted 161562 found 161476
> parent transid verify failed on 4844272943104 wanted 161562 found 161476
> checksum verify failed on 4844272943104 found E808AB28 wanted 0CEB169E
> checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
> checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
> bytenr mismatch, want=4844272943104, have=66211125067776
> Couldn't read tree root
> Could not open root, trying backup super
> warning, device 6 is missing
> warning, device 5 is missing
> warning, device 4 is missing
> warning, device 3 is missing
> warning, device 2 is missing
> checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
> checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
> bytenr mismatch, want=20971520, have=267714560
> ERROR: cannot read chunk root
> Could not open root, trying backup super
> warning, device 6 is missing
> warning, device 5 is missing
> warning, device 4 is missing
> warning, device 3 is missing
> warning, device 2 is missing
> checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
> checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
> bytenr mismatch, want=20971520, have=267714560
> ERROR: cannot read chunk root
> Could not open root, trying backup super


Don't all of these device missing messages seem bogus? I don't know
how to find out what's going on here. If it were me, I'd try to
reproduce this with a couple of distros's live images (Fedora Rawhide
and openSUSE Tumbleweed), and if they're both reproducing this
"missing" output, I'd file a bugzilla.kernel.org bug with a strace. I
mean, this stuff is hard enough as it is without bugs like this
getting in the way.

Fedora 25 nightly:
https://kojipkgs.fedoraproject.org/compose/branched/Fedora-25-20161008.n.0/compose/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-25-20161008.n.0.iso

That'll have some version of kernel 4.8, not sure which one. And it
will have btrfs-progs 4.6.1 which is safe but showing its age in Btrfs
years.

You can do this from inside the live environment:

sudo dnf update
https://kojipkgs.fedoraproject.org//packages/btrfs-progs/4.7.3/1.fc26/x86_64/btrfs-progs-4.7.3-1.fc26.x86_64.rpm

or

sudo dnf update
https://kojipkgs.fedoraproject.org//packages/btrfs-progs/4.8.1/1.fc26/x86_64/btrfs-progs-4.8.1-1.fc26.x86_64.rpm

It's probably just as valid to do this with whatever you have now,
strace that and file a bug. But it doesn't really for sure isolate
whether it's a local problem or not.


>
> And what's interesting is that when I move the /dev/sdd (the current bad disc) out of /dev, rescan, and run btrfs restore with the main root I get similar output:
>
> root@castor:~/btrfs-progs# ./btrfs restore -D  /dev/sda /dev/null
> warning, device 2 is missing
> checksum verify failed on 21430272 found 71001E6E wanted 95E3A3D8
> checksum verify failed on 21430272 found 992E0C37 wanted 36992D8B
> checksum verify failed on 21430272 found 992E0C37 wanted 36992D8B
> bytenr mismatch, want=21430272, have=264830976
> Couldn't read chunk tree
> Could not open root, trying backup super
> warning, device 6 is missing
> warning, device 5 is missing
> warning, device 4 is missing
> warning, device 3 is missing
> warning, device 2 is missing
> checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
> checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
> bytenr mismatch, want=20971520, have=267714560
> ERROR: cannot read chunk root
> Could not open root, trying backup super
> warning, device 6 is missing
> warning, device 5 is missing
> warning, device 4 is missing
> warning, device 3 is missing
> warning, device 2 is missing
> checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
> checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
> bytenr mismatch, want=20971520, have=267714560
> ERROR: cannot read chunk root
> Could not open root, trying backup super
>
> So it doesn't seem to work, but the difference in output between the two, at least to my untrained eyes, is intriguing, to say the least.

Yeah I'm not sure what to recommend now.



>
>>
>>
>> OK at this point I'm thinking that fixing the super blocks won't change
>> anything because it sounds like it's using the new ones anyway and
>> maybe the thing to try is going back to a tree root that isn't in any
>> of the new supers. That means losing anything that was being written
>> when the lost writes happened. However, for all we know some overwrites
>> happened so this won't work. And also it does nothing to deal with the
>> fragile state of having at least two flaky devices, and one of the
>> system chunks with no redundancy.
>>
>
> This is the one thing I'm not following you on. I know there's one device that's flaky. Originally sdi, switched to sdh, and today (after reboot to 4.7.7), sdd. You'll have to forgive my ignorance, but I'm missing how you determined that a second was flaky (or was that from the ITEM 0 not being replicated you mentioned yesterday?)

In your dmesg there was one device reported missing entirely, and then
a separate device had a sector read failure.



>
>>
>> Try 'btrfs check' without repair. And then also try it with -r flag
>> using the various tree roots we've seen so far. Try explicitly using
>> 5752616386560, which is what it ought to use first anyway. And then
>> also 4844272943104.
>>
>
> root@castor:~/btrfs-progs# ./btrfs check --readonly /dev/sda
> parent transid verify failed on 5752357961728 wanted 161562 found 159746
> parent transid verify failed on 5752357961728 wanted 161562 found 159746
> checksum verify failed on 5752357961728 found B5CA97C0 wanted 51292A76
> checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
> checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
> bytenr mismatch, want=5752357961728, have=56504706479104
> Couldn't setup extent tree
> ERROR: cannot open file system
> root@castor:~/btrfs-progs# ./btrfs check --readonly /dev/sdd
> parent transid verify failed on 4844272943104 wanted 161474 found 161476
> parent transid verify failed on 4844272943104 wanted 161474 found 161476
> checksum verify failed on 4844272943104 found E808AB28 wanted 0CEB169E
> checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
> checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
> bytenr mismatch, want=4844272943104, have=66211125067776
> Couldn't read tree root
> ERROR: cannot open file system
>
> root@castor:~/btrfs-progs# ./btrfs check --readonly -r 5752616386560 /dev/sda
> parent transid verify failed on 5752357961728 wanted 161562 found 159746
> parent transid verify failed on 5752357961728 wanted 161562 found 159746
> checksum verify failed on 5752357961728 found B5CA97C0 wanted 51292A76
> checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
> checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
> bytenr mismatch, want=5752357961728, have=56504706479104
> Couldn't setup extent tree
> ERROR: cannot open file system
> root@castor:~/btrfs-progs# ./btrfs check --readonly -r 5752616386560 /dev/sdd
> parent transid verify failed on 5752616386560 wanted 161474 found 161562
> parent transid verify failed on 5752616386560 wanted 161474 found 161562
> checksum verify failed on 5752616386560 found 2A134884 wanted CEF0F532
> checksum verify failed on 5752616386560 found B7FE62DB wanted 3786D60F
> checksum verify failed on 5752616386560 found B7FE62DB wanted 3786D60F
> bytenr mismatch, want=5752616386560, have=56504661311488
> Couldn't read tree root
> ERROR: cannot open file system
>
> root@castor:~/btrfs-progs# ./btrfs check --readonly -r 4844272943104 /dev/sda
> parent transid verify failed on 4844272943104 wanted 161562 found 161476
> parent transid verify failed on 4844272943104 wanted 161562 found 161476
> checksum verify failed on 4844272943104 found E808AB28 wanted 0CEB169E
> checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
> checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
> bytenr mismatch, want=4844272943104, have=66211125067776
> Couldn't read tree root
> ERROR: cannot open file system
> root@castor:~/btrfs-progs# ./btrfs check --readonly -r 4844272943104 /dev/sdd
> parent transid verify failed on 4844272943104 wanted 161474 found 161476
> parent transid verify failed on 4844272943104 wanted 161474 found 161476
> checksum verify failed on 4844272943104 found E808AB28 wanted 0CEB169E
> checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
> checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
> bytenr mismatch, want=4844272943104, have=66211125067776
> Couldn't read tree root
> ERROR: cannot open file system

Someone else who knows more will have to speak up. This is one of the
more annoying things about Btrfs's state right now, is it's not at all
clear to a regular user what sequence to attempt repairs in. It's a
shot in the dark. Other file systems it's much easier. It fails to
mount, you run fsck with default options, and it either can fix it or
it can't. Btrfs, it's many options, many orders, very developer
oriented messages, and no hints what the next step is to take.

At this point you could set up some kind of overlay on each drive,
maybe also using blockdev to set each block device read only to ensure
the original is not modified.

Something like this:
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

But that will avoid this: "Block-level copies of devices"
https://btrfs.wiki.kernel.org/index.php/Gotchas

I haven't tried this, so I'm not really certain how to hide the
original and overlay from the kernel since they both have to be
present at the same time. Maybe an LVM snapshot LV can be presented to
libvirt/virt-manager and you can use one a recent distro image to boot
the VM and try some repairs. I just can't tell you what order to do
them in.

Cannot read chunk root is a problem, maybe it can be repaired with
btrfs rescue chunk-recover. Cannot read tree root is also a problem,
once the chunk is repaired, maybe it's possible to repair it. The
extent tree can't be used until the chunk tree is readable so that
ought to just take care of itself. You might be looking at chunk
recover, super recover, check --repair, and maybe even check --repair
--init-extent-tree. And as a last resort --init-csum-tree which really
is just papering over real problems in a way that now the file system
won't know what's bad and makes things worse but it might survive long
enough to get more data off.

And actually, before any of the above, you could see if you can take a
btrfs-image -t4 -c9 -s, and also btrfs-debug-tree and output to a file
somewhere. Maybe then it's a useful donation image for making the
tools better.



>
>
>> That might go far enough back before the bad sectors were a factor.
>> Normally what you'd want is for it to use one of the backup roots, but
>> it's consistently running into a problem with all of them when using
>> recovery mount option.
>>
>
> Is that a result of all of them being identical, save for the bad disc?

I don't understand the question. The bad disk is the one that has the
bad super, but all the tools are clearly ignoring the bad super when
looking for the tree root. So I don't think the bad disk is a factor.
I can't prove it but I think the problems were happening before the
bad disk, it's just that the bad disk added to the confusion and may
also be preventing repairs.


-- 
Chris Murphy
