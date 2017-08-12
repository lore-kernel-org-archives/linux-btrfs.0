Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:37904 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752023AbdHLXOJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 19:14:09 -0400
Received: by mail-vk0-f67.google.com with SMTP id i133so2996213vka.5
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Aug 2017 16:14:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170812224954.GA7140@carfax.org.uk>
References: <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
 <22169.183.88.87.49.1502260598.squirrel@mail> <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
 <27218.183.88.87.49.1502426431.squirrel@mail> <13031.192.168.42.222.1502431206.squirrel@mail>
 <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
 <1243.49.228.123.163.1502505534.squirrel@mail> <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
 <1420.49.228.123.163.1502514511.squirrel@mail> <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
 <20170812224954.GA7140@carfax.org.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 12 Aug 2017 17:14:07 -0600
Message-ID: <CAJCQCtS0_zQJQ7VcRzpaq8C6NfMsPfXxd6qNG+b7C3t1FbxbJg@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        siranee.ja@tpc.co.th, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        voravat@tpcorp.co.th
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 12, 2017 at 4:49 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sat, Aug 12, 2017 at 03:34:01PM -0600, Chris Murphy wrote:
>> On Fri, Aug 11, 2017 at 11:08 PM,  <siranee.ja@tpc.co.th> wrote:
>>
>>
>> > The backup script has the btrfs sync command since Aug 3
>>
>>
>> From your script:
>> > system btrfs sub snap -r $basepath $snappath
>> > system btrfs sub sync $basepath
>>
>> From the man page: sync <path> [subvolid...]
>>            Wait until given subvolume(s) are completely removed from the
>>            filesystem after deletion.
>>
>>
>> This 'subvolume sync' command, per the man page, is only about
>> subvolume deletion. I suggest replacing it with a regular sync
>> command.
>>
>> I think the problem is that the script does things so fast that the
>> snapshot is not always consistent on disk before btrfs send starts.
>> It's just a guess though. If I'm right, this means the rsync mismaches
>> mean the destination snapshots are bad. Here's what I would do:
>
>    I don't see how that can happen. Snapshots are atomic -- they're
> either there or not there. It's not a matter even of copying the
> metadata part of the subvol. It's literally just adding a pointer to
> point at an existing FS tree.

Do snapshots come with sync and flush to disk? Or does it just set a
checkpoint and the extents that are as yet uncommitted prior to the
snapshot aren't for sure on disk yet until the next commit time or
sync?

Nevertheless the wiki explicitly says to do sync after taking a
snapshot in the context of send/receive.
https://btrfs.wiki.kernel.org/index.php/Incremental_Backup#Initial_Bootstrapping

And people on the list have had this "stale NFS file handle" error .

I have no idea if it's still a problem with current kernels, or if it
applies to 4.4 kernel.

Anyway, the OP does appear to be having a real problem. rync is very
clearly showing a given snapshot with incremental send/receive differ
by *a lot* on source and destination machines.



-- 
Chris Murphy
