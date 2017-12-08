Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0048.outbound.protection.outlook.com ([104.47.116.48]:13841
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753065AbdLHXkr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 18:40:47 -0500
From: Paul Jones <paul@pauljones.id.au>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Anand Jain <anand.jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH RFC] btrfs: self heal from SB fail
Date: Fri, 8 Dec 2017 23:40:44 +0000
Message-ID: <SYXPR01MB2173A82447BB496E7B3D0FFF9E300@SYXPR01MB2173.ausprd01.prod.outlook.com>
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
In-Reply-To: <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Austin S. Hemmelgarn
> Sent: Friday, 8 December 2017 11:51 PM
> To: Anand Jain <anand.jain@oracle.com>; linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
> 
> On 2017-12-08 02:57, Anand Jain wrote:
> > -EXPERIMENTAL-
> > As of now when primary SB fails we won't self heal and would fail
> > mount, this is an experimental patch which thinks why not go and read
> > backup copy.
> I like the concept, and actually think this should be default behavior on a
> filesystem that's already mounted (we fix other errors, why not SB's), but I
> don't think it should be default behavior at mount time for the reasons Qu
> has outlined (picking up old BTRFS SB's after reformatting is bad).  However, I
> do think it's useful to be able to ask for this behavior on mount, so that you
> don't need to fight with the programs to get a filesystem to mount when the
> first SB is missing (perhaps add a 'usebackupsb' option to mirror
> 'usebackuproot'?).

I agree with this. The behaviour I'd like to see would be refusal to mount (without additional mount options) but also: print the needed info to the kernel log so the user can add the required mount option or read the wiki for more information, and print some diagnostic info on the primary + secondary super blocks.

Paul.






ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
