Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34750 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933433AbcJLSFc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 14:05:32 -0400
Received: by mail-io0-f171.google.com with SMTP id r30so59139315ioi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 11:05:31 -0700 (PDT)
From: "Jason D. Michaelson" <jasondmichaelson@gmail.com>
To: "'Chris Murphy'" <lists@colorremedies.com>,
        "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
References: <5cde01d2230f$fa1e3150$ee5a93f0$@com> <CAJCQCtQ0SCZi36RG32NiHVYJRz8gHCtfhWYEqM93y2twX4C4JA@mail.gmail.com> <5ce201d22364$96702780$c3507680$@com> <CAJCQCtR_zOd=1hVrKAD_kKfE_EKZQ2omfWQV556Rg=OSbvEd0w@mail.gmail.com> <5e8501d223d7$715a9bb0$540fd310$@com> <CAJCQCtQ12AZQ9x2ddSSceGHpWYvB7sSVE0qty+=Ln9oibmiHRw@mail.gmail.com> <5e8601d223da$0cbf6c00$263e4400$@com> <CAJCQCtSBn1+CqqDkeHx+bBR8zSbN8hYQ9R4p9C2EtpBoVBP+Ww@mail.gmail.com> <5e8701d223f1$c7ea0960$57be1c20$@com> <CAJCQCtT4g0kQ3bhEmOGfyEM62r8a1w4B6S_AqW3Q-e+k+QHgag@mail.gmail.com>
In-Reply-To: <CAJCQCtT4g0kQ3bhEmOGfyEM62r8a1w4B6S_AqW3Q-e+k+QHgag@mail.gmail.com>
Subject: RE: raid6 file system in a bad state
Date: Wed, 12 Oct 2016 12:59:01 -0500
Message-ID: <602501d224b2$519b3330$f4d19990$@com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: chris@colorremedies.com [mailto:chris@colorremedies.com] On
> Behalf Of Chris Murphy
> Sent: Tuesday, October 11, 2016 3:38 PM
> To: Jason D. Michaelson; Btrfs BTRFS
> Cc: Chris Murphy
> Subject: Re: raid6 file system in a bad state
> 
> readding btrfs
> 
> On Tue, Oct 11, 2016 at 1:00 PM, Jason D. Michaelson
> <jasondmichaelson@gmail.com> wrote:
> >
> >
> >> -----Original Message-----
> >> From: chris@colorremedies.com [mailto:chris@colorremedies.com] On
> >> Behalf Of Chris Murphy
> >> Sent: Tuesday, October 11, 2016 12:41 PM
> >> To: Jason D. Michaelson
> >> Cc: Chris Murphy; Btrfs BTRFS
> >> Subject: Re: raid6 file system in a bad state
> >>
> >> On Tue, Oct 11, 2016 at 10:10 AM, Jason D. Michaelson
> >> <jasondmichaelson@gmail.com> wrote:
> >> > superblock: bytenr=65536, device=/dev/sda
> >> > ---------------------------------------------------------
> >> > generation              161562
> >> > root                    5752616386560
> >>
> >>
> >>
> >> > superblock: bytenr=65536, device=/dev/sdh
> >> > ---------------------------------------------------------
> >> > generation              161474
> >> > root                    4844272943104
> >>
> >> OK so most obvious is that the bad super is many generations back
> >> than the good super. That's expected given all the write errors.
> >>
> >>
> >
> > Is there any chance/way of going back to use this generation/root as
> a source for btrfs restore?
> 
> Yes with -t option and that root bytenr for the generation you want to
> restore. Thing is, that's so far back the metadata may be gone
> (overwritten) already. But worth a shot. I've recovered recently
> deleted files this way.

With the bad disc in place:

root@castor:~/btrfs-progs# ./btrfs restore -t 4844272943104 -D  /dev/sda /dev/null
parent transid verify failed on 4844272943104 wanted 161562 found 161476
parent transid verify failed on 4844272943104 wanted 161562 found 161476
checksum verify failed on 4844272943104 found E808AB28 wanted 0CEB169E
checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
bytenr mismatch, want=4844272943104, have=66211125067776
Couldn't read tree root
Could not open root, trying backup super
warning, device 6 is missing
warning, device 5 is missing
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
bytenr mismatch, want=20971520, have=267714560
ERROR: cannot read chunk root
Could not open root, trying backup super
warning, device 6 is missing
warning, device 5 is missing
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
bytenr mismatch, want=20971520, have=267714560
ERROR: cannot read chunk root
Could not open root, trying backup super

And what's interesting is that when I move the /dev/sdd (the current bad disc) out of /dev, rescan, and run btrfs restore with the main root I get similar output:

