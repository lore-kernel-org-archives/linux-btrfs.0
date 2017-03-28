Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52531 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753757AbdC1CmU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 22:42:20 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1csh5A-0001Nb-Vd
        for linux-btrfs@vger.kernel.org; Tue, 28 Mar 2017 04:42:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Qgroups are not applied when snapshotting a subvol?
Date: Tue, 28 Mar 2017 02:41:52 +0000 (UTC)
Message-ID: <pan$4c68e$4d5b137e$7fa9a653$88273853@cox.net>
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
        <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
        <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
        <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
        <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
        <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
        <CAJCQCtRikr0CaYRj1rQid-UPukNm6NXem_8QD_e-VZYoZ3HPWA@mail.gmail.com>
        <20170328005358.5d5366ef@natsu>
        <5236e403-6f41-aae1-6e8a-ab04e3b98c89@mendix.com>
        <CAJCQCtTOX6p03hPi6CJyzPKmFQMfP4oSCzbrkjftU=Sm9LdjPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 27 Mar 2017 15:11:34 -0600 as excerpted:

>> What are actual use cases for creating subvolumes by 'normal' users?
>>
>> Does someone have an example?
>>
>> Why is it possible at all, by default?
> 
> I have a single git subvolume in my user directory, inside of which are
> various git clones. And I periodically snapshot the git subvolume as a
> regular user.
> 
> If I can't create subvolumes as a regular user then by extension it'd
> mean I can't create snapshots of my own home directory, or any other
> subvolumes I exclusively own.

One rather big problem with what, with snapshots (which are a special 
kind of subvolume), is that btrfs has known scaling issues when the 
number of snapshots gets too high.  Combine that with allowing users to 
make but not delete snapshots, and you have a huge invitation to scaling 
headaches due to the number of snapshots.

Really, the two permissions subvolume/snapshot creation, and deletion, 
should be synchronized.  Allowing subvolume deletion clearly has security 
issues, but so does allowing creation without allowing deletion.  They 
both really have to go together, and be allowed only for "trusted" users, 
with the option of whether that's root-only, or a subset of users (say 
via group perms), or all users, being up to the local admin, basically, a 
mount option.

Which in usual terms means making the perms root-only, with the binary 
set to some controlled-access group and set-SUID-root (or appropriate 
security attributes, I'm drawing a blank on the word I want ATM), and 
then letting the admin control access via group membership.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

