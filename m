Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:33103 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdA1Mpc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 07:45:32 -0500
Received: by mail-yw0-f177.google.com with SMTP id u68so32605493ywg.0
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jan 2017 04:45:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$cc953$ec4078b0$696ed46d$9618e10e@cox.net>
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
 <20170126092559.GD24076@carfax.org.uk> <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
 <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com> <2c02d0b6-859d-f66f-e259-748db131d38d@googlemail.com>
 <304177d4-cc35-9bfc-816c-85ff3501dc50@gmail.com> <pan$cc953$ec4078b0$696ed46d$9618e10e@cox.net>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Sat, 28 Jan 2017 13:37:33 +0100
Message-ID: <CANznX5H1iyrwzamf0NS1iu=taXPaJGnS=XecBLtFKf9r6th2vQ@mail.gmail.com>
Subject: Re: btrfs recovery
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I usually compile my kernels with CONFIG_X86_RESERVE_LOW=640 and
CONFIG_X86_CHECK_BIOS_CORRUPTION=N because 640 kilobyte seems like a
very cheap price to pay in order to avoid worrying about this (and
skip the associated checking + monitoring).

Out of curiosity (after reading this email) I set these to 4 and Y (so
1 page = 4k reserve and checking turned ON and activated by default)
on a useless laptop. Right after reboot, the kernel log was full of
the same kind of Btrfs errors reported in the first email of this
topic ("bad key order", etc). I could run a scrub with zero errors and
successfully reboot with a read-write mounted root filesystem with the
old kernel build (but the kernel log was still full of errors, as your
might imagine). I tried to run "btrfs check --repair" but it seems to
be useless in this situation, the filesystem needs to be recreated
(not too hard in my case when it's still fully readable). Although,
the kernel log was free of the "Corrupted low memory at" kind of
messages (even though I let it run for hours).

On Sat, Jan 28, 2017 at 6:00 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Austin S. Hemmelgarn posted on Fri, 27 Jan 2017 07:58:20 -0500 as
> excerpted:
>
>> On 2017-01-27 06:01, Oliver Freyermuth wrote:
>>>> I'm also running 'memtester 12G' right now, which at least tests 2/3
>>>> of the memory. I'll leave that running for a day or so, but of course
>>>> it will not provide a clear answer...
>>>
>>> A small update: while the online memtester is without any errors still,
>>> I checked old syslogs from the machine and found something intriguing.
>
>>> kernel: Corrupted low memory at ffff880000009000 (9000 phys) = 00098d39
>>> kernel: Corrupted low memory at ffff880000009000 (9000 phys) = 00099795
>>> kernel: Corrupted low memory at ffff880000009000 (9000 phys) = 000dd64e
>
> 0x9000 = 36K...
>
>>> This seems to be consistently happening from time to time (I have low
>>> memory corruption checking compiled in).
>>> The numbers always consistently increase, and after a reboot, start
>>> fresh from a small number again.
>>>
>>> I suppose this is a BIOS bug and it's storing some counter in low
>>> memory. I am unsure whether this could have triggered the BTRFS
>>> corruption, nor do I know what to do about it (are there kernel quirks
>>> for that?). The vendor does not provide any updates, as usual.
>>>
>>> If someone could confirm whether this might cause corruption for btrfs
>>> (and maybe direct me to the correct place to ask for a kernel quirk for
>>> this device - do I ask on MM, or somewhere else?), that would be much
>>> appreciated.
>
>> It is a firmware bug, Linux doesn't use stuff in that physical address
>> range at all.  I don't think it's likely that this specific bug caused
>> the corruption, but given that the firmware doesn't have it's
>> allocations listed correctly in the e820 table (if they were listed
>> correctly, you wouldn't be seeing this message), it would not surprise
>> me if the firmware was involved somehow.
>
> Correct me if I'm wrong (I'm no kernel expert, but I've been building my
> own kernel for well over a decade now so having a working familiarity
> with the kernel options, of which the following is my possibly incorrect
> read), but I believe that's only "fact check: mostly correct" (mostly as
> in yes it's the default, but there's a mainline kernel option to change
> it).
>
> I was just going over the related kernel options again a couple days ago,
> so they're fresh in my head, and AFAICT...
>
> There are THREE semi-related kernel options (config UI option location is
> based on the mainline 4.10-rc5+ git kernel I'm presently running):
>
> DEFAULT_MMAP_MIN_ADDR
>
> Config location: Processor type and features:
> Low address space to protect from user allocation
>
> This one is virtual memory according to config help, so likely not
> directly related, but similar idea.
>
> X86_CHECK_BIOS_CORRUPTION
>
> Location: Same section, a few lines below the first one:
> Check for low memory corruption
>
> I guess this is the option you (OF) have enabled.  Note that according to
> help, in addition to enabling this in options, a runtime kernel
> commandline option must be given as well, to actually enable the checks.
>
> X86_RESERVE_LOW
>
> Location: Same section, immediately below the check option:
> Amount of low memory, in kilobytes, to reserve for the BIOS
>
> Help for this one suggests enabling the check bios corruption option
> above if there are any doubts, so the two are directly related.
>
> All three options apparently default to 64K (as that's what I see here
> and I don't believe I've changed them), but can be changed.  See the
> kernel options help and where it points for more.
>
> My read of the above is that yes, by default the kernel won't use
> physical 0x9000 (36K), as it's well within the 64K default reserve area,
> but a blanket "Linux doesn't use stuff in that physical address range at
> all" is incorrect, as if the defaults have been changed it /could/ use
> that space (#3's minimum is 1 page, 4K, leaving that 36K address
> uncovered) -- there's a mainline-official option to do so, so it doesn't
> even require patching.
>
> Meanwhile, since the defaults cover it, no quirk should be necessary (tho
> I might increase the reserve and test coverage area to the maximum 640K
> and run for awhile to be sure it's not going above the 64K default), but
> were it outside the default 64K coverage area, I would probably file it
> as a bug (my usual method for confirmed bugs), and mark it initially as
> an arch-x86 bug, tho they may switch it to something else, later.  But
> the devs would probably suggest further debugging, possibly giving you
> debug patches to try, etc, to nail down the specific device, before
> setting up a quirk for it.  Because the problem could be an expansion
> card or something, not the mobo/factory-default-machine, too, and it'd be
> a shame to setup a quirk for the wrong hardware.
>
>>> Additionally, I found that "btrfs restore" works on this broken FS. I
>>> will take an external backup of the content within the next 24 hours
>>> using that, then I am ready to try anything you suggeest.
>
>> FWIW the fact that btrfs restore works is a good sign, it means that
>> the filesystem is almost certainly repairable (even though the tools
>> might not be able to repair it themselves).
>
> Btrfs restore is a very useful tool.  It has gotten me out of a few
> "changes since the last backup weren't valuable enough to have updated
> the backup yet when the risk was theoretical, so nothing serious, but now
> that it's no longer theory only, it'd still be useful to be able to save
> the current version, if it's not /too/ much trouble" type situations,
> myself. =:^)
>
> Just don't count on restore to save your *** and always treat what it can
> often bring to current as a pleasant surprise, and having it fail won't
> be a down side, while having it work, if it does, will always be up side.
> =:^)
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
