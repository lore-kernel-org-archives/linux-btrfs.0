Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:34524 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932099AbdC1Ld2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 07:33:28 -0400
Received: by mail-it0-f52.google.com with SMTP id y18so26186281itc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 04:33:27 -0700 (PDT)
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: Chris Murphy <lists@colorremedies.com>
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
 <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
 <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
 <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
 <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
 <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
 <CAJCQCtRikr0CaYRj1rQid-UPukNm6NXem_8QD_e-VZYoZ3HPWA@mail.gmail.com>
Cc: Moritz Sichert <moritz+linux@sichert.me>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <11740657-b2f9-36ab-9644-df2db29dd174@gmail.com>
Date: Tue, 28 Mar 2017 07:24:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRikr0CaYRj1rQid-UPukNm6NXem_8QD_e-VZYoZ3HPWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-27 15:32, Chris Murphy wrote:
> How about if qgroups are enabled, then non-root user is prevented from
> creating new subvolumes?
>
> Or is there a way for a new nested subvolume to be included in its
> parent's quota, rather than the new subvolume having a whole new quota
> limit?
>
> Tricky problem.
The default should be to inherit the qgroup of the parent subvolume. 
The organization of subvolumes is hierarchical, and sane people expect 
things to behave as they look.  Taking another angle, on ZFS, 'nested' 
(nested in quotes because ZFS' definition of 'nested' zvols is weird) 
inherit their parent's quota and reservations (essentially reverse 
quota), and they're not even inherently nested in the filesystem like 
subvolumes are, so we're differing from the only other widely used 
system that implements things in a similar manner.

As far as the subvolume thing, there should be an option to disable user 
creation of subvolumes, and ideally it should be on by default because:
1. Users can't delete subvolumes by default.  This means they can create 
but not destroy a resource by default, which means that a user can 
pretty easily accidentally cause issues for the system as a whole.
2. Correlating with 1, users being able to delete subvolumes by default 
is not safe on multiple levels (easy accidental data loss, numerous 
other issues), and thus user subvolume removal being off by default is 
significantly safer.

