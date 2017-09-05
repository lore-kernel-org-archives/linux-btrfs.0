Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36149 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752756AbdIESdN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Sep 2017 14:33:13 -0400
From: Nick Terrell <terrelln@fb.com>
To: Adam Borowski <kilobyte@angband.pl>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>, Timofey Titovets <nefelim4ag@gmail.com>
Subject: Re: \o/ compsize
Date: Tue, 5 Sep 2017 18:32:59 +0000
Message-ID: <4A120838-61E4-4495-BBED-9AC4479D6D98@fb.com>
References: <20170904151154.vkhshc57t2mi2sze@angband.pl>
In-Reply-To: <20170904151154.vkhshc57t2mi2sze@angband.pl>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/4/17, 8:12 AM, "Adam Borowski" <kilobyte@angband.pl> wrote:
> Hi!
> Here's an utility to measure used compression type + ratio on a set of files
> or directories: https://github.com/kilobyte/compsize
> 
> It should be of great help for users, and also if you:
> * muck with compression levels
> * add new compression types
> * add heurestics that could err on withholding compression too much

Thanks for writing this tool Adam, I'll try it out with zstd! It looks very
useful for benchmarking compression algorithms, much better than measuring
the filesystem size with du/df.

> (Thanks for Knorrie and his python-btrfs project that made figuring out the
> ioctls much easier.)
> 
> Meow!
> -- 
> â¢€â£´â ¾â »â¢¶â£¦â € 
> â£¾â â¢°â ’â €â£¿â¡ Vat kind uf sufficiently advanced technology iz dis!?
> â¢¿â¡„â ˜â ·â šâ ‹â €                                 -- Genghis Ht'rok'din
> â ˆâ ³â£„â €â €â €â € 
> 
 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
