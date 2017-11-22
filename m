Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:44390 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751857AbdKVIcz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 03:32:55 -0500
Received: by mail-wm0-f54.google.com with SMTP id r68so8534728wmr.3
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 00:32:55 -0800 (PST)
Message-ID: <1511339571.1675.17.camel@gmail.com>
Subject: Re: quotas: failure on removing a file via SFTP/SSH
From: ST <smntov@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Wed, 22 Nov 2017 10:32:51 +0200
In-Reply-To: <28236dae-8190-9b74-521d-661942b52df4@gmx.com>
References: <1511266131.1680.27.camel@gmail.com>
         <093ee7e4-91f1-7d23-1ef1-81230d07b405@gmx.com>
         <1511270292.1680.35.camel@gmail.com>
         <09f4e574-8cab-26fd-d7ea-64a0cee2b20b@gmx.com>
         <1511278140.1680.41.camel@gmail.com>
         <CAJCQCtRCPfcSNQseoRdB1pq+DkF7pr6nt4syyYy1VWXYwy2R6g@mail.gmail.com>
         <1511298021.1675.14.camel@gmail.com>
         <28236dae-8190-9b74-521d-661942b52df4@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On Wed, 2017-11-22 at 08:39 +0800, Qu Wenruo wrote:
> 
> On 2017年11月22日 05:00, ST wrote:
> > On Tue, 2017-11-21 at 11:33 -0700, Chris Murphy wrote:
> >> On Tue, Nov 21, 2017 at 8:29 AM, ST <smntov@gmail.com> wrote:
> >>>>>>> I'm trying to use quotas for a simple chrooted sftp setup, limiting
> >>>>>>> space for each user's subvolume (now for testing to 1M).
> >>>>>>>
> >>>>>>> I tried to hit the limit by uploading files and once it comes to the
> >>>>>>> limit I face following problem: if I try to free space by removing a
> >>>>>>> file via Linux sftp client (or Filezilla) - I get error:
> >>>>>>> "Couldn't delete file: Failure"
> >>>>>>>
> >>>>>>> Sometimes, but not always, if I repeat it for 3-5 times it does removes
> >>>>>>> the file at the end.
> >>>>>>> If I login as root and try to remove the file via SSH I get the error:
> >>>>>>> "rm: cannot remove 'example.txt': Disk quota exceeded"
> >>>>>>>
> >>>>>>> What is the problem? And how can I solve it?
> >>>>>>
> >>>>>> Kernel version first.
> >>>>>>
> >>>>>> If it's possible, please use latest kernel, at least newer than v4.10,
> >>>>>> since we have a lot of qgroup reservation related fixes in newer kernel.
> >>>>>>
> >>>>>> Then, for small quota, due to the nature of btrfs metadata CoW and
> >>>>>> relative large default node size (16K), it's quite easy to hit disk
> >>>>>> quota for metadata.
> >>>>>
> >>>>> Yes, but why I get the error specifically on REMOVING a file? Even if I
> >>>>> hit disk quota - if I free up space - it should be possible, isn't it?
> >>>>
> >>>> It's only true for fs modifying its metadata in-place (and use journal
> >>>> to protect it).
> >>>>
> >>>> For fs using metadata CoW, even freeing space needs extra space for new
> >>>> metadata.
> >>>>
> >>>
> >>> Wait, it doesn't sound like a bug, but rather like a flaw in design.
> >>> This means - each time a user hits his quota limit he will get stuck
> >>> without being able to free space?!!
> >>
> >> It's a good question if quotas can make it possible for a user to get
> >> wedged into a situation that will require an admin to temporarily
> >> raise the quota in order to make file deletion possible.
> > 
> > Why question? It's a fact. That's what I face right now.
> > 
> >>  This is not a
> >> design flaw, all COW file systems *add* data when deleting. The
> >> challenge is how to teach the quota system to act like a hard limit
> >> for data writes that clearly bust the quota, versus a soft limit that
> >> tolerates some extra amount above the quota for the purpose of
> >> eventually deleting data. That's maybe non-trivial. It's not that it's
> >> a design flaw. Metadata can contain inline data, so how exactly to you
> >> tell what kinds of writes are permitted (deleting a file) and what
> >> kind of writes are not (append data to a file, or create new file)?
> >>
> >> But for sure the user space tools should prevent setting too low a
> >> quota limit. If the limit cannot be reasonably expected to work, it
> >> should be disallowed. So maybe the user space tools need to enforce a
> >> minimum quota, something like 100MiB, or whatever.
> >>
> > 
> > Would you like to open an issue with your enhancement suggestions on the
> > bug tracker so this case doesn't get forgotten?
> 
> That's why I ask for the kernel version.
> 
> IIRC in newer kernel, quota doesn't limit deletion anymore, preventing
> you from hitting such dilemma.

I'm sorry. I've mentioned it in another mail in this thread, here it is:

I am on Debian 9 (stable), so kernel version is:
uname -r
4.9.0-4-amd64
btrfs-tools (4.7.3-1)

I hope kernel 4.13 will move from Debian stable-backports to stable in
some not so distant future. Is this issue already resolved in 4.13?

Thank you!

