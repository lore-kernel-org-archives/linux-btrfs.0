Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0096.outbound.protection.outlook.com ([104.47.2.96]:60237
	"EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751468AbcG2NrQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 09:47:16 -0400
From: =?utf-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs send to send out metadata and data separately
Date: Fri, 29 Jul 2016 13:14:44 +0000
Message-ID: <8930800.y3r4nzIv9U@libor-nb>
References: <07e7aea4-ebc7-1c47-34fb-daaae42ab245@gmx.com>
In-Reply-To: <07e7aea4-ebc7-1c47-34fb-daaae42ab245@gmx.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

just a little question on receiver point 0), see bellow

Dne pÃ¡tek 29. Äervence 2016 20:40:38 CEST, Qu Wenruo napsal(a):
> Hi Filipe, and maintainers,
> 
> Receive will do the following thing first before recovering the
> subvolume/snapshot:
> 
> 0) Create temporary dir for data extents
>     Create a new dir with temporary name($data_extent), to put data
> extents into it.

These are the directories in format "o4095916-21925-0" on receiver side?

I'm in middle of send/receive and i have over 300 thousand of them already.
I was always told, that directory with lots of items suffers on performance 
(but i newer used btrfs before :), is that true?

Should it be little structured (subdirs based on extent number, for example) ?

Libor
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
