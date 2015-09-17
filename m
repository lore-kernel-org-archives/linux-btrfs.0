Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:33917 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbbIQUSd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 16:18:33 -0400
Received: by vkhf67 with SMTP id f67so18120157vkh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 13:18:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150918000205.6e8f3998@natsu>
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
	<55FAD9CC.5060206@oracle.com>
	<55FAF198.2060106@libero.it>
	<20150918000205.6e8f3998@natsu>
Date: Thu, 17 Sep 2015 14:18:32 -0600
Message-ID: <CAJCQCtQ10SJAPca8quhdi-oK1rJV2rcfY0QZFqx11u9ntyDRYA@mail.gmail.com>
Subject: Re: RAID1 storage server won't boot with one disk missing
From: Chris Murphy <lists@colorremedies.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 17, 2015 at 1:02 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Thu, 17 Sep 2015 19:00:08 +0200
> Goffredo Baroncelli <kreijack@libero.it> wrote:
>
>> On 2015-09-17 17:18, Anand Jain wrote:
>> >  it looks like -o degraded is going to be a very obvious feature,
>> >  I have plans of making it a default feature, and provide -o
>> >  nodegraded feature instead. Thanks for comments if any.
>> >
>> I am not sure if there is a "good" default for this kind of problem
>
> Yes there is. It is whatever people came to expect from using other RAID
> systems and/or generally expect from RAID as a concept.
>
> Both mdadm software RAID, and I believe virtually any hardware RAID controller
> out there will let you to successfully boot up and give read-write(!) access
> to a RAID in a non-critical failure state, because that's kind of the whole
> point of a RAID, to eliminate downtime. If the removed disk is later re-added,
> then it is automatically resynced. Mdadm can also make use of its 'write
> intent bitmap' to resync only those areas of the array which were in any way
> touched during the absence of the newly re-added disk.
>
> If you're concerned that the user "misses" the fact that they have a disk
> down, then solve *that*, make some sort of a notify daemon, e.g. mdadm has a
> built-in "monitor" mode which sends E-Mail on critical events with any of the
> arrays.

Given the current state: no proposal and no work done yet, I think
it's premature to change the default.

It's an open question what a modern monitoring and notification
mechanism should look like. At the moment it'd be a unique Btrfs thing
because the mdadm and LVM methods aren't abstracted enough to reuse. I
wonder if the storaged and/or openlmi folks have some input on what
this would look like. Feedback from KDE and GNOME also, who rely on at
least mdadm in order to present user space notifications. I think
udisks2 is on the way out and storaged is on the way in, there's just
too much stuff that udisks2 doesn't do and is getting confused about,
including LVM thinly provisioned volumes, not just Btrfs stuff.


-- 
Chris Murphy
