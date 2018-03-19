Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34798 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932260AbeCSMBx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 08:01:53 -0400
Received: by mail-oi0-f49.google.com with SMTP id u141so2157150oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 05:01:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22dcd685-2ffd-8f96-ebf9-1b573fc5470c@suse.com>
References: <CANT5p=o57C_dxnrfF6C7h=cdVz2iVeWeOcri1xOnHhbxt+Gd=A@mail.gmail.com>
 <0e0d6b97-1dd6-23a7-c4ca-f79fefef23ff@suse.com> <CANT5p=oYXh7JhEMhZ4zWCHPsof38=xW3hrnjidnm_=WhpfwzFA@mail.gmail.com>
 <29ed3443-6c02-2e46-5f4e-d3dd80e7e817@suse.com> <CANT5p=pD+6L76-fBN1ax=UYsqyFzh+PQcc0mK9C7poZi7vNVRg@mail.gmail.com>
 <3e96b978-a14e-7e48-a327-a73bc3004256@suse.com> <CANT5p=riMAVR5p4oNPTw37iSfrdFU2ay+Uj-5XF5=DhW0ED0ow@mail.gmail.com>
 <22dcd685-2ffd-8f96-ebf9-1b573fc5470c@suse.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 19 Mar 2018 17:31:52 +0530
Message-ID: <CANT5p=qyN1JOk0HQVfZDdMa85ueH1MGv01Y_P9bj_Mu9+_rDLg@mail.gmail.com>
Subject: Re: High CPU usage of RT threads...
To: Nikolay Borisov <nborisov@suse.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for the analysis, Nikolay.
Will try to upgrade the kernel and check if the issue reproduces.

Regards,
Shyam

On Mon, Mar 19, 2018 at 5:21 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>
>
> On 19.03.2018 13:48, Shyam Prasad N wrote:
>> On Mon, Mar 19, 2018 at 4:37 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>>>
>>>
>>> On 19.03.2018 13:02, Shyam Prasad N wrote:
>>>> Hi,
>>>>
>>>> Attaching the sysrq-trigger output.
>>>
>>> Has this been obtained while the machine experienced a period of a lot
>>> of blocked threads? Because the output shows a machine which is idle?
>>>
>> Hmm.. No, actually. The threads are still taking up CPU, and not
>> responding to signals.
>
> Considering all the data you provided I'm inclined to say you have a
> problem of different nature than btrfs. Nothing really points at the
> direction of btrfs.
>
>>
>>



-- 
-Shyam
