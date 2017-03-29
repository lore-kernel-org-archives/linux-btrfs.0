Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60764 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbdC2Fix (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 01:38:53 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ct6JX-0002Ca-3y
        for linux-btrfs@vger.kernel.org; Wed, 29 Mar 2017 07:38:35 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Qgroups are not applied when snapshotting a subvol?
Date: Wed, 29 Mar 2017 05:38:26 +0000 (UTC)
Message-ID: <pan$8260d$1d088731$17660708$be3d8bb2@cox.net>
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
        <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
        <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
        <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
        <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
        <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
        <3b03ab4a-a0c2-27df-c6e4-c5f60fd4b5db@cn.fujitsu.com>
        <24d10583-543f-cf1e-9f00-dd419a593f3d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 28 Mar 2017 07:44:56 -0400 as
excerpted:

> On 2017-03-27 21:49, Qu Wenruo wrote:

>> The problem is, how should we treat subvolume.
>>
>> Btrfs subvolume sits in the middle of directory and (logical) volume
>> used in traditional stacked solution.
>>
>> While we allow normal user to create/delete/modify dir as long as they
>> follow access control, we require privilege to create/delete/modify
>> volumes.

> No, we require privilege to do certain modifications or delete
> subvolumes.

>  Regular users can create subvolumes with no privileges whatsoever, and
> most basic directory operations (rename, chown, chmod, etc) work just
> fine within normal UNIX DAC permissions.  Unless you're running some
> specially patched kernel or some LSM (SELinux possibly) that somehow
> restricts access to the ioctl, you can always create subvolumes.

(I believe) You misread what QW was trying to say. Note the word "volume" 
as opposed to subvolume.  Like most regulars here, Qu's too deep into 
btrfs to make that sort of mistake, so he wasn't talking about subvolumes.

Rather, he's placing btrfs subvolumes in the middle between directories 
and (generic/logical) volumes as normally used, and saying that for 
(generic) directories normal users can create/modify/delete without 
special privilege (beyond write in the parent), for (generic) volumes 
special privileges are necessary to create/modify/delete, and btrfs 
subvolumes fall in between, so there's a real decision to be made in 
terms of privileges required, do they follow directories and require 
nothing special or volumes and require special privs?


Meanwhile, my own position as I've argued is that regardless of the 
theoretical debate, as long as we have the very real practical issue of 
hard scaling issues for subvolumes/snapshots, there's an equally real 
security issue in allowing unrestricted snapshot and to a lessor extent 
normal subvolume creation.

So while we might /like/ to make subvolumes more like directories and 
require no special privs, until the snapshot scaling and thus security 
issue is fixed or at least greatly reduced, as a purely practical 
security matter, we really need to restrict snapshot creation to 
privileged users.

OTOH, it's worth pointing out that snapshots aren't unique in this 
regard, reflinked files have exactly the /same/ scaling issues except 
their one-by-one while snapshots tend to be a whole bunch of reflinked 
files at once.

Which means the question must then be asked, if we choose the privileged 
route for snapshots/subvolumes due to the reflinking security issues, why 
aren't we making all reflinking ops privileged ops, or should we?  If we 
did, cp --reflink=always, among other things, would obviously fail as a 
normal user.

So I guess it's a rather harder question than I considered at first.  
Maybe we /should/ just treat subvolumes as directories in privileges 
terms as well.  In that case, however, we really need to have the same 
default for subvolume deletion as creation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

