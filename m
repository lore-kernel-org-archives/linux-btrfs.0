Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38100 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3CPNIs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 09:08:48 -0400
Received: by mail-ie0-f174.google.com with SMTP id k10so5345096iea.5
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Mar 2013 06:08:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303162346.40534.russell@coker.com.au>
References: <201303162302.14746.russell@coker.com.au>
	<CAE5mzvj4DF98MmzW7M29WZtKiW3p_f7=GzZ54q3+jo6CWgPvxw@mail.gmail.com>
	<201303162346.40534.russell@coker.com.au>
Date: Sat, 16 Mar 2013 07:08:48 -0600
Message-ID: <CAE5mzvgqkeB2qox4hi7JZ0cOQkwNA0WrMC2+k4bXDDGWuD+5OA@mail.gmail.com>
Subject: Re: multiple btrfsck runs
From: cwillu <cwillu@cwillu.com>
To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 16, 2013 at 6:46 AM, Russell Coker <russell@coker.com.au> wrote:
> On Sat, 16 Mar 2013, cwillu <cwillu@cwillu.com> wrote:
>> On Sat, Mar 16, 2013 at 6:02 AM, Russell Coker <russell@coker.com.au> wrote:
>> > Is it expected that running btrfsck more than once will keep reporting
>> > errors?
>>
>> Without options, btrfsck does not write to the disk.
>
> The man page for the version in Debian doesn't document any options.
>
> The source indicates that --repair might be the one that's desired, is that
> correct?

Yes.  However, unless something is actually broken, or you've been
advised by a developer, I'd stick with btrfs scrub.
