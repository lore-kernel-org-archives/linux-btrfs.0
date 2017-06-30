Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44585 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751919AbdF3Twg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 15:52:36 -0400
From: Nick Terrell <terrelln@fb.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
CC: Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.cz>,
        "squashfs-devel@lists.sourceforge.net"
        <squashfs-devel@lists.sourceforge.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Add xxhash and zstd modules
Date: Fri, 30 Jun 2017 19:52:10 +0000
Message-ID: <8C0B630F-01E0-459E-BAD6-44F8A68E1858@fb.com>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <CAGqmi756nPi82aXkt-7ET6MCCXSBuneRFYYTvvcRH3q6F471SA@mail.gmail.com>
In-Reply-To: <CAGqmi756nPi82aXkt-7ET6MCCXSBuneRFYYTvvcRH3q6F471SA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> If i understood all correctly,
> zstd can compress (decompress) data in way compatible with gzip (zlib)
> Do that also true for in kernel library?

The zstd command line tool can decompress gzip/zlib compressed data, and
can compress in the gzip format. However, the zstd format is not compatible
with zlib, so gzip/zlib cannot decompress zstd compressed data. The zstd
kernel module can only compress and decompress the zstd format, and can't
decompress zlib/gzip compressed data.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
