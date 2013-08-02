Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.200]:59058 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab3HBVMv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Aug 2013 17:12:51 -0400
Received: from mailout-us.gmx.com ([172.19.198.46]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0Lmukq-1UOdNW0b8O-00h3Ye for
 <linux-btrfs@vger.kernel.org>; Fri, 02 Aug 2013 23:12:50 +0200
Cc: sbehrens@giantdisaster.de, zab@redhat.com,
        "David Sterba" <dsterba@suse.cz>
Content-Type: text/plain; charset="utf-8"
Date: Fri, 02 Aug 2013 17:12:49 -0400
From: "Mike Audia" <mikey_a@gmx.com>
Message-ID: <20130802211249.157550@gmx.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] btrfs: add mount option to set commit interval
To: "David Sterba" <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> v2:
> * Stefan pointed out a missing break and that /proc/mounts does not show
>  the option.
> * fixed missing goto and extra printk parameter after failed match_int

Forgive my naive question: I am using gmx's webclient which doesn't seem to identify your patch as an attachment.  I can simply copy/paste into vim and apply the patch.  Is there are more elegant way to obtain the code, a git tree perhaps or ...?

Thank you.
