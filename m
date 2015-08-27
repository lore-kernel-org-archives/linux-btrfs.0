Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:34136 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbbH0XEq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 19:04:46 -0400
Received: by vkhf67 with SMTP id f67so1977112vkh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 16:04:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGa2bXYQSWdm_gQMFKDW1oMMeuaYhDdUJ0Fq3v9CS2x8+StYoA@mail.gmail.com>
References: <CAGa2bXYQSWdm_gQMFKDW1oMMeuaYhDdUJ0Fq3v9CS2x8+StYoA@mail.gmail.com>
Date: Thu, 27 Aug 2015 17:04:45 -0600
Message-ID: <CAJCQCtSC1+NbtXKP6Y=tTQW7AqdjwmkfWLNBQoY7v-Xpkr6a7Q@mail.gmail.com>
Subject: Re: Btrfs crash since 4.1.4
From: Chris Murphy <lists@colorremedies.com>
To: Yasuo Ohgaki <yohgaki@ohgaki.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 27, 2015 at 4:03 PM, Yasuo Ohgaki <yohgaki@ohgaki.net> wrote:
> Hi developers,
>
> I'm start getting kernel crash/oops from btrfs since 4.1.4.
> https://www.kernel.org/pub/linux/kernel/v4.x/ChangeLog-4.1.4
>
> I'm using fedora 22, so I reported this to their bugzilla.
> https://bugzilla.redhat.com/show_bug.cgi?id=1255509
>
> If you need additional information to fix issue, please let me know.

It's a bit tedious to read the traces in the bug report because
they're wrapping badly. It's better to attach complete dmesg or
'journalctl -b -o short-monotonic' as files. However, it looks like
this is an md problem though, but I can't tell if it's related to what
Austin mentioned earlier today about recent md additions causing
problems.
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg45826.html


-- 
Chris Murphy
