Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:34747 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753088AbdLGMVt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Dec 2017 07:21:49 -0500
Received: by mail-it0-f52.google.com with SMTP id m11so424587iti.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Dec 2017 04:21:49 -0800 (PST)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id m123sm2467789iom.71.2017.12.07.04.21.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Dec 2017 04:21:47 -0800 (PST)
Subject: Re: [RFC] Improve subvolume usability for a normal user
To: linux-btrfs@vger.kernel.org
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
 <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
 <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
 <43b6e90c-6461-d722-fb8c-8ad5069841fd@jp.fujitsu.com>
 <e1a297d8-28fb-980e-fd62-c261186b3a6a@gmail.com>
 <pan$33b4a$60a76f26$86fed72c$a3e3152c@cox.net>
 <cf2e2d1b-a85a-cc02-5671-523f95c9db34@jp.fujitsu.com>
 <pan$5078c$e6344b9d$7ac11ecf$99edcd61@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b581ea80-7c8e-9eda-59ef-550ef40206b2@gmail.com>
Date: Thu, 7 Dec 2017 07:21:46 -0500
MIME-Version: 1.0
In-Reply-To: <pan$5078c$e6344b9d$7ac11ecf$99edcd61@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-07 06:55, Duncan wrote:
> Misono, Tomohiro posted on Thu, 07 Dec 2017 16:15:47 +0900 as excerpted:
> 
>> On 2017/12/07 11:56, Duncan wrote:
>>> Austin S. Hemmelgarn posted on Wed, 06 Dec 2017 07:39:56 -0500 as
>>> excerpted:
>>>
>>>> Somewhat OT, but the only operation that's remotely 'instant' is
>>>> creating an empty subvolume.  Snapshot creation has to walk the tree
>>>> in the subvolume being snapshotted, which can take a long time (and as
>>>> a result of it's implementation, also means BTRFS snapshots are _not_
>>>> atomic). Subvolume deletion has to do a bunch of cleanup work in the
>>>> background (though it may be fairly quick if it was a snapshot and the
>>>> source subvolume hasn't changed much).
>>>
>>> Indeed, while btrfs in general has taken a strategy of making
>>> /creating/ snapshots and subvolumes fast, snapshot deletion in
>>> particular can take some time[1].
>>>
>>> And in that regard a question just occurred to me regarding this whole
>>> very tough problem of a user being able to create but not delete
>>> subvolumes and snapshots:
>>>
>>> Given that at least snapshot deletion (not so sure about non-snapshot
>>> subvolume deletion, tho I strongly suspect it would depend on the
>>> number of cross-subvolume reflinks) is already a task that can take
>>> some time, why /not/ just bite the bullet and make the behavior much
>>> more like the directory deletion, given that subvolumes already behave
>>> much like directories.  Yes, for non-root, that /does/ mean tracing the
>>> entire subtree and checking permissions, and yes, that's going to take
>>> time and lower performance somewhat, but subvolume and in particular
>>> snapshot deletion is already an operation that takes time, so this
>>> wouldn't be unduly changing the situation, and it would eliminate the
>>> entire class of security issues that come with either asymmetrically
>>> restricting deletion (but not creation) to root on the one hand,
>>
>>> or possible data loss due to allowing a user to delete a subvolume they
>>> couldn't delete were it an ordinary directory due to not owning stuff
>>> further down the tree.
>>
>> But, this is also the very reason I'm for "sub del" instead of unlink().
>> Since snapshot creation won't check the permissions of the containing
>> files/dirs, it can copy a directory which cannot be deleted by the user.
>> Therefore if we won't allow "sub del" for the user, he couldn't remove
>> the snapshot.
> 
> Maybe snapshot creation /should/ check all that, in ordered to allow
> permissions to allow deletion.
> 
> Tho that would unfortunately increase the creation time, and btrfs is
> currently optimized for fast creation time.
> 
> Hmm... What about creating a "temporary" snapshot if not root, then
> walking the tree to check perms and deleting it without ever showing it
> to userspace if the perms wouldn't let the user delete it.  That would
> retain fast creation logic, tho it wouldn't show up until the perms walk
> was completed.
> 
I would argue that it makes more sense to keep snapshot creation as is, 
keep the subvolume deletion command as is (with some proper permissions 
checks of course), and just make unlink() work for subvolumes like it 
does for directories.
