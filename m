Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40668 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbdKWOF0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 09:05:26 -0500
Received: by mail-wm0-f67.google.com with SMTP id b189so16777067wmd.5
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Nov 2017 06:05:25 -0800 (PST)
Subject: Re: uncorrectable errors in Raid 10
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Murphy <lists@colorremedies.com>
References: <a61eeda7-af07-e140-ccd9-d288931f07fb@gmail.com>
 <CAJCQCtSLG5hXikEiBD4OF5G+EfKgyALaynqivBvCaWLpEYQjEw@mail.gmail.com>
 <1c612777-77eb-1b83-101b-a9e0a53ee8be@gmail.com>
 <CAJCQCtRwO5E_xN-7u22uBQ57sYpUf8qQ7O0Abz2m+K8e9+DgdA@mail.gmail.com>
 <384b4a21-e74f-c52e-c6e2-f7930f187c94@gmail.com>
 <CAJCQCtQKOVYtOmQeCR0GZ08Wew2TjtZzfoA_mDvsHwL5vt06XA@mail.gmail.com>
 <63eff0dd-050c-95e5-0bc8-6c151900261c@gmail.com>
 <6f961563-f992-41c5-bb6f-2c7f66bbaa0c@gmx.com>
Cc: linux-btrfs@vger.kernel.org
From: Steffen Sindzinski <stesind@gmail.com>
Message-ID: <77e7f17a-e5b6-72dd-29fc-b6f32a28d80d@gmail.com>
Date: Thu, 23 Nov 2017 15:05:12 +0100
MIME-Version: 1.0
In-Reply-To: <6f961563-f992-41c5-bb6f-2c7f66bbaa0c@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I think just some XWayland Nouveau bug:

Nov 23 12:46:26 bigbox kernel: nouveau 0000:01:00.0: gr: TRAP ch 22 
[007d08d000 Xwayland[781]]
Nov 23 12:46:26 bigbox kernel: nouveau 0000:01:00.0: gr: GPC0/TPC0/TEX: 
80000041
Nov 23 12:46:26 bigbox kernel: nouveau 0000:01:00.0: gr: GPC0/TPC1/TEX: 
80000041
Nov 23 12:46:26 bigbox kernel: nouveau 0000:01:00.0: gr: GPC0/TPC2/TEX: 
80000041
Nov 23 12:46:26 bigbox kernel: nouveau 0000:01:00.0: gr: GPC0/TPC3/TEX: 
80000041
Nov 23 12:46:26 bigbox kernel: nouveau 0000:01:00.0: gr: GPC0/TPC4/TEX: 
80000041
Nov 23 12:46:26 bigbox kernel: nouveau 0000:01:00.0: fifo: read fault at 
0005860000 engine 00 [GR] client 15 [GPC0/PE_4] reason 02 [PTE] on 
channel 22 [007d08d000 Xwayland[781]]


Steffen


Am 23.11.2017 um 13:14 schrieb Qu Wenruo:
> 
> 
> On 2017年11月23日 20:02, Steffen Sindzinski wrote:
>> Hi,
>>
>> I updated to btrfs-progs v4.14-5-gf09e98a3. Unfortunately after 10h
>> Gnome desktop / Arch crashed with btrfs check --lowmem unfinished. I
>> will run it this night again.
> 
> Any kernel backtrace about the crash?
> 
> IIRC user space program like btrfs check should not trigger a kernel crash.
> 
>>
>> The result until crash was:
>>
>> Checking filesystem on /dev/sdd2
>> UUID: 4fafd0d4-7dd9-4dcc-9a33-5f1ad9555358
>> ERROR: extent[15923092037632, 73728] referencer count mismatch (root:
>> 260, owner: 3631467, offset: 1019904) wanted: 4, have: 6
>> ERROR: extent[16078964924416, 69632] referencer count mismatch (root:
>> 260, owner: 4086589, offset: 4296704) wanted: 5, have: 7
> 
> This is known bug, please use this branch instead.
> https://github.com/adam900710/btrfs-progs/tree/lowmem_fix
> 
> Thanks,
> Qu
> 
>>
>> Steffen
>>
>>
>> Am 22.11.2017 um 17:42 schrieb Chris Murphy:
>>> On Wed, Nov 22, 2017 at 9:38 AM, Steffen Sindzinski
>>> <stesind@gmail.com> wrote:
>>>> Hello,
>>>>
>>>> I did btrfs check --readonly on both disk without finding any error. To
>>>> reconfirm I did a scrub again which still has found 2 uncorrectable
>>>> errors.
>>>
>>> Try --mode=lowmem option with btrfs-progs 4.3.3 or better 4.14. This
>>> is a new implementation of btrfs check and sometimes it comes up with
>>> different results. It's strange that there's only this error found by
>>> scrub and not by btrfs check which should be fully checking all
>>> metadata for sanity, and in the process it would surely hit a bad
>>> checksum.
>>>
>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
