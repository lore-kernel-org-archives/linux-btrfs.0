Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50078 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbdJQDvF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 23:51:05 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e4Iu2-00065m-VS
        for linux-btrfs@vger.kernel.org; Tue, 17 Oct 2017 05:50:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v3 2/2] btrfs-progs: doc: add description of missing and
 example of device remove
Date: Tue, 17 Oct 2017 03:50:42 +0000 (UTC)
Message-ID: <pan$737d1$a91e4047$e60af25f$fab8213e@cox.net>
References: <7dcb7f01-ce39-18a6-9a16-9230b76baf77@jp.fujitsu.com>
        <d5e0465d-9606-1881-84a7-86c0d43e0033@jp.fujitsu.com>
        <98ad3fcf-dc1c-babd-2876-c26953105a03@suse.com>
        <bffa9bb9-bd2b-90b7-9517-f728bbbeb543@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Misono, Tomohiro posted on Tue, 17 Oct 2017 10:45:58 +0900 as excerpted:

> On 2017/10/16 18:22, Nikolay Borisov wrote:
>> 
>> 
>> On 16.10.2017 07:56, Misono, Tomohiro wrote:
>>>
>>> 1. Add explanation of 'missing' for 'device remove'. This is only
>>> written in wikipage currently.

>>> +++ b/Documentation/btrfs-device.asciidoc

>> Also, what happens if there are 2 or more devices missing, will those
>> be deleted as well or just the first device? If all missing devices are
>> handled then this needs to be reflected in the documentation.

> How about adding a note in the end?:
> ===
>  If filesystem is mounted in degraded mode (-o degraded), special term
>  "missing" can be used for <device>. In that case, the first device that
>  is described by the filesystem metadata, but not present at the mount
>  time will be removed.
> 
>  NOTE: In most cases, there is only one missing device in degraded mode,
>  otherwise mount fails. If there are two or more devices missing (e.g.
>  possible in RAID 6), you need specify "missing" as many times as the
>  number of missing devices to remove all of them.
> ===

LGTM. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

