Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:38549 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755346AbeFYQYl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 12:24:41 -0400
Subject: Re: btrfs balance did not progress after 12H, hang on reboot, btrfs
 check --repair kills the system still
To: Marc MERLIN <marc@merlins.org>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <20180618130055.3rzngk5a5sktfp7p@merlins.org>
 <20180619154730.fblylttw2nyps4cp@merlins.org>
 <CA+X5Wn5_TEH5zwWS8cihnadK_hFg9CL6NcT9Q28mDxtZK97Beg@mail.gmail.com>
 <ab17f789-d475-9812-9c76-83702fc2bd65@gmail.com>
 <20180625160706.qnd22zgdv2kwq6dz@merlins.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <58d9fd8d-48b9-669f-05f1-82da9ce0c510@mendix.com>
Date: Mon, 25 Jun 2018 18:24:37 +0200
MIME-Version: 1.0
In-Reply-To: <20180625160706.qnd22zgdv2kwq6dz@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/25/2018 06:07 PM, Marc MERLIN wrote:
> On Tue, Jun 19, 2018 at 12:58:44PM -0400, Austin S. Hemmelgarn wrote:
>>> In your situation, I would run "btrfs pause <path>", wait to hear from
>>> a btrfs developer, and not use the volume whatsoever in the meantime.
>> I would say this is probably good advice.  I don't really know what's going
>> on here myself actually, though it looks like the balance got stuck (the
>> output hasn't changed for over 36 hours, unless you've got an insanely slow
>> storage array, that's extremely unusual (it should only be moving at most
>> 3GB of data per chunk)).
> 
> I didn't hear from any developer, so I had to continue.
> - btrfs scrub cancel did not work (hang)

Did you mean balance cancel? It waits until the current block group is
finished.

> - at reboot mounting the filesystem hung, even with 4.17, which is
>   disappointing (it should not hang)
> - mount -o recovery still hung
> - mount -o ro did not hang though
> 
> Sigh, why is my FS corrupted again?

Again? Do you think balance is corrupting the filesystem? Or have there
been previous btrfs check --repair operations which made smaller
problems bigger in the past?

> Anyway, back to 
> btrfs check --repair
> and, it took all my 32GB of RAM on a system I can't add more RAM to, so
> I'm hosed. I'll note in passing (and it's not ok at all) that check
> --repair after a 20 to 30mn pause, takes all the kernel RAM more quickly
> than the system can OOM or log anything, and just deadlocks it.
> This is repeateable and totally not ok :(
> 
> I'm now left with btrfs-progs git master, and lowmem which finally does
> a bit of repair.
> So far:
> gargamel:~# btrfs check --mode=lowmem --repair -p /dev/mapper/dshelf2  
> enabling repair mode  
> WARNING: low-memory mode repair support is only partial  
> Checking filesystem on /dev/mapper/dshelf2  
> UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d  
> Fixed 0 roots.  

Am I right to interpret the messages below, and see that you have
extents that are referenced hundreds of times?

Is there heavy snapshotting or deduping going on in this filesystem? If
so, it's not surprising balance will get a hard time moving extents
around, since it has to update all of the metadata for each extent again
in hundreds of places.

Did you investigate what balance was doing if it takes long? Is is using
cpu all the time, or is it reading from disk slowly (random reads) or is
it writing to disk all the time at full speed?

K

> ERROR: extent[84302495744, 69632] referencer count mismatch (root: 21872, owner: 374857, offset: 3407872) wanted: 3, have: 4
> Created new chunk [18457780224000 1073741824]
> Delete backref in extent [84302495744 69632]
> ERROR: extent[84302495744, 69632] referencer count mismatch (root: 22911, owner: 374857, offset: 3407872) wanted: 3, have: 4
> Delete backref in extent [84302495744 69632]
> ERROR: extent[125712527360, 12214272] referencer count mismatch (root: 21872, owner: 374857, offset: 114540544) wanted: 181, have: 240
> Delete backref in extent [125712527360 12214272]
> ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 21872, owner: 374857, offset: 126754816) wanted: 68, have: 115
> Delete backref in extent [125730848768 5111808]
> ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 22911, owner: 374857, offset: 126754816) wanted: 68, have: 115
> Delete backref in extent [125730848768 5111808]
> ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 21872, owner: 374857, offset: 131866624) wanted: 115, have: 143
> Delete backref in extent [125736914944 6037504]
> ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 22911, owner: 374857, offset: 131866624) wanted: 115, have: 143
> Delete backref in extent [125736914944 6037504]
> ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 21872, owner: 374857, offset: 148234240) wanted: 302, have: 431
> Delete backref in extent [129952120832 20242432]
> ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 22911, owner: 374857, offset: 148234240) wanted: 356, have: 433
> Delete backref in extent [129952120832 20242432]
> ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 21872, owner: 374857, offset: 180371456) wanted: 161, have: 240
> Delete backref in extent [134925357056 11829248]
> ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 22911, owner: 374857, offset: 180371456) wanted: 162, have: 240
> Delete backref in extent [134925357056 11829248]
> ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 21872, owner: 374857, offset: 192200704) wanted: 170, have: 249
> Delete backref in extent [147895111680 12345344]
> ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 22911, owner: 374857, offset: 192200704) wanted: 172, have: 251
> Delete backref in extent [147895111680 12345344]
> ERROR: extent[150850146304, 17522688] referencer count mismatch (root: 21872, owner: 374857, offset: 217653248) wanted: 348, have: 418
> Delete backref in extent [150850146304 17522688]
> ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 22911, owner: 374857, offset: 235175936) wanted: 555, have: 1449
> Deleted root 2 item[156909494272, 178, 5476627808561673095]
> ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 21872, owner: 374857, offset: 235175936) wanted: 556, have: 1452
> Deleted root 2 item[156909494272, 178, 7338474132555182983]
> 
> At the rate it's going, it'll probably take days though, it's already been 36H

-- 
Hans van Kranenburg
