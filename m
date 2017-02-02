Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55550 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbdBBVB3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Feb 2017 16:01:29 -0500
Subject: Re: [REVERT][v4.10][V2] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
To: Greg KH <greg@kroah.com>
References: <c5c953d1-c276-daec-faf4-4115827dd381@canonical.com>
 <20170202182313.GA10670@kroah.com>
 <36fa4d7d-1b59-7fe4-ad3f-d47372e11416@canonical.com>
 <20170202205700.GB28202@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>, luke@dashjr.org,
        jbacik@fb.com, dsterba@suse.com, clm@fb.com,
        linux-btrfs@vger.kernel.org, 1619918@bugs.launchpad.net
From: Joseph Salisbury <joseph.salisbury@canonical.com>
Message-ID: <905e66a0-1c73-34ec-4f1c-2a06c81c5bc8@canonical.com>
Date: Thu, 2 Feb 2017 16:01:23 -0500
MIME-Version: 1.0
In-Reply-To: <20170202205700.GB28202@kroah.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/02/2017 03:57 PM, Greg KH wrote:
> On Thu, Feb 02, 2017 at 02:58:16PM -0500, Joseph Salisbury wrote:
>> On 02/02/2017 01:23 PM, Greg KH wrote:
>>> On Thu, Feb 02, 2017 at 12:38:33PM -0500, Joseph Salisbury wrote:
>>>> Hello,
>>>>
>>>> Please consider reverting commit
>>>> 4c63c2454eff996c5e27991221106eb511f7db38 in the next v4.x.y release.
>>> What release can I remove it from?
>>>
>>> It isn't in 4.4.y, and 4.9.y doesn't make much sense, unless it's
>>> reverted in Linus's tree already?
>>>
>>> totally confused.
>>>
>>> greg k-h
>> Sorry, commit 4c63c2454eff996c5e27991221106eb511f7db38 was introduced in
>> mainline in v4.7-rc1.  The request should be only for kernels newer than
>> 4.7-rc1, so 4.9 and 4.10.
>>
>> I assume it will come down to 4.9 once reverted in mainline. 
> Let me know when it is reverted, and what that revert commit is please.
>
> thanks,
>
> greg k-h

Will do.


Thanks again,


Joe

