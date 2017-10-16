Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35037 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751410AbdJPORV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 10:17:21 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e46CM-0007xR-HO
        for linux-btrfs@vger.kernel.org; Mon, 16 Oct 2017 16:16:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2 3/3] btrfs-progs: device: add remove missing-all
Date: Mon, 16 Oct 2017 14:16:47 +0000 (UTC)
Message-ID: <pan$42eea$de4d7a4f$758b6722$69270df6@cox.net>
References: <bb58e829-77d4-1bd1-4021-2db996809a6e@jp.fujitsu.com>
        <be3e6086-5a2f-77d0-5dbc-dcb5a1a57815@jp.fujitsu.com>
        <pan$48dd8$f51614da$34e59787$eb10b745@cox.net>
        <d311a713-a663-a11d-7cdb-bb9d359c4ba5@oracle.com>
        <649452a3-908d-670d-8bfd-b0e248b32b32@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Misono, Tomohiro posted on Mon, 16 Oct 2017 13:35:08 +0900 as excerpted:

> On 2017/10/16 12:30, Anand Jain wrote:
>> 
>> 
>> On 10/13/2017 01:27 PM, Duncan wrote:
>>> Misono, Tomohiro posted on Wed, 11 Oct 2017 11:18:50 +0900 as
>>> excerpted:
>>>
>>>> Add 'btrfs remove missing-all' to remove all the missing devices at
>>>> once for improving usability.
>>>>
>>>> Example:
>>>>   sudo mkfs.btrfs -f -d raid1 /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4
>>>>   sudo wipefs -a /dev/sdb1 /dev/sdb3 sudo mount -o degraded /dev/sdb2
>>>>   /mnt <--
>> 
>> 
>>    I agree with Duncan here. This step itself will fail even with RO
>>    option. Do you have any patch that is not in the ML which will make
>>    this step a success in the first place ?
>> 
>> Thanks, Anand
>> 
>> 
> commit 21634a19f646 ("btrfs: Introduce a function to check if all chunks
> a OK for degraded rw mount") allow this from 4.14 (I checked on
> 4.14-rc4).

That's why I said recent patches allow it in corner-cases.  However, I 
think those corner-cases would I think be difficult to document concisely 
in the manpage, and without that, I believe the option would be more 
confusing than helpful, since people would expect it to actually work 
when it won't, for them.

> But I will withdraw this patch as Duncan suggests.

If someone comes up with a satisfactory way to explain at a manpage level 
the corner-cases in which removing more than one missing device at a time 
can work...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

