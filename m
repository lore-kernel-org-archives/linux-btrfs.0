Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:45863 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3LTW0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 17:26:43 -0500
Received: by mail-wg0-f52.google.com with SMTP id x13so3082379wgg.7
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Dec 2013 14:26:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABtk0xQt7cJ8r+UicFjNgQ9nCKiw8-GYKAp46CYZFKnOVzOYSg@mail.gmail.com>
References: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
 <CABtk0xQt7cJ8r+UicFjNgQ9nCKiw8-GYKAp46CYZFKnOVzOYSg@mail.gmail.com>
From: Henry de Valence <hdevalence@hdevalence.ca>
Date: Fri, 20 Dec 2013 17:26:01 -0500
Message-ID: <CA+jiKjOHZZKg=uw=igBDEg1ccwWQkxgLor_ZCxN2mS-TgW2knQ@mail.gmail.com>
Subject: Re: btrfs on bcache
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 19, 2013 at 2:04 PM, Fábio Pfeifer <fmpfeifer@gmail.com> wrote:
> Any update on this?
>
> I have here exactly the same issue. Kernel 3.12.5-1-ARCH, backing
> device 500 GB IDE, cache 24 GB SSD => /dev/bcache0
> On /dev/bcache I also have 2 subvolumes, / and /home. I get lots of
> messages in dmesg:

I also have this issue.

Also, this afternoon I experienced data corruption on my btrfs device
(checksum errors), which might or might not be related. I don't really
know how to determine the cause, but if anyone has suggestions they'd
be appreciated.

Cheers,
Henry de Valence
