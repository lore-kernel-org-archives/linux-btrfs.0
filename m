Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:49555 "EHLO
        smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750707AbdC1MAV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 08:00:21 -0400
Received: from smtp18.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp18.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 6953C2520C
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 08:00:04 -0400 (EDT)
Received: by smtp18.relay.iad3a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id 1B643253CB
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 08:00:03 -0400 (EDT)
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: linux-btrfs@vger.kernel.org
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
 <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
 <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
 <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
 <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
 <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
 <CAJCQCtRikr0CaYRj1rQid-UPukNm6NXem_8QD_e-VZYoZ3HPWA@mail.gmail.com>
 <11740657-b2f9-36ab-9644-df2db29dd174@gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <1c8a021b-d258-3a50-3104-d898662c4375@rqc.ru>
Date: Tue, 28 Mar 2017 15:00:01 +0300
MIME-Version: 1.0
In-Reply-To: <11740657-b2f9-36ab-9644-df2db29dd174@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> The default should be to inherit the qgroup of the parent subvolume.
This behaviour is only good for this particular use-case. In general 
case, qgroups of subvolume and snapshots should exist separately, and 
both can be included in some higher level qgroup (after all, that's what 
qgroup hierarchy is for).

In my system I found it convenient to include subvolume and its 
snapshots in qgroup 1/N, where 0/N is qgroup of bare subvolume. I think 
adopting this behaviour as default would be more sensible.

--

With Best Regards,
Marat Khalili

On 28/03/17 14:24, Austin S. Hemmelgarn wrote:
> On 2017-03-27 15:32, Chris Murphy wrote:
>> How about if qgroups are enabled, then non-root user is prevented from
>> creating new subvolumes?
>>
>> Or is there a way for a new nested subvolume to be included in its
>> parent's quota, rather than the new subvolume having a whole new quota
>> limit?
>>
>> Tricky problem.
> The default should be to inherit the qgroup of the parent subvolume. 
> The organization of subvolumes is hierarchical, and sane people expect 
> things to behave as they look.  Taking another angle, on ZFS, 'nested' 
> (nested in quotes because ZFS' definition of 'nested' zvols is weird) 
> inherit their parent's quota and reservations (essentially reverse 
> quota), and they're not even inherently nested in the filesystem like 
> subvolumes are, so we're differing from the only other widely used 
> system that implements things in a similar manner.
>
> As far as the subvolume thing, there should be an option to disable 
> user creation of subvolumes, and ideally it should be on by default 
> because:
> 1. Users can't delete subvolumes by default.  This means they can 
> create but not destroy a resource by default, which means that a user 
> can pretty easily accidentally cause issues for the system as a whole.
> 2. Correlating with 1, users being able to delete subvolumes by 
> default is not safe on multiple levels (easy accidental data loss, 
> numerous other issues), and thus user subvolume removal being off by 
> default is significantly safer.
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

