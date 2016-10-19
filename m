Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35010 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944062AbcJSPMQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 11:12:16 -0400
Received: by mail-io0-f171.google.com with SMTP id f5so34622021ioj.2
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 08:12:16 -0700 (PDT)
Subject: Re: Monitoring Btrfs
To: Anand Jain <anand.jain@oracle.com>,
        Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
References: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
 <05b79b4d-3f8d-7b78-d386-495b1dab1e70@gmail.com>
 <c40e1675-f002-b2e4-b252-c5e17200f72a@oracle.com>
 <a813c70b-e230-726e-e0bc-e8f15848cc44@gmail.com>
 <a12e3815-98c3-5ab6-179b-2c8efb841533@oracle.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9bbe4174-dcb0-ec14-2da8-eaf9b4f4ab82@gmail.com>
Date: Wed, 19 Oct 2016 07:15:17 -0400
MIME-Version: 1.0
In-Reply-To: <a12e3815-98c3-5ab6-179b-2c8efb841533@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-18 17:36, Anand Jain wrote:
>
>
>>>>> I would like to monitor my btrfs-filesystem for missing drives.
>
>
>>>> This is actually correct behavior, the filesystem reports that it
>>>> should
>>>> have 6 devices, which is how it knows a device is missing.
>
>
>>>  Missing - means missing at the time of mount. So how are you planning
>>> to monitor a disk which is failed while in production ?
>
>> No, in `btrfs fi show` it means that it can't find the device.
>
>  'btrfs fi show' is miss-leading as compared to 'btrfs fi show -m'
>  -m tells btrfs-kernel perspective of the devices, as of now
>  there is no code in the kernel which changes the device status
>  while its mounted (expect for readonly, which is irrelevant in
>  raid1 with 1 disk failed).
Actually, that's exactly how I would expect each of them to behave.  We 
need some way to get both the state the kernel thinks the FS is in, and 
the state it's actually in (according to the tools, not the kernel), and 
'-m' reporting kernel state while no '-m' reports actual state is 
exactly what I would expect in this case.

That leads also to another way I hadn't thought of to monitor a 
filesystem.  The output of 'fi show' with and without '-m' should match 
if the filesystem was healthy when mounted and is still healthy, if they 
don't, then something is wrong.
>
>> 1. Filesystem flags.  These will change when the filesystem goes
>> degraded,
>
>   Which flag is in question here. ?
I should clarify here, I mean the mount options, I'm just used to the 
monit terminology (which was not well picked in this case).  The big one 
to watch is the read-only flag, as BTRFS will force a filesystem 
read-only (which updates the mount options).  Any change to the mount 
options though without manual intervention is generally a sign that 
_something_ is wrong.
