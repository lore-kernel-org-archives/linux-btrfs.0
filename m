Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:39754 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaK2VAl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 16:00:41 -0500
Received: by mail-qg0-f43.google.com with SMTP id q108so6102665qgd.30
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 13:00:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m5dash$58v$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<20141125163905.GJ26471@twin.jikos.cz>
	<m5dash$58v$1@ger.gmane.org>
Date: Sat, 29 Nov 2014 13:00:40 -0800
Message-ID: <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 29, 2014 at 12:38 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
> Why not just use the kernel crypto API? Then the user can just specify any
> hash the kernel supports.

One reason is that crytographic hashes are an order of magnitude
slower than the fastest non-cryptographic hashes. And for filesystem
checksums, I do not see a need for crypotgraphic hashes.
