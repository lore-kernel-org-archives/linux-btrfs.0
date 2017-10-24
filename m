Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:50695 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdJXOFL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 10:05:11 -0400
Received: by mail-it0-f49.google.com with SMTP id 72so10124581itl.5
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 07:05:11 -0700 (PDT)
Subject: Re: SLES 11 SP4: can't mount btrfs
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>,
        Btrfs ML <linux-btrfs@vger.kernel.org>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de>
 <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com>
 <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com>
 <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de>
 <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de>
 <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net>
 <32022214.8113126.1508586366285.JavaMail.zimbra@helmholtz-muenchen.de>
 <20171021180752.iqkspyi2whnm4vui@angband.pl>
 <5b68b633-6069-067d-5b9b-81074807ab06@gmail.com>
 <006b01d34ccb$ee56bbd0$cb043370$@helmholtz-muenchen.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a4c7ccd2-c9ab-8a20-4156-f0f756aced81@gmail.com>
Date: Tue, 24 Oct 2017 10:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <006b01d34ccb$ee56bbd0$cb043370$@helmholtz-muenchen.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-24 09:28, Lentes, Bernd wrote:
> 
>> -----Original Message-----
>> From: Austin S. Hemmelgarn [mailto:ahferroin7@gmail.com]
>> Sent: Tuesday, October 24, 2017 1:53 PM
>> To: Adam Borowski <kilobyte@angband.pl>; Lentes, Bernd
>> <bernd.lentes@helmholtz-muenchen.de>
>> Cc: Btrfs ML <linux-btrfs@vger.kernel.org>
>> Subject: Re: SLES 11 SP4: can't mount btrfs
>>
>> I think partimage _might_ have BTRFS support by now, and if so, that's
>> likely to be the best you can get for quite some time.
> 
> Unfortunately not: http://www.partimage.org/Supported-Filesystems/
> 
>>> It depends on what you use subvolumes for.
>> And this is the important part.  If you're just using them to segregate
>> workloads (like I do), or exclude things from snapshots (like I used to do
>> when I was using snapshots for backups), then any old backup program is
>> fine as long as you know enough to replicate the subvolume layout when
>> extracting (if you need the same layout that is).  I'm actually working on
>> a
>> script to automate this for file-level backups (stuff like Amanda, Bareos,
>> and borgbackup), but I don't have anything ready to share yet.>
> 
> There seems to be no backup solution which supports BTRFS in a way that I
> can just restore the complete partition with all subvolumes, snapshots ?
> That's bad. A fs can also get corrupt in certain circumstances.
> I'd like to have a solution which offers me the possibility to restore a
> root partition in a reasonable time (some hours maximum), completely. Not
> doing many stuff before/afterwards. It seems that's not possible withBTRFS.
A short-term alternative, if you've got a full backup of what SLES 
mounts as /, is to run a regular install, boot the system, and then 
extract the backup on top of /.  It's not perfect, but it should work 
well enough.

As mentioned, I'm working on a script to handle this for tools like 
Amanda and Bareos.  I plan to send a message out on the list when that's 
sufficiently working that I think it's safely usable, I can make sure 
you're on CC for that message as well if you like.  I hoped to have 
something later this week, but things are busier than expected at work 
this week, so it might be a while.
> 
> And Btrfs check is still limited in what it can do.