root@castor:~/btrfs-progs# ./btrfs restore -D  /dev/sda /dev/null
warning, device 2 is missing
checksum verify failed on 21430272 found 71001E6E wanted 95E3A3D8
checksum verify failed on 21430272 found 992E0C37 wanted 36992D8B
checksum verify failed on 21430272 found 992E0C37 wanted 36992D8B
bytenr mismatch, want=21430272, have=264830976
Couldn't read chunk tree
Could not open root, trying backup super
warning, device 6 is missing
warning, device 5 is missing
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
bytenr mismatch, want=20971520, have=267714560
ERROR: cannot read chunk root
Could not open root, trying backup super
warning, device 6 is missing
warning, device 5 is missing
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
checksum verify failed on 20971520 found 0FBD46D5 wanted FC3EB3AB
bytenr mismatch, want=20971520, have=267714560
ERROR: cannot read chunk root
Could not open root, trying backup super

So it doesn't seem to work, but the difference in output between the two, at least to my untrained eyes, is intriguing, to say the least.

> 
> 
> OK at this point I'm thinking that fixing the super blocks won't change
> anything because it sounds like it's using the new ones anyway and
> maybe the thing to try is going back to a tree root that isn't in any
> of the new supers. That means losing anything that was being written
> when the lost writes happened. However, for all we know some overwrites
> happened so this won't work. And also it does nothing to deal with the
> fragile state of having at least two flaky devices, and one of the
> system chunks with no redundancy.
> 

This is the one thing I'm not following you on. I know there's one device that's flaky. Originally sdi, switched to sdh, and today (after reboot to 4.7.7), sdd. You'll have to forgive my ignorance, but I'm missing how you determined that a second was flaky (or was that from the ITEM 0 not being replicated you mentioned yesterday?)

> 
> Try 'btrfs check' without repair. And then also try it with -r flag
> using the various tree roots we've seen so far. Try explicitly using
> 5752616386560, which is what it ought to use first anyway. And then
> also 4844272943104.
> 

root@castor:~/btrfs-progs# ./btrfs check --readonly /dev/sda
parent transid verify failed on 5752357961728 wanted 161562 found 159746
parent transid verify failed on 5752357961728 wanted 161562 found 159746
checksum verify failed on 5752357961728 found B5CA97C0 wanted 51292A76
checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
bytenr mismatch, want=5752357961728, have=56504706479104
Couldn't setup extent tree
ERROR: cannot open file system
root@castor:~/btrfs-progs# ./btrfs check --readonly /dev/sdd
parent transid verify failed on 4844272943104 wanted 161474 found 161476
parent transid verify failed on 4844272943104 wanted 161474 found 161476
checksum verify failed on 4844272943104 found E808AB28 wanted 0CEB169E
checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
bytenr mismatch, want=4844272943104, have=66211125067776
Couldn't read tree root
ERROR: cannot open file system

root@castor:~/btrfs-progs# ./btrfs check --readonly -r 5752616386560 /dev/sda
parent transid verify failed on 5752357961728 wanted 161562 found 159746
parent transid verify failed on 5752357961728 wanted 161562 found 159746
checksum verify failed on 5752357961728 found B5CA97C0 wanted 51292A76
checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
bytenr mismatch, want=5752357961728, have=56504706479104
Couldn't setup extent tree
ERROR: cannot open file system
root@castor:~/btrfs-progs# ./btrfs check --readonly -r 5752616386560 /dev/sdd
parent transid verify failed on 5752616386560 wanted 161474 found 161562
parent transid verify failed on 5752616386560 wanted 161474 found 161562
checksum verify failed on 5752616386560 found 2A134884 wanted CEF0F532
checksum verify failed on 5752616386560 found B7FE62DB wanted 3786D60F
checksum verify failed on 5752616386560 found B7FE62DB wanted 3786D60F
bytenr mismatch, want=5752616386560, have=56504661311488
Couldn't read tree root
ERROR: cannot open file system

root@castor:~/btrfs-progs# ./btrfs check --readonly -r 4844272943104 /dev/sda
parent transid verify failed on 4844272943104 wanted 161562 found 161476
parent transid verify failed on 4844272943104 wanted 161562 found 161476
checksum verify failed on 4844272943104 found E808AB28 wanted 0CEB169E
checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
bytenr mismatch, want=4844272943104, have=66211125067776
Couldn't read tree root
ERROR: cannot open file system
root@castor:~/btrfs-progs# ./btrfs check --readonly -r 4844272943104 /dev/sdd
parent transid verify failed on 4844272943104 wanted 161474 found 161476
parent transid verify failed on 4844272943104 wanted 161474 found 161476
checksum verify failed on 4844272943104 found E808AB28 wanted 0CEB169E
checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
checksum verify failed on 4844272943104 found 4694222D wanted 5D4F0640
bytenr mismatch, want=4844272943104, have=66211125067776
Couldn't read tree root
ERROR: cannot open file system


> That might go far enough back before the bad sectors were a factor.
> Normally what you'd want is for it to use one of the backup roots, but
> it's consistently running into a problem with all of them when using
> recovery mount option.
> 

Is that a result of all of them being identical, save for the bad disc?

Again, Chris, Thank you so much for your time looking at this! Btrfs on the whole is something that, as a developer, I'd love to become involved with. Alas, there are only 24 hours in the day. 

> 
> 
> 
> 
> --
> Chris Murphy

