Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:43133 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbdKUSdl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 13:33:41 -0500
Received: by mail-ot0-f179.google.com with SMTP id 105so11362398oth.10
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 10:33:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1511278140.1680.41.camel@gmail.com>
References: <1511266131.1680.27.camel@gmail.com> <093ee7e4-91f1-7d23-1ef1-81230d07b405@gmx.com>
 <1511270292.1680.35.camel@gmail.com> <09f4e574-8cab-26fd-d7ea-64a0cee2b20b@gmx.com>
 <1511278140.1680.41.camel@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 21 Nov 2017 11:33:39 -0700
Message-ID: <CAJCQCtRCPfcSNQseoRdB1pq+DkF7pr6nt4syyYy1VWXYwy2R6g@mail.gmail.com>
Subject: Re: quotas: failure on removing a file via SFTP/SSH
To: ST <smntov@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 21, 2017 at 8:29 AM, ST <smntov@gmail.com> wrote:
>> >>> I'm trying to use quotas for a simple chrooted sftp setup, limiting
>> >>> space for each user's subvolume (now for testing to 1M).
>> >>>
>> >>> I tried to hit the limit by uploading files and once it comes to the
>> >>> limit I face following problem: if I try to free space by removing a
>> >>> file via Linux sftp client (or Filezilla) - I get error:
>> >>> "Couldn't delete file: Failure"
>> >>>
>> >>> Sometimes, but not always, if I repeat it for 3-5 times it does removes
>> >>> the file at the end.
>> >>> If I login as root and try to remove the file via SSH I get the error:
>> >>> "rm: cannot remove 'example.txt': Disk quota exceeded"
>> >>>
>> >>> What is the problem? And how can I solve it?
>> >>
>> >> Kernel version first.
>> >>
>> >> If it's possible, please use latest kernel, at least newer than v4.10,
>> >> since we have a lot of qgroup reservation related fixes in newer kernel.
>> >>
>> >> Then, for small quota, due to the nature of btrfs metadata CoW and
>> >> relative large default node size (16K), it's quite easy to hit disk
>> >> quota for metadata.
>> >
>> > Yes, but why I get the error specifically on REMOVING a file? Even if I
>> > hit disk quota - if I free up space - it should be possible, isn't it?
>>
>> It's only true for fs modifying its metadata in-place (and use journal
>> to protect it).
>>
>> For fs using metadata CoW, even freeing space needs extra space for new
>> metadata.
>>
>
> Wait, it doesn't sound like a bug, but rather like a flaw in design.
> This means - each time a user hits his quota limit he will get stuck
> without being able to free space?!!

It's a good question if quotas can make it possible for a user to get
wedged into a situation that will require an admin to temporarily
raise the quota in order to make file deletion possible. This is not a
design flaw, all COW file systems *add* data when deleting. The
challenge is how to teach the quota system to act like a hard limit
for data writes that clearly bust the quota, versus a soft limit that
tolerates some extra amount above the quota for the purpose of
eventually deleting data. That's maybe non-trivial. It's not that it's
a design flaw. Metadata can contain inline data, so how exactly to you
tell what kinds of writes are permitted (deleting a file) and what
kind of writes are not (append data to a file, or create new file)?

But for sure the user space tools should prevent setting too low a
quota limit. If the limit cannot be reasonably expected to work, it
should be disallowed. So maybe the user space tools need to enforce a
minimum quota, something like 100MiB, or whatever.



-- 
Chris Murphy
