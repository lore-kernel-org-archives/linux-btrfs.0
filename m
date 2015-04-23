Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33236 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030406AbbDWSQl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 14:16:41 -0400
MIME-Version: 1.0
In-Reply-To: <20150413165818.GC32634@kroah.com>
References: <1427984267.10670.0@mail.thefacebook.com>
	<20150413192838.3d5a0a69@natsu>
	<20150413165818.GC32634@kroah.com>
Date: Thu, 23 Apr 2015 14:16:40 -0400
Message-ID: <CAGfcS_nSSzikmkD_6wTTUAa0Zx6znoxf0qHwAfVeNuOZ9Ej5Kw@mail.gmail.com>
Subject: Re: Please add 9c4f61f01d269815bb7c37be3ede59c5587747c6 to stable
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Roman Mamedov <rm@romanrm.net>, Chris Mason <clm@fb.com>,
        stable <stable@vger.kernel.org>, Btrfs <linux-btrfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 13, 2015 at 12:58 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 13, 2015 at 07:28:38PM +0500, Roman Mamedov wrote:
>> On Thu, 2 Apr 2015 10:17:47 -0400
>> Chris Mason <clm@fb.com> wrote:
>>
>> > Hi stable friends,
>> >
>> > Can you please backport this one to 3.19.y.  It fixes a bug introduced
>> > by:
>> >
>> > 381cf6587f8a8a8e981bc0c1aaaa8859b51dc756, which was tagged for stable
>> > 3.14+
>> >
>> > The symptoms of the bug are deadlocks during log reply after a crash.
>> > The patch wasn't intentionally fixing the deadlock, which is why we
>> > missed it when tagging fixes.
>>
>> Unfortunately still not fixed (no btrfs-related changes) in 3.14.38 and
>> 3.18.11 released today.
>
> I have a few hundred stable backports left to sort through, don't worry,
> this is still in the queue, it's not lost.

It looks like this still isn't in 3.18.12, though it looks like it is in 3.19.5.

--
Rich
