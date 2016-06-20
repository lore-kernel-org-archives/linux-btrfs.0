Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36680 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbcFTTfd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 15:35:33 -0400
Received: by mail-ob0-f178.google.com with SMTP id mu6so994769obc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 12:35:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160620191112.GL15597@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
	<20160620231351.1833a341@natsu>
	<20160620191112.GL15597@hungrycats.org>
Date: Mon, 20 Jun 2016 13:30:11 -0600
Message-ID: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
From: Chris Murphy <lists@colorremedies.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2016 at 1:11 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> On Mon, Jun 20, 2016 at 11:13:51PM +0500, Roman Mamedov wrote:
>> On Sun, 19 Jun 2016 23:44:27 -0400
>> Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:
>> From a practical standpoint, [aside from not using Btrfs RAID5], you'd be
>> better off shutting down the system, booting a rescue OS, copying the content
>> of the failing disk to the replacement one using 'ddrescue', then removing the
>> bad disk, and after boot up your main system wouldn't notice anything has ever
>> happened, aside from a few recoverable CRC errors in the "holes" on the areas
>> which ddrescue failed to copy.
>
> I'm aware of ddrescue and myrescue, but in this case the disk has failed,
> past tense.  At this point the remaining choices are to make btrfs native
> raid5 recovery work, or to restore from backups.

Seems difficult at best due to this:
>>The normal 'device delete' operation got about 25% of the way in,
then got stuck on some corrupted sectors and aborting with EIO.

In effect it's like a 2 disk failure for a raid5 (or it's
intermittently a 2 disk failure but always at least a 1 disk failure).
That's not something md raid recovers from. Even manual recovery in
such a case is far from certain.

Perhaps Roman's advice is also a question about the cause of this
corruption? I'm wondering this myself. That's the real problem here as
I see it. Losing a drive is ordinary. Additional corruptions happening
afterward is not. And are those corrupt sectors hardware corruptions,
or Btrfs corruptions at the time the data was written to disk, or
Btrfs being confused as it's reading the data from disk?

For me the critical question is what does "some corrupted sectors" mean?


-- 
Chris Murphy
