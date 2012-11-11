Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:32975 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2KKEPQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Nov 2012 23:15:16 -0500
Received: by mail-da0-f46.google.com with SMTP id n41so2244380dak.19
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Nov 2012 20:15:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <509ED5EF.6090506@shiftmail.org>
References: <509EC4B2.6090706@shiftmail.org>
	<20121110212317.GE29581@carfax.org.uk>
	<509ED5EF.6090506@shiftmail.org>
Date: Sat, 10 Nov 2012 22:15:16 -0600
Message-ID: <CAE5mzvjtN3_xMd3PdMFchef508a6H-3z0wOV9XoFAXQeHdPy+g@mail.gmail.com>
Subject: Re: High-sensitivity fs checker (not repairer) for btrfs
From: cwillu <cwillu@cwillu.com>
To: Bob Marley <bobmarley@shiftmail.org>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 10, 2012 at 4:32 PM, Bob Marley <bobmarley@shiftmail.org> wrote:
> On 11/10/12 22:23, Hugo Mills wrote:
>>
>>     The closest thing is btrfsck. That's about as picky as we've got to
>> date.
>>
>>     What exactly is your use-case for this requirement?
>
>
> We need a decently-available system. We can rollback filesystem to
> last-known-good if the "test" detects an inconsistency on current btrfs
> filesystem, but we need a very good test for that (i.e. if last-known-good
> is actually bad we get into serious troubles).

Scrub is probably more useful as a check, combined with "does the
filesystem actually mount".

> So do you think btrfsck can return a false "OK" result? can it "not-see" an
> inconsistency?

No set of checks will ever be perfect, so yes.
