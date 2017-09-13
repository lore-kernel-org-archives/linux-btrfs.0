Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:44902 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751305AbdIMPZk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 11:25:40 -0400
Received: by mail-io0-f182.google.com with SMTP id v36so2893601ioi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 08:25:40 -0700 (PDT)
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Martin Raiber <martin@urbackup.org>, Adam Borowski <kilobyte@angband.pl>
Cc: Marat Khalili <mkh@rqc.ru>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
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
 <0102015e7bb52b17-75904b91-b3e4-42bc-b726-5d4e21f35bbf-000000@eu-west-1.amazonses.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6dba5a44-07b7-aa80-f0e6-4a6bf7a007b9@gmail.com>
Date: Wed, 13 Sep 2017 11:25:33 -0400
MIME-Version: 1.0
In-Reply-To: <0102015e7bb52b17-75904b91-b3e4-42bc-b726-5d4e21f35bbf-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-13 10:47, Martin Raiber wrote:
> Hi,
> 
> On 12.09.2017 23:13 Adam Borowski wrote:
>> On Tue, Sep 12, 2017 at 04:12:32PM -0400, Austin S. Hemmelgarn wrote:
>>> On 2017-09-12 16:00, Adam Borowski wrote:
>>>> Noted.  Both Marat's and my use cases, though, involve VMs that are off most
>>>> of the time, and at least for me, turned on only to test something.
>>>> Touching mtime makes rsync run again, and it's freaking _slow_: worse than
>>>> 40 minutes for a 40GB VM (source:SSD target:deduped HDD).
>>> 40 minutes for 40GB is insanely slow (that's just short of 18 MB/s) if
>>> you're going direct to a hard drive.  I get better performance than that on
>>> my somewhat pathetic NUC based storage cluster (I get roughly 20 MB/s there,
>>> but it's for archival storage so I don't really care).  I'm actually curious
>>> what the exact rsync command you are using is (you can obviously redact
>>> paths as you see fit), as the only way I can think of that it should be that
>>> slow is if you're using both --checksum (but if you're using this, you can
>>> tell rsync to skip the mtime check, and that issue goes away) and --inplace,
>>> _and_ your HDD is slow to begin with.
>> rsync -axX --delete --inplace --numeric-ids /mnt/btr1/qemu/ mordor:$BASE/qemu
>> The target is single, compress=zlib SAMSUNG HD204UI, 34976 hours old but
>> with nothing notable on SMART, in a Qnap 253a, kernel 4.9.
>>
>> Both source and target are btrfs, but here switching to send|receive
>> wouldn't give much as this particular guest is Win10 Insider Edition --
>> a thingy that shows what the folks from Redmond have cooked up, with roughly
>> weekly updates to the tune of ~10GB writes 10GB deletions (if they do
>> incremental transfers, installation still rewrites everything system).
>>
>> Lemme look a bit more, rsync performance is indeed really abysmal compared
>> to what it should be.
> 
> self promo, but consider using UrBackup (OSS software, too) instead? For
> Windows VMs I would install the client in the VM. It excludes unnessary
> stuff like e.g. page files or the shadow storage area from the image
> backups, as well and has a mode to store image backups as raw btrfs files.
> Linux VMs I'd backup as files either from the hypervisor or from in VM.
> If you want to backup big btrfs image files it can do that too, and
> faster than rsync plus it can do incremental backups with sparse files.
Even without UrBackup (I'll need to look into that actually, we're 
looking for new backup software where I work since MS has been debating 
removing File History, and the custom scripts my predecessor wrote are 
showing their 20+ year age at this point), it's usually better to just 
run the backup from inside the VM if at all possible.  You end up saving 
space, and don't waste time backing up stuff you don't need.

In this particular use case, it would also save other system resources, 
since you only need to back up the VM if something has changed, and by 
definition nothing could have changed in the VM (at least, nothing could 
have legitimately changed) if it's not running.
