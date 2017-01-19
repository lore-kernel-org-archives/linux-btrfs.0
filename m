Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35630 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752183AbdASMMP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 07:12:15 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5a436c110e0b823a9b6babedfe450734@synology.com>
References: <1477619046-16375-1-git-send-email-robbieko@synology.com>
 <1477619046-16375-5-git-send-email-robbieko@synology.com> <20161101072055.GQ27776@eguan.usersys.redhat.com>
 <5a436c110e0b823a9b6babedfe450734@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 19 Jan 2017 12:11:23 +0000
Message-ID: <CAL3q7H61M__ttxvEDBVp7qQgCvcnW0=M2vzW0A0wppTtr+-Nxw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] xfstests: btrfs/134: add test for incremental send
 which renames a directory already being deleted
To: robbieko <robbieko@synology.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 2, 2016 at 3:52 AM, robbieko <robbieko@synology.com> wrote:
> Hi Eryu Guan,
>
> Yes, it need apply
> [PATCH] "Btrfs: incremental send, do not skip generation inconsistency check
> for inode 256."
> and test again, it will failed.
>
> because current code there is a problem, but just will not happen.

Then it's not a problem...
What your're saying is confusing to say the least.

I really don't like the idea of adding a patch that is know to
introduce a regression and then adding another patch that fixes it.
Anyway, your patchset has been reviewed and those patches are not
needed anymore as there's a better solution that doesn't imply
introducing a regression temporarily, so this test is not really
needed.

thanks

>
> Thansk
> Robbie Ko
>
> Eryu Guan 於 2016-11-01 15:20 寫到:
>
>> On Fri, Oct 28, 2016 at 09:44:06AM +0800, robbieko wrote:
>>>
>>> From: Robbie Ko <robbieko@synology.com>
>>>
>>> Test that an incremental send operation dosen't work because
>>> it tries to rename a directory which is already deleted.
>>>
>>> This test exercises scenarios used to fail in btrfs and are fixed by
>>> the following patch for the linux kernel:
>>>
>>> "Btrfs: incremental send, add generation check for inode is waiting for
>>> move."
>>
>>
>> I was testing with v4.9-rc1+ kernel and btrfs-progs v4.6. Seems above
>> patch is not merged in 4.9-rc1 kernel, but test passed for me, is that
>> expected?
>>
>> Thanks,
>> Eryu
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
