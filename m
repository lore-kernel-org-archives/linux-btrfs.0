Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54305 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3EEUHI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 16:07:08 -0400
Received: by mail-oa0-f48.google.com with SMTP id i4so604993oah.35
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 13:07:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CB6E97C9-6354-4F08-95EA-2E056EB7082B@gmail.com>
References: <CADn-QaPVg6C3sMhkasZc+JsoaQ_YQJB-nnoQRKd+XW7sXc1tew@mail.gmail.com>
 <201305030857.55917.russell@coker.com.au> <loom.20130503T132412-316@post.gmane.org>
 <CADn-QaMnyAAiNCUuiM9j2QbGs+G9ucG=84BUJB+FkvPGhAAWqw@mail.gmail.com> <CB6E97C9-6354-4F08-95EA-2E056EB7082B@gmail.com>
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Date: Sun, 5 May 2013 22:06:48 +0200
Message-ID: <CADn-QaMvSww-nHU64_SBXUhhV5i2XxrLk-Umwf6c0NY39a9Csg@mail.gmail.com>
Subject: Re: btrfs subv list -> ERROR: Failed to lookup path for root 0 - No
 such file or directory
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Wang

On Sat, May 4, 2013 at 4:50 PM, Wang Shilong <wangshilong1991@gmail.com> wrote:

> I use the latest  btrfs-progs, and i can not reproduce the problem, would you please
> double check with this url:
> https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/

Must be so, that I by accident used the "stable" version that
got shipped with Ubuntu.

If I use the one from git, I also cannot reproduce.

Thanks

Alexander
--
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
