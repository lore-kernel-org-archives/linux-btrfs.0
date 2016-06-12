Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:35757 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882AbcFLXGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 19:06:52 -0400
Received: by mail-vk0-f50.google.com with SMTP id d127so158351596vkh.2
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 16:06:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20160612T172707-790@post.gmane.org>
References: <CAMPo9spCUSEwMBhGWcr1iX0ny28e52GYMO4D=eug-MZaWB0iEQ@mail.gmail.com>
 <pan$dc991$bc4b5712$73c16333$5c108126@cox.net> <CAMPo9srkVgJkBqmH6LoTuEyBj6yP-=HX6QR6HTFrfr+zQPyLvw@mail.gmail.com>
 <loom.20160612T172707-790@post.gmane.org>
From: =?UTF-8?B?QmVhcmNhdCDFnsOhbmRvcg==?= <bearcatsandor@gmail.com>
Date: Sun, 12 Jun 2016 17:06:11 -0600
Message-ID: <CAMPo9sr1v9DsaMNPDocdSASq1gp9hkbAiodJFSzDrgs4U5YdwQ@mail.gmail.com>
Subject: Re: Files seen by some apps and not others
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't think it's memory corruption as my modules test out fine, and
the problem began when i ran the btrfs check
--repair. Someone responded that they thought that the missing files
that are playable by the media player were still in memory, but they
still play after a reboot and they're not in a tmp structure anywhere.

So could it be that the metadata is not aligned with the nodes on the
disc? If so, what should i run next to address this? A balance? A
find-root with restore -t?

Would a 'btrfs rescue chunk-recover' help at this point or damage
things further?

Thanks all.


On Sun, Jun 12, 2016 at 9:47 AM, Henk Slager <eye1tm@gmail.com> wrote:
> Bearcat Şándor <bearcatsandor <at> gmail.com> writes:
>
>> Is there a fix for the bad tree block error, which seems to be the
>> root (pun intended) of all this?
>
> I think the root cause is some memory corruption. It might be known case,
> maybe someone else recognizes something.
>
> Anyhow, if you can't and won't reproduce it, best is to test
> memory/hardware, check any software that might have overwritten something in
> memory, use a recent (mainline/stable) kernel and see if it runs stable.



-- 
Bearcat M. Şándor
Feline Soul Systems LLC
Voice: 872.CAT.SOUL (872.228.7685)
Fax: 406.235.7070
