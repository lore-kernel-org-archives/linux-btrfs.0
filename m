Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36671 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbbK3Hs7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 02:48:59 -0500
Received: by lfs39 with SMTP id 39so183195584lfs.3
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Nov 2015 23:48:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$98cfe$190ff92c$916c4a80$8c9e9ee4@cox.net>
References: <20151129130754.GI31524@torres.zugschlus.de>
	<20151129141806.GG24333@carfax.org.uk>
	<20151129180629.GJ31524@torres.zugschlus.de>
	<pan$98cfe$190ff92c$916c4a80$8c9e9ee4@cox.net>
Date: Mon, 30 Nov 2015 09:48:57 +0200
Message-ID: <CAK5rZE5ug5MVntFBa31Kr_7YKSMV+bVA4kxaBsDKb0Eo1_JpzQ@mail.gmail.com>
Subject: Re: "disk full" on a 5 GB btrfs filesystem, FAQ outdated?
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/30/15, Duncan <1i5t5.duncan@cox.net> wrote:
> Of course you can also try compress-force(=lzo the default
> compression so the =spec isn't required), which should give
> you slightly better performance than zlib, but also a bit
> less efficient compression in terms of size saved.

lzo perf relative to zlib (A very very rough comparison)

Compress/Decompress times: 1/3 - 1/2 (which is significant)
Output Size: %10-20 larger
