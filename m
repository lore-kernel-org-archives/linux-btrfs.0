Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:35846 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdDLESe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 00:18:34 -0400
Received: by mail-yw0-f172.google.com with SMTP id j9so7005507ywj.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 21:18:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170411210023.vfqck3h6nepdow3z@angband.pl>
References: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
 <20170411210023.vfqck3h6nepdow3z@angband.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 11 Apr 2017 22:18:33 -0600
Message-ID: <CAJCQCtTyNUx-P2aPNBE0x2W01qUfrBcHyA-46frM4X+suKMxrw@mail.gmail.com>
Subject: Re: Btrfs disk layout question
To: Adam Borowski <kilobyte@angband.pl>
Cc: Amin Hassani <ahassani@chromium.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 11, 2017 at 3:00 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Tue, Apr 11, 2017 at 12:15:32PM -0700, Amin Hassani wrote:
>> I am working on a project with Btrfs and I was wondering if there is
>> any way to see the disk layout of the btrfs image. Let's assume I have
>> a read-only btrfs image with compression on and only using one disk
>> (no raid or anything). Is it possible to get a set of offset-lengths
>> for each file
>
> While btrfs-specific ioctls give more information, you might want to look at
> FIEMAP (Documentation/filesystems/fiemap.txt) as it works on most
> filesystems, not just btrfs.  One interface to FIEMAP is provided in
> "/usr/sbin/filefrag -v".

Good idea. Although, on Btrfs I'm pretty sure it reports the Btrfs
(internal) logical addressing; not the actual physical sector address
on the drive. So it depends on what the original poster is trying to
discover.

-- 
Chris Murphy
