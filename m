Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:40351 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaACWmL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jan 2014 17:42:11 -0500
Received: by mail-ig0-f175.google.com with SMTP id j1so2241773iga.2
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 14:42:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52C73987.7000106@jrs-s.net>
References: <52C73987.7000106@jrs-s.net>
Date: Sat, 4 Jan 2014 00:42:10 +0200
Message-ID: <CAELSAVZHbYM9+SWWuhCTFiCr22MvOhU=C5Q0+btq6MG-qF-g3A@mail.gmail.com>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
From: Emil Karlson <jekarlson@gmail.com>
To: Jim Salter <jim@jrs-s.net>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> mount -t btrfs /dev/vdb /test
> mount: wrong fs type, bad option, bad superblock on /dev/vdb,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so

IIRC you need mount option degraded here.
