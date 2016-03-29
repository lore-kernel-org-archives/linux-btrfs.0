Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:32992 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbcC2UqU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 16:46:20 -0400
Received: by mail-io0-f172.google.com with SMTP id a129so38940138ioe.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 13:46:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHaDNyXRW4FQC+5P2_8apdFan2wtsHnPyzuK5ZPq8dLXW-S9_g@mail.gmail.com>
References: <CAHaDNyXRW4FQC+5P2_8apdFan2wtsHnPyzuK5ZPq8dLXW-S9_g@mail.gmail.com>
Date: Tue, 29 Mar 2016 14:46:19 -0600
Message-ID: <CAJCQCtT7VD2r-gHBCDgCcicSgfhgFLQy-DXgWGGm4c76wtFTHQ@mail.gmail.com>
Subject: Re: attempt to mount after crash during rebalance hard crashes server
From: Chris Murphy <lists@colorremedies.com>
To: "Warren, Daniel" <daniel.warren@mcmcllc.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 29, 2016 at 2:21 PM, Warren, Daniel
<daniel.warren@mcmcllc.com> wrote:
> Greetings all,
>
> I'm running 4.4.0 from deb sid
>
> My server crashed during a balance after I had added 10 disks to the
> original 15, I have not been able to bring the FS up since, it causes
> a system crash
>
> btrfs fi sh looks fine, but when I mount , it crashes the server with
> a NULL pointer dereference error
> Each Disk in the set is LUKS encrypted
>
> btrfs fi sh http://pastebin.com/QLTqSU8L
> kernel panic http://pastebin.com/aBF6XmzA

Panic shows:
CPU: 0 PID: 153 Comm: kworker/u8:13 Not tainted 3.16-2-amd64 #1 Debian 3.16.3-2

That's old. Are you sure you're running 4.4.0?


> If it's of any use I can run tests before I attempt check --repair

I suggest 4.4.5 or newer, and just try a regular mount first. The
general sequence is: newer kernel regular mount, then -o recovery,
then -o ro, recovery, and then btrfs check without --repair, and
posting all of the messages from those attempts.





-- 
Chris Murphy
