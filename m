Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oln040092068064.outbound.protection.outlook.com ([40.92.68.64]:20820
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966488AbeF1OfB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 10:35:01 -0400
From: Alberto Bursi <alberto.bursi@outlook.it>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount time
Date: Thu, 28 Jun 2018 14:34:58 +0000
Message-ID: <VI1PR08MB086262F7BE2EFD778F0A415A924F0@VI1PR08MB0862.eurprd08.prod.outlook.com>
References: <20180628070443.23421-1-wqu@suse.com>
In-Reply-To: <20180628070443.23421-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28/06/2018 09:04, Qu Wenruo wrote:
> Despite his incorrect expectation, btrfs indeed doesn't handle device
> generation mismatch well.
>
> This means if one devices missed and re-appeared, even its generation
> no longer matches with the rest device pool, btrfs does nothing to it,
> but treat it as normal good device.
>
> At least let's detect such generation mismatch and avoid mounting the
> fs.
> Currently there is no automatic rebuild yet, which means if users find
> device generation mismatch error message, they can only mount the fs
> using "device" and "degraded" mount option (if possible), then replace
> the offending device to manually "rebuild" the fs.
>

Yes. This is a long-standing issue, handling it this way is similar to 
what mdadm
(software raid) also does.

Please get this merged fast, don't get bogged down too much with 
integrating with
Anand Jain's branch as this is a big issue and should get at least this 
basic mitigation asap.

-Alberto
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
