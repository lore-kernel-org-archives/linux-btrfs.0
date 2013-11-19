Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33031 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3KSLgq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 06:36:46 -0500
Received: by mail-ie0-f181.google.com with SMTP id e14so3926203iej.40
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Nov 2013 03:36:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <528B44BD.9050502@mpi-sws.org>
References: <528B44BD.9050502@mpi-sws.org>
Date: Tue, 19 Nov 2013 13:36:43 +0200
Message-ID: <CAELSAVa+xA6NJ3UWw+C6xVegVhQKyPYZCLRU395+f5L4rN5qkA@mail.gmail.com>
Subject: Re: Warning in record_one_backref()
From: Emil Karlson <jekarlson@gmail.com>
To: Pedro Fonseca <pfonseca@mpi-sws.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 19, 2013 at 1:00 PM, Pedro Fonseca <pfonseca@mpi-sws.org> wrote:
> Hi,
>
> In another test, I've encountered a few situations that triggered a warning
> message in "record_one_backref()". I'm not sure if it's serious but it is
> probably related to the concurrent defragment operations executed during the
> test.
>
I think You'll need this patch or later linux-3.11 or linux-3.12

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=50f1319cb5f7690e4d9de18d1a75ea89296d0e53
