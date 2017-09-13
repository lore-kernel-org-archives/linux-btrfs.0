Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:46457 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbdIMMVI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 08:21:08 -0400
Received: by mail-it0-f53.google.com with SMTP id 6so1697097itl.1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 05:21:07 -0700 (PDT)
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: Marat Khalili <mkh@rqc.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru>
 <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
 <20170912111159.jcwej7s6uluz4dsz@angband.pl>
 <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
 <20170912172125.rb6gtqdxqneb36js@angband.pl>
 <d1f6450c-fc09-171c-82c8-32caa2cbd230@gmail.com>
 <20170912184359.hovirdaj55isvwwg@angband.pl>
 <7019ace9-723e-0220-6136-473ac3574b55@gmail.com>
 <20170912200057.3mrgtahlvszkg334@angband.pl>
 <e169336d-db31-276f-1d71-bf897cf10d4b@gmail.com>
 <20170912211346.uxzqfu7uh2ikrg2m@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8d74d2c2-0f65-77c9-124c-4bcc071a2b2e@gmail.com>
Date: Wed, 13 Sep 2017 08:21:01 -0400
MIME-Version: 1.0
In-Reply-To: <20170912211346.uxzqfu7uh2ikrg2m@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-12 17:13, Adam Borowski wrote:
> On Tue, Sep 12, 2017 at 04:12:32PM -0400, Austin S. Hemmelgarn wrote:
>> On 2017-09-12 16:00, Adam Borowski wrote:
>>> Noted.  Both Marat's and my use cases, though, involve VMs that are off most
>>> of the time, and at least for me, turned on only to test something.
>>> Touching mtime makes rsync run again, and it's freaking _slow_: worse than
>>> 40 minutes for a 40GB VM (source:SSD target:deduped HDD).
>> 40 minutes for 40GB is insanely slow (that's just short of 18 MB/s) if
>> you're going direct to a hard drive.  I get better performance than that on
>> my somewhat pathetic NUC based storage cluster (I get roughly 20 MB/s there,
>> but it's for archival storage so I don't really care).  I'm actually curious
>> what the exact rsync command you are using is (you can obviously redact
>> paths as you see fit), as the only way I can think of that it should be that
>> slow is if you're using both --checksum (but if you're using this, you can
>> tell rsync to skip the mtime check, and that issue goes away) and --inplace,
>> _and_ your HDD is slow to begin with.
> 
> rsync -axX --delete --inplace --numeric-ids /mnt/btr1/qemu/ mordor:$BASE/qemu
> The target is single, compress=zlib SAMSUNG HD204UI, 34976 hours old but
> with nothing notable on SMART, in a Qnap 253a, kernel 4.9.
compress=zlib is probably your biggest culprit.  As odd as this sounds, 
I'd suggest switching that to lzo (seriously, the performance difference 
is ludicrous), and then setting up a cron job (or systemd timer) to run 
defrag over things to switch to zlib.  As a general point of comparison, 
we do archival backups to a file server running BTRFS where I work, and 
the archiving process runs about four to ten times faster if we take 
this approach (LZO for initial compression, then recompress using defrag 
once the initial transfer is done) than just using zlib directly.

`--inplace` is probably not helping (especially if most of the file 
changed, on BTRFS, it actually is marginally more efficient to just 
write out a whole new file and then replace the old one with a rename if 
you're rewriting most of the file), but is probably not as much of an 
issue as compress=zlib.
> 
> Both source and target are btrfs, but here switching to send|receive
> wouldn't give much as this particular guest is Win10 Insider Edition --
> a thingy that shows what the folks from Redmond have cooked up, with roughly
> weekly updates to the tune of ~10GB writes 10GB deletions (if they do
> incremental transfers, installation still rewrites everything system). >
> Lemme look a bit more, rsync performance is indeed really abysmal compared
> to what it should be.

