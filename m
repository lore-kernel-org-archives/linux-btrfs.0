Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34130 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbcHKFGt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 01:06:49 -0400
Received: by mail-oi0-f42.google.com with SMTP id l203so87364133oib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Aug 2016 22:06:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$631e4$8ace778e$d2bf1967$d5b4e8cc@cox.net>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <pan$d9b53$c31dc60$985cf806$b833643c@cox.net> <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
 <CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com> <pan$631e4$8ace778e$d2bf1967$d5b4e8cc@cox.net>
From: Gareth Pye <gareth@cerberos.id.au>
Date: Thu, 11 Aug 2016 15:06:48 +1000
Message-ID: <CA+WRLO8MoW9kEy50u_QMvoB2Lejcjp49BjHqEjtWjZZOPtfetg@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is there some simple muddling of meta data that could be done to force
dup meta data on deduping SSDs? Like a simple 'random' byte repeated
often enough it would defeat any sane dedup? I know it would waste
data but clearly that is considered worth it with dup metadata (what
is the difference between 50% metadata efficiency and 45%?)

On Thu, Aug 11, 2016 at 2:50 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Dave T posted on Wed, 10 Aug 2016 18:01:44 -0400 as excerpted:
>
>> Does anyone have any thoughts about using dup mode for metadata on a
>> Samsung 950 Pro (or any NVMe drive)?
>
> The biggest problem with dup on ssds is that some ssds (particularly the
> ones with the sandforce controllers) do dedup, so you'd be having btrfs
> do dup while the filesystem dedups, to no effect except more cpu and
> device processing!
>
> (The other argument for single on ssd that I've seen is that because the
> FTL ultimately places the data, and because both copies are written at
> the same time, there's a good chance that the FTL will write them into
> the same erase block and area, and a defect in one will likely be a
> defect in the other as well.  That may or may not be, I'm not qualified
> to say, but as explained below, I do choose to take my chances on that
> and thus do run dup on ssd.)
>
> So as long as the SSD doesn't have a deduping FTL, I'd suggest dup for
> metadata on ssd does make sense.  Data... not so sure on, but certainly
> metadata, because one bad block of metadata can be many messed up files.
>
> On my ssds here, which I know don't do dedup, most of my btrfs are raid1
> on the pair of ssds.  However, /boot is different since I can't really
> point grub at two different /boots, so I have my working /boot on one
> device, with the backup /boot on the other, and the grub on each one
> pointed at its respective /boot, so I can select working or backup /boot
> from the BIOS and it'll just work.  Since /boot is so small, it's mixed-
> mode chunks, meaning data and metadata are mixed together and the
> redundancy mode applies to both at once instead of each separately.  And
> I chose dup, so it's dup for both data and metadata.
>
> Works fine, dup for both data and metadata on non-deduping ssds, but of
> course that means data takes double the space since there's two copies of
> it, and that gets kind of expensive on ssd, if it's more than the
> fraction of a GiB that's /boot.
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
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
