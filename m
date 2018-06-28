Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0055.outbound.protection.outlook.com ([104.47.116.55]:36148
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751630AbeF1Haw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 03:30:52 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH RFC] btrfs: Do extra device generation check at mount time
Date: Thu, 28 Jun 2018 07:30:48 +0000
Message-ID: <MEXPR01MB12087412F5E0B4FD936124359E4F0@MEXPR01MB1208.ausprd01.prod.outlook.com>
References: <20180628070443.23421-1-wqu@suse.com>
 <c5fc1287-cf27-75c0-3175-33d71014fe78@suse.com>
 <55c3e4a3-c7c4-0f4b-9767-7eeccd733cae@gmx.com>
In-Reply-To: <55c3e4a3-c7c4-0f4b-9767-7eeccd733cae@gmx.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org <linux-btrfs-
> owner@vger.kernel.org> On Behalf Of Qu Wenruo
> Sent: Thursday, 28 June 2018 5:16 PM
> To: Nikolay Borisov <nborisov@suse.com>; Qu Wenruo <wqu@suse.com>;
> linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount
> time
> 
> 
> 
> On 2018å¹´06æœˆ28æ—¥ 15:06, Nikolay Borisov wrote:
> >
> >
> > On 28.06.2018 10:04, Qu Wenruo wrote:
> >> There is a reporter considering btrfs raid1 has a major design flaw
> >> which can't handle nodatasum files.
> >>
> >> Despite his incorrect expectation, btrfs indeed doesn't handle device
> >> generation mismatch well.
> >>
> >> This means if one devices missed and re-appeared, even its generation
> >> no longer matches with the rest device pool, btrfs does nothing to
> >> it, but treat it as normal good device.
> >>
> >> At least let's detect such generation mismatch and avoid mounting the
> >> fs.
> >> Currently there is no automatic rebuild yet, which means if users
> >> find device generation mismatch error message, they can only mount
> >> the fs using "device" and "degraded" mount option (if possible), then
> >> replace the offending device to manually "rebuild" the fs.
> >>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >
> > I think a testcase of this functionality is important as well.
> 
> It's currently an RFC patch, test case would come along with final version.
> 
> I'd like to make sure everyone, including developers and end-users, are fine
> with the restrict error-out behavior.

I've been bitten by this before and was most surprised the first time it happened. I had assumed that of course btrfs would check such a thing before mounting.
Refusing to mount is a great first step, auto scrub is even better, and only "scrubbing" files with incorrect generation is better yet.

Paul.



 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
