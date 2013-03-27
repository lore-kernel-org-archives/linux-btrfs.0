Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46468 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3C0VM1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 17:12:27 -0400
Received: by mail-oa0-f46.google.com with SMTP id k1so9307470oag.5
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 14:12:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130327165309.GA23559@merlins.org>
References: <20130327165309.GA23559@merlins.org>
Date: Wed, 27 Mar 2013 16:12:27 -0500
Message-ID: <CAKcLGm98D1H4oMnN8+Sc8tbC8dCh=gwUQL9vw7M1pmQOn78Epw@mail.gmail.com>
Subject: Re: zlib vs lzo uncompress speed, ssd vs nossd
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 27, 2013 at 11:53 AM, Marc MERLIN <marc@merlins.org> wrote:
>
> Is my feeling of slower boot wrong, or is zlib also noticeably slower than
> lzo to read and decompress?
>

Lzo compression should be faster in every aspect than zlib, especially
for reading.

But having said that, btrfs won't recompress any existing files just
because you switch your mount option from lzo to zlib.  Only newly
written files will be zlib, and btrfs will leave the lzo-compressed
files alone unless they are re-written, or you expressly recompress
them using the defrag tool.

If you were to take a snapshot of your root partition, and reboot to
the snapshot as the new root with zlib compression, you could make
some side-by-side comparisons of boot time to clarify your
impressions.
