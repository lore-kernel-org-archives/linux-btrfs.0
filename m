Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55265 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751233AbeAWPaA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 10:30:00 -0500
Subject: Re: [PATCH 6/7] btrfs-progs: Add test for super block recovery
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-7-git-send-email-nborisov@suse.com>
 <ea75633b-10e7-28e0-ae47-5502901599de@gmx.com>
 <2bff48d1-09fa-59ae-7f1f-f4a91b9bf143@suse.com>
 <20180123150709.GK15713@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <063a331d-9404-922f-0c72-268c9e86a8e4@suse.com>
Date: Tue, 23 Jan 2018 17:29:57 +0200
MIME-Version: 1.0
In-Reply-To: <20180123150709.GK15713@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.01.2018 17:07, David Sterba wrote:
> On Tue, Dec 05, 2017 at 12:04:49PM +0200, Nikolay Borisov wrote:
>>>> --- /dev/null
>>>> +++ b/tests/fsck-tests/029-superblock-recovery/test.sh
>>>> @@ -0,0 +1,64 @@
>>>> +#!/bin/bash
>>>> +# Test that any superblock is correctly detected
>>>> +# and fixed by btrfs rescue
>>>> +
>>>> +source "$TOP/tests/common"
>>>> +
>>>> +check_prereq btrfs
>>>> +check_prereq mkfs.btrfs
>>>> +check_prereq btrfs-select-super
>>>> +
>>>> +setup_root_helper
>>>> +
>>>> +rm -f dev1
>>>> +run_check truncate -s 260G dev1
>>>> +loop=$(run_check_stdout $SUDO_HELPER losetup --find --show dev1)
>>>
>>> We have function to do it already.
>>> prepare_test_dev will use loopback device as fallback if $TEST_DEV is
>>> not specified.
>>> Tt can handle size well, and it also uses sparse file so no need to
>>> worry about disk usage.
>>
>> Then the test suite is not very consistent, since I copied this loopback
>> handling from some other test.
> 
> From which one? Some tests have special needs and may set up the loop
> device on their own. The rest should use the helpers in tests/common and
> I don't see anything that would not be provided by them.

Looking back at the code it seems it could have been from
021-image-multi-devices.

Anyway, I haven't resubmitted the sequence since I was waiting for
feedback. Qu already mentioned this could be refactored.


> 
> The consistency in the testsuite is being improved as we find and
> identify the patterns worth wrapping into helpers so you may see some
> code duplication.
> 
