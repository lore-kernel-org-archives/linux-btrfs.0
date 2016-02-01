Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34147 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbcBAUhN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 15:37:13 -0500
Received: by mail-io0-f169.google.com with SMTP id 9so92563735iom.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 12:37:13 -0800 (PST)
Subject: Re: Question about a specific error.
To: Chris Murphy <lists@colorremedies.com>
References: <56AFB598.2020307@gmail.com>
 <CAJCQCtQKPY537mZS0UVNzFQjCCVi6ik643wjssDnxGKiojcNzg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56AFC1A9.9010300@gmail.com>
Date: Mon, 1 Feb 2016 15:35:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQKPY537mZS0UVNzFQjCCVi6ik643wjssDnxGKiojcNzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-01 15:27, Chris Murphy wrote:
> On Mon, Feb 1, 2016 at 12:44 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> In the process of trying to debug issues I'm having on one of my
>> systems with a new kernel version, I decided to do a dry run check on
>> the root filesystem.  'btrfs check' returned a bunch of lines like:
>>
>> root 257 inode XXXXXX errors 2000, link count wrong
>>          unresolved ref dir YYYYY index 53 namelen 3 name LOG filetype 0 errors 3, no dir item, no dir index
>>
>> I got about 20 messages like this with varying values for everything
>> except the filetype and error counts.  Based on what I can tell, these
>> look like orphaned inodex, but I'm not certain.
>> Is it safe to tell BTRFS to try and fix these errors?
>
> Is it consistent between boots? I have a system with SSD where if I
> boot with rd.break=pre-mount, and run btrfs check, I sometimes get a
> long string of similar messages. But upon reboot they don't happen
> anymore.
>
I've only checked twice, but the output is identical, so they appear to 
be consistent.  What seems interesting about this to me is that while 
most of them are in the same directory, about 1/4 are just scattered 
around the FS.  None of it is anything critical though, and the system 
runs just fine (or at least, it appears to, most of the issues I'm 
having appear to be GPU related, and don't seem to have anything to do 
with BTRFS).
