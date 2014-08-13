Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:47694 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaHMN1N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 09:27:13 -0400
Received: by mail-vc0-f181.google.com with SMTP id lf12so14741272vcb.40
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:27:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2364156.aMAqnATvIX@merkaba>
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com>
	<2364156.aMAqnATvIX@merkaba>
Date: Wed, 13 Aug 2014 09:27:12 -0400
Message-ID: <CAGfcS_mb7pOGruy4=aeHGrT=gpuvw7tdXhJyp13Q0refCXDAgw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix task hang under heavy compressed write
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, miaox@cn.fujitsu.com,
        Marc MERLIN <marc@merlins.org>,
        =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 13, 2014 at 7:54 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Dienstag, 12. August 2014, 15:44:59 schrieb Liu Bo:
>> This has been reported and discussed for a long time, and this hang occurs
>> in both 3.15 and 3.16.
>
> Liu, is this safe for testing yet?
>

I'm more than happy to test this an re-enable lzo (I've been running
fine on 3.16 with it disabled, but had numerous issues when it was
enabled on 3.15 and the rcs).  It would just be helpful to clarify
exactly what patch we should be testing, and what kernel we should
test it against to be most helpful.  No sense generating issue reports
that aren't useful.

Rich
