Return-Path: <SRS0=OHkO=4B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B710CC2BA83
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 14:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 950F920873
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 14:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgBMOPC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 09:15:02 -0500
Received: from mail.itouring.de ([188.40.134.68]:59470 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730079AbgBMOPB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Feb 2020 09:15:01 -0500
Received: from tux.applied-asynchrony.com (p5B07E2B3.dip0.t-ipconnect.de [91.7.226.179])
        by mail.itouring.de (Postfix) with ESMTPSA id 1D5FF416C483;
        Thu, 13 Feb 2020 15:15:00 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id C8857F01601;
        Thu, 13 Feb 2020 15:14:59 +0100 (CET)
Subject: Re: tree-checker read time corruption
To:     telsch <telsch@gmx.de>, linux-btrfs@vger.kernel.org
References: <5b974158-4691-c33e-71a7-1e5417eb258a@gmx.de>
 <e35d0318-4d3e-50ce-55b1-178e235e89d7@gmx.com>
 <14db7da5-dc42-90e6-0743-b656ff42a976@gmx.de>
 <5037cdd7-8d10-bc2b-195d-59c5929c0c50@gmx.com>
 <d250e7c2-76d4-1369-e440-c72370035842@gmx.de>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <02ee0b77-d04f-4fa0-e750-cfbe598f2cfa@applied-asynchrony.com>
Date:   Thu, 13 Feb 2020 15:14:59 +0100
MIME-Version: 1.0
In-Reply-To: <d250e7c2-76d4-1369-e440-c72370035842@gmx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/13/20 3:02 PM, telsch wrote:
>> According to the repair log, btrfs-progs doesn't detect it at all.
>> Thus I'm not sure if it's a bug in btrfs-progs or it's just not newer
>> enough.
>>
>> Anyway, you can delete inode 265 manually using older kernel.
>>
>> Thanks,
>> Qu
> 
> Thanks for support. Deleting inode 265 manually fixed this mount issue
> with kernel >= 5.2 for me.

Btw the patches to fix up invalid generations that Qu referred to are
in btrfs-progs-5.4.*1*, not 5.4.

-h
