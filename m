Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35916 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbbC1Sqy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Mar 2015 14:46:54 -0400
Received: by iedm5 with SMTP id m5so91966316ied.3
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2015 11:46:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5516E266.6030400@gmail.com>
References: <5516E266.6030400@gmail.com>
Date: Sat, 28 Mar 2015 12:46:53 -0600
Message-ID: <CAJCQCtT9WimQUwTrquu0+1WW68vM3jeG0AjJyHZsG5CGycFakQ@mail.gmail.com>
Subject: Re: "corrupt 1", but no other indicators
From: Chris Murphy <lists@colorremedies.com>
To: Konstantin Svist <fry.kun@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 28, 2015 at 11:18 AM, Konstantin Svist <fry.kun@gmail.com> wrote:
> I'm seeing the following message on every bootup in dmesg &
> /var/log/messages:
>   BTRFS: bdev /dev/sda2 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>
> I've tried running scrub and it doesn't indicate any errors occurred
> Is this normal? Is something actually corrupted? Can I fix it?

It's a cumulative counter, so it's harmless. The problem has already
been automatically fixed. You can reset the counter with btrfs dev
stats -z.


-- 
Chris Murphy
