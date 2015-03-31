Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34942 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbbCaUJg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 16:09:36 -0400
Received: by igcau2 with SMTP id au2so29071811igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 13:09:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
Date: Tue, 31 Mar 2015 14:09:35 -0600
Message-ID: <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
To: Martin Langhoff <martin.langhoff@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 12:55 PM, Martin Langhoff
<martin.langhoff@gmail.com> wrote:
> Hi BTRFS folks,
>
> one of my dev boxes is a Thinkpad x220, with a single hybrid
> (HDD+Flash) disk, running F21 with BTRFS partitions for /home and / .
>
> After losing power (ran out of battery, possibly while trying to
> hibernate) -- the system will not boot. The initrd breaks out to a
> shell where I find that the partition holding / is failing to mount.

There should be a reference to an rdsosreport.txt in /run/... so find
a way to get that posted somewhere.

>  - kernel is 3.1.9-200.fc21

This is probably 3.18.9, which is the current F21 kernel.

>A failure of the
> HDD cannot be ruled out, low power conditions, cheap consumer part...

Well you have to rule that out before anyone on this list can really
help. Try booting Fedora 21 install media, and using smartctl -x on
the drive.


-- 
Chris Murphy
