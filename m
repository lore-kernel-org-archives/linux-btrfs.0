Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:48253 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3BVSfE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 13:35:04 -0500
Received: by mail-ie0-f171.google.com with SMTP id 10so1089690ied.2
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 10:35:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5127ADC3.7090808@alumni.calpoly.edu>
References: <5127A6C0.6080104@alumni.calpoly.edu>
	<20130222171604.GI14283@carfax.org.uk>
	<5127ADC3.7090808@alumni.calpoly.edu>
Date: Fri, 22 Feb 2013 12:35:03 -0600
Message-ID: <CAE5mzvhLSL1DQEGK6gnm+9Hgg5Umu33Tx3m5LkHdjqq+_pUYpg@mail.gmail.com>
Subject: Re: copy on write misconception
From: cwillu <cwillu@cwillu.com>
To: Mike Power <dodtsair@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 11:41 AM, Mike Power <dodtsair@gmail.com> wrote:
> On 02/22/2013 09:16 AM, Hugo Mills wrote:
>>
>> On Fri, Feb 22, 2013 at 09:11:28AM -0800, Mike Power wrote:
>>>
>>> I think I have a misconception of what copy on write in btrfs means
>>> for individual files.
>>>
>>> I had originally thought that I could create a large file:
>>> time dd if=/dev/zero of=10G bs=1G count=10
>>> 10+0 records in
>>> 10+0 records out
>>> 10737418240 bytes (11 GB) copied, 100.071 s, 107 MB/s
>>>
>>> real    1m41.082s
>>> user    0m0.000s
>>> sys    0m7.792s
>>>
>>> Then if I copied this file no blocks would be copied until they are
>>> written.  Hence the two files would use the same blocks underneath.
>>> But specifically that copy would be fast.  Since it would only need
>>> to write some metadata.  But when I copy the file:
>>> time cp 10G 10G2
>>>
>>> real    3m38.790s
>>> user    0m0.124s
>>> sys    0m10.709s
>>>
>>> Oddly enough it actually takes longer then the initial file
>>> creation.  So I am guessing that the long duration copy of the file
>>> is expected and that is not one of the virtues of btrfs copy on
>>> write.  Does that sound right?
>>
>>     You probably want cp --reflink=always, which makes a CoW copy of
>> the file's metadata only. The resulting files have the semantics of
>> two different files, but share their blocks until a part of one of
>> them is modified (at which point, the modified blocks are no longer
>> shared).
>>
>>     Hugo.
>>
> I see, and it works great:
> time cp --reflink=always 10G 10G3
>
> real    0m0.028s
> user    0m0.000s
> sys    0m0.000s
>
> So from the user perspective I might say I want to opt out of this feature
> not optin.  I want all copies by all applications done as a copy on write.
> But if my understanding is correct that is up to the application being
> called (in this case cp) and how it in turns makes calls to the system.
>
> In short I can't remount the btrfs filesystem with some new args that says
> always copy on write files because that is what it already.

There's no "copy a file" syscall; when a program copies a file, it
opens a new file, and writes all the bytes from the old to the new.
Converting this to a reflink would require btrfs to implement full
de-dup (which is rather expensive), and still wouldn't prevent the
program from reading and writing all 10gb (and so wouldn't be any
faster).

You can set an alias in your shell to make cp --reflink=auto the
default, but that won't affect other programs, nor other users.
