Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34173 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbcA1X7e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 18:59:34 -0500
Received: by mail-ig0-f179.google.com with SMTP id ik10so25478877igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 15:59:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+-0u-bOPHs_cyci=_RXb3r=qVVe2jSh9sB1RE+tGbpaTY0ZfA@mail.gmail.com>
References: <CA+-0u-YhEBy7jDoJZeZG4hbkj+oxmTJOcxmnMCueEb6+XTZ2Sg@mail.gmail.com>
	<CAJCQCtSsqE5BLmHtjJb9dPbHkdem2XauFE-oe=SJtVHB2_47RA@mail.gmail.com>
	<CA+-0u-bOPHs_cyci=_RXb3r=qVVe2jSh9sB1RE+tGbpaTY0ZfA@mail.gmail.com>
Date: Thu, 28 Jan 2016 16:59:33 -0700
Message-ID: <CAJCQCtQEt5CEp=v=GiV3YJ4BCSk7AVDLrDnmsEm2+DMJR_+RPA@mail.gmail.com>
Subject: Re: btrfs subvolume list -o does not behave as expected
From: Chris Murphy <lists@colorremedies.com>
To: "Daniel E. Shub" <daniel.e.shub@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 28, 2016 at 3:08 PM, Daniel E. Shub <daniel.e.shub@gmail.com> wrote:
> On Wed, Jan 27, 2016 at 6:33 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Wed, Jan 27, 2016 at 2:09 PM, Daniel E. Shub <daniel.e.shub@gmail.com> wrote:
>>> I am experiencing what I think might be a bug with: btrfs subvolume list -o
>>>
>>> I reported it at https://bugzilla.kernel.org/show_bug.cgi?id=109861,
>>> but have read that bugs should be sent to the mailing list also.
>>>
>>> My root file system is on a btrfs partition and I have created btrfs
>>> subvolumes in /chroot and /var/lib. The following behavior seems
>>> incorrect
>>>
>>> # btrfs subvolume list -o /chroot
>>> ID 593 gen 6616 top level 5 path chroot/base-devel/root
>>> ID 594 gen 6618 top level 5 path chroot/multilib-devel/root
>>> ID 595 gen 6620 top level 5 path chroot/base/root
>>> ID 597 gen 6624 top level 5 path chroot/twm/root
>>> ID 599 gen 6628 top level 5 path chroot/lxde/root
>>> ID 601 gen 6655 top level 5 path chroot/wheezy/root
>>> ID 602 gen 6684 top level 5 path chroot/sid/root
>>> ID 603 gen 6862 top level 5 path var/lib/machines
>>>
>>> The man page for btrfs subvolume says
>>>   -o print only subvolumes below specified <path>.
>>>
>>> so I expected to only see the subvolumes below /chroot and to not see
>>> /var/lib/machines/.
>>>
>>> I am running Arch Linux with the 4.2.5 kernel and btrfs-progs v4.3.1.
>>
>> I agree that it's confusing because of the word <path>. It may
>> actually be a bug in documentation setting up the wrong expectation.
>>
>> If chroot were a subvolume, this would work as you expect. Since
>> chroot is a directory, in effect it's a request to show all subvolumes
>> on the fs-tree that this directory is on, i.e. subvolume id 5, which
>> would be all subvolumes. Whereas if chroot were a subvolume, the -o
>> would limit results to subvolumes having a top level at or below the
>> subvolume ID of chroot.
>>
>> I think.
>>
>>
>> --
>> Chris Murphy
>
> It seems like it would be much clearer if the -o option took a
> subvolume id instead of a path.
>
> The reason I was trying to get the list of subvolumes below /chroot/
> was I want to delete the chroot directory. How can I do that?

Do you want to delete all of the subvolumes also? If so, those have to
be deleted first, and right now there is no recursive delete.



-- 
Chris Murphy
