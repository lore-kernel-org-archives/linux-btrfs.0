Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34107 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdA1JSC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 04:18:02 -0500
Received: by mail-lf0-f65.google.com with SMTP id q89so27640634lfi.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jan 2017 01:17:56 -0800 (PST)
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hans Deragon <hans@deragon.biz>, linux-btrfs@vger.kernel.org
References: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
 <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
 <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
 <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
Cc: Adam Borowski <kilobyte@angband.pl>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <07bba687-64c3-6713-6f6a-c8da183cbd3d@gmail.com>
Date: Sat, 28 Jan 2017 12:17:53 +0300
MIME-Version: 1.0
In-Reply-To: <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

27.01.2017 23:03, Austin S. Hemmelgarn пишет:
> On 2017-01-27 11:47, Hans Deragon wrote:
>> On 2017-01-24 14:48, Adam Borowski wrote:
>>
>>> On Tue, Jan 24, 2017 at 01:57:24PM -0500, Hans Deragon wrote:
>>>
>>>> If I remove 'ro' from the option, I cannot get the filesystem mounted
>>>> because of the following error: BTRFS: missing devices(1) exceeds the
>>>> limit(0), writeable mount is not allowed So I am stuck. I can only
>>>> mount the filesystem as read-only, which prevents me to add a disk.
>>>
>>> A known problem: you get only one shot at fixing the filesystem, but
>>> that's
>>> not because of some damage but because the check whether the fs is in a
>>> shape is good enough to mount is oversimplistic.
>>>
>>> Here's a patch, if you apply it and recompile, you'll be able to mount
>>> degraded rw.
>>>
>>> Note that it removes a safety harness: here, the harness got tangled
>>> up and
>>> keeps you from recovering when it shouldn't, but it _has_ valid uses
>>> that.
>>>
>>> Meow!
>>
>> Greetings,
>>
>> Ok, that solution will solve my problem in the short run, i.e. getting
>> my raid1 up again.
>>
>> However, as a user, I am seeking for an easy, no maintenance raid
>> solution.  I wish that if a drive fails, the btrfs filesystem still
>> mounts rw and leaves the OS running, but warns the user of the failing
>> disk and easily allow the addition of a new drive to reintroduce
>> redundancy.  Are there any plans within the btrfs community to implement
>> such a feature?  In a year from now, when the other drive will fail,
>> will I hit again this problem, i.e. my OS failing to start, booting into
>> a terminal, and cannot reintroduce a new drive without recompiling the
>> kernel?
> Before I make any suggestions regarding this, I should point out that
> mounting read-write when a device is missing is what caused this issue
> in the first place.


How do you replace device when filesystem is mounted read-only?
