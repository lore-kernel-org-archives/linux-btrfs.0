Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:44167 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaFZUq6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 16:46:58 -0400
Received: by mail-ve0-f178.google.com with SMTP id oy12so4394910veb.9
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 13:46:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56CE0D0C-EE96-4CBC-B7CB-FC42CA1B01DF@colorremedies.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
	<2316027.LZEnVG8laK@xev>
	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
	<CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
	<53A6DDAD.8070804@chinilu.com>
	<99AD3EFE-AF9A-44A1-912E-07B1E934239B@colorremedies.com>
	<pan$600a2$3927cc39$ae007590$e90b8415@cox.net>
	<yq1bntjizkr.fsf@sermon.lab.mkp.net>
	<CAK5rZE4Eo+e_wbyzqPauYO=9HC9CEEF8Dftnw0D6zr1+7Z+GBw@mail.gmail.com>
	<56CE0D0C-EE96-4CBC-B7CB-FC42CA1B01DF@colorremedies.com>
Date: Thu, 26 Jun 2014 22:46:57 +0200
Message-ID: <CAK5rZE5VEKJbt7JJpOPD48sZMZPwLgiQC869+hy3toU+0HCKCA@mail.gmail.com>
Subject: Re: btrfs on whole disk (no partitions)
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/26/14, Chris Murphy <lists@colorremedies.com> wrote:
> On Jun 25, 2014, at 7:01 AM, Imran Geriskovan <imran.geriskovan@gmail.com>
>> There are SSDs with 4K, 8K block/page sizes and
>> 512K, 1M, 1.5M Erase block sizes.
>> Partitions should be aligned with Erase blocks.

> That sounds plausible, but the FTL in the consumer SSD's most all of us are
> buying isn't going to give you any assurance it's actually writing with such
> boundaries in mind. You may have partition 1 start on LBA 2048, which is 1MB
> aligned, but as soon as you're writing data to LBA 2048 through say LBA
> 2560, for all you know that write actually ends up in pages that are located
> in the first and second erase blocks; or maybe all of it's in the 8th erase
> block. The OS side of things we don't have insight or control over this.

8 Logical blocks (Not 8 Erase blocks) makes a 4K Physical block.

(a) Basic principle is to align with "Physical blocks" ("Pages" for SSDs).
(b) For SSDs, aligning with Erase blocks (512K, 1M, 1.5M) also satisfy (a)

Regards, Imran
