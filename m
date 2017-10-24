Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:53018 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751354AbdJXOU0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 10:20:26 -0400
Received: by mail-io0-f193.google.com with SMTP id f20so24026110ioj.9
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 07:20:26 -0700 (PDT)
Subject: Re: SLES 11 SP4: can't mount btrfs
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Adam Borowski <kilobyte@angband.pl>,
        "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>,
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
 <CAA91j0UBDVASmicBKjoVrZ9md-+2G_JPNqxqDWpwVUCYhG0bow@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7c8034fb-ef03-5185-eeb4-79008313d211@gmail.com>
Date: Tue, 24 Oct 2017 10:20:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAA91j0UBDVASmicBKjoVrZ9md-+2G_JPNqxqDWpwVUCYhG0bow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-24 10:12, Andrei Borzenkov wrote:
> On Tue, Oct 24, 2017 at 2:53 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>>
>> SLES (and OpenSUSE in general) does do something special though, they use
>> subvolumes and qgroups to replicate multiple independent partitions (which
>> is a serious pain in the arse), and they have snapshotting with snapper by
>> default as well.  On OpenSUSE at least you can dispense with all that crap
>> by telling the installer to not enable snapshot support, not sure about SLES
>> though.
> 
> SUSE is using so many subvolumes because
> a) it wants to use snapshot of operating system to enable rollback
> b) data that needs to be part of snapshot includes RPM database
> c) RPM database is located on /var
> 
> So they were forced to make /var part of root subvolume and explicitly
> exclude everything below /var by making it separate subvolumes.
> 
> Fortunately it is going to change now with both RH and SUSE moving RPM
> database under /usr. Which leaves you basically with / and /var as
> default subvolumes.
> 
And /tmp, and /opt, and /usr/local, etc.  With /var as one subvolume, I 
still count at least 8.

That said, the issue I have with it is not as much the number, as the 
choice of layout (the whole /@ crap is ridiculous), and the fact that 
qgroups are enabled by default and not very well documented anywhere 
that I could find (seriously, this needs to be better documented, it 
took me an hour despite my background with BTRFS and as a system 
administrator to figure out why I couldn't fill the disk completely 
anywhere to wipe free space with zeroes so I could compact the disk 
image for the VM I was using).
