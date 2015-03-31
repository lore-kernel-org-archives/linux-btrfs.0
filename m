Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34560 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbCaXyk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 19:54:40 -0400
Received: by wgbdm7 with SMTP id dm7so36067373wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 16:54:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
 <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
From: Martin Langhoff <martin.langhoff@gmail.com>
Date: Tue, 31 Mar 2015 19:54:18 -0400
Message-ID: <CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 4:09 PM, Chris Murphy <lists@colorremedies.com> wrote:
> There should be a reference to an rdsosreport.txt in /run/... so find
> a way to get that posted somewhere.

I'll try, but it truly says nothing of interest from a block device /
btrfs PoV. I have ample background debugging boot issues, disk
corruption, etc from years of work w OLPC.

>>  - kernel is 3.1.9-200.fc21
>
> This is probably 3.18.9, which is the current F21 kernel.

Correct, thanks. I typo'd that.

>>A failure of the
>> HDD cannot be ruled out, low power conditions, cheap consumer part...
>
> Well you have to rule that out before anyone on this list can really
> help. Try booting Fedora 21 install media, and using smartctl -x on
> the drive.

That's a good idea! I was referring to something else -- I guess what
I'm trying to say is: I'm not sure if this scrambled disk partition is
a btrfs/kernel bug, or the cheap HDD lied about flushing a write to
disk.

cheers,


m
-- 
 martin.langhoff@gmail.com
 -  ask interesting questions
 - don't get distracted with shiny stuff  - working code first
 ~ http://docs.moodle.org/en/User:Martin_Langhoff
