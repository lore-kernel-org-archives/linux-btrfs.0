Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:33435 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdF3Qrv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 12:47:51 -0400
MIME-Version: 1.0
In-Reply-To: <20170629194108.1674498-1-terrelln@fb.com>
References: <20170629194108.1674498-1-terrelln@fb.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 30 Jun 2017 19:46:54 +0300
Message-ID: <CAGqmi756nPi82aXkt-7ET6MCCXSBuneRFYYTvvcRH3q6F471SA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Add xxhash and zstd modules
To: Nick Terrell <terrelln@fb.com>
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>,
        squashfs-devel@lists.sourceforge.net,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Nick Terrell,
If i understood all correctly,
zstd can compress (decompress) data in way compatible with gzip (zlib)
Do that also true for in kernel library?
If that true, does that make a sense to directly replace zlib with
zstd (configured to work like zlib) in place (as example for btrfs
zlib decompression/compression code)?

Thanks!

-- 
Have a nice day,
Timofey.
