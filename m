Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36635 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbbEIHn0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 May 2015 03:43:26 -0400
Received: by igbpi8 with SMTP id pi8so37676232igb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 09 May 2015 00:43:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSK6cejsr=5J=XvWHnU6iUTrQ_gMGV3ExBwoxvO0ZaXcQ@mail.gmail.com>
References: <CAJCQCtSK6cejsr=5J=XvWHnU6iUTrQ_gMGV3ExBwoxvO0ZaXcQ@mail.gmail.com>
Date: Sat, 9 May 2015 01:43:25 -0600
Message-ID: <CAJCQCtSXceHtfNYpOekP+8TfiF7WJeHQNwYyNJRYnD0XT2z-XA@mail.gmail.com>
Subject: Re: oops BUG unable to handle kernel NULL point dereference IP io_ctl_check_crc
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 9, 2015 at 12:34 AM, Chris Murphy <lists@colorremedies.com> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=97991

OK it appears to be a 32bit kernel problem, as it happens in an x86_64
qemu/kvm VM.

But that same vm with the same version 64bit kernel doesn't exhibit the problem.

-- 
Chris Murphy
