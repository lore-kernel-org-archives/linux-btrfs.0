Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36377 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbcIBG7S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Sep 2016 02:59:18 -0400
Received: by mail-wm0-f66.google.com with SMTP id i138so1568457wmf.3
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 23:59:17 -0700 (PDT)
From: Wilson Meier <wilson.meier@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: Warn user for minimal RAID5/6 devices setup
Message-Id: <EDFCF30E-2866-4F83-B256-EA4EAFA3C007@googlemail.com>
Date: Fri, 2 Sep 2016 08:59:14 +0200
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Steven Haigh <netwiz@crc.id.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

+1 for the note/warning!



> Am 02.09.2016 um 03:59 schrieb Steven Haigh <netwiz@crc.id.au>:
> 
> --7NtBNafxaf8ODulNFrivgmW7Mjs09oWwR
> Content-Type: text/plain; charset=windows-1252
> Content-Transfer-Encoding: quoted-printable
> 
> Is it worthwhile adding a note that RAID5 / RAID6 may very well eat your
> data at this stage?
> 
>> On 02/09/16 11:41, Qu Wenruo wrote:
>> For RAID5, 2 devices setup is just RAID1 with more overhead.
>> For RAID6, 3 devices setup is RAID1 with 3 copies, not what most user
>> want.
>> =20
>> So warn user at mkfs time for such case, and add explain in man pages.
>> =20
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> Documentation/mkfs.btrfs.asciidoc | 15 +++++++++++-
