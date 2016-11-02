Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:34718 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752440AbcKBL5H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 07:57:07 -0400
Received: by mail-it0-f42.google.com with SMTP id f129so17084012itc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Nov 2016 04:57:07 -0700 (PDT)
Subject: Re: Snapper & apt-btrfs-snapshot on Ubuntu
To: badara+ml@gmail.com, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAN5=xXnZmaqApRds3w=AKLAvfk=+dEPNazEb+Tzym_=2OdnfzA@mail.gmail.com>
 <pan$af500$48f5b197$b20e4aa3$ec6e2ea2@cox.net>
 <CAKGv6CrpnfHhC8=tCcrH1+c+a0vLcLwz96gqoNCAxF6TxYD75g@mail.gmail.com>
 <CAN5=xXmCG0Gan5cwMtTugwvo2=orN9J8HWmJOj7k7x8PcKWwjA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6fce2f65-30e2-7685-5f91-3eb6c0c11470@gmail.com>
Date: Wed, 2 Nov 2016 07:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAN5=xXmCG0Gan5cwMtTugwvo2=orN9J8HWmJOj7k7x8PcKWwjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-02 07:18, Ahmed Badr wrote:
> On Wed, Nov 2, 2016 at 8:31 AM, Alex Powell
> <alexj.powellalt@googlemail.com> wrote:
>> Taking a step back as well- there is also the possibility that you
>> might not need snapshots
>
> I do need it for my root partition at least in the initial phase of
> setting things up and trying out different software. Once the system
> is stable, I might might not need it that much.
So, it's worth mentioning that there are about 4 practical uses for 
snapshots:
1. File versioning/history.  Essentially, usage like Windows File 
History (which uses snapshots and COW on NTFS) or Apples Time Machine. 
This is generally useful to a traditional home user, but in many cases, 
if you actually _need_ file versioning, your better off using a VCS like 
Git or Mercurial.
2. Atomic installs and updates.  This is essentially what 
apt-btrfs-snapshot and the snapper integration in Zypper do, and there 
are other cases of software that do this.  This is generally the most 
useful to traditional end-users.
3. On-system point-in-time copies of specific things.  This is one of 
the things that LVM snapshots are traditionally used for, and isn't 
often useful to end users, but can be for some middle-ware.  In essence, 
this is the same as 2, just for things other than software.
4. Getting a stable view of a live filesystem.  This is important for 
backup software and similar tools.  In essence, by taking a snapshot of 
the filesystem to be backed up, you can guarantee that nothing will 
change as your archiving it.  I don't know of any backup software that 
does this, but the custom backup scripts I use for my personal systems 
do, and we're looking at setting up our custom backup system where I 
work to do so also.

2, 3, and 4 are generally always useful.  For 2, you just need 
apt-btrfs-snapshot.  For 3 just manually creating snapshots is perfectly 
fine, and for 4 manual creation or automatic through your regular backup 
software works.  If you don't need them for the first use, I'd suggest 
just uninstalling snapper, as that's about all it's used for on Ubuntu.
