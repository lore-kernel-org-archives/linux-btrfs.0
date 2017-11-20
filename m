Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:40938 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751015AbdKTGxs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 01:53:48 -0500
Received: from Vantage.cJ (exmakhina.com [69.70.16.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by zougloub.eu (Postfix) with ESMTPSA id 4F4DFF0ABA7
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 01:48:30 -0500 (EST)
Date: Mon, 20 Nov 2017 01:54:50 -0500
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Issues while doing btrfs delete missing in raid6
Message-ID: <20171120015450.03b6beea@Vantage.cJ>
In-Reply-To: <20171120014344.7a5d8bd2@Vantage.cJ>
References: <20171120014344.7a5d8bd2@Vantage.cJ>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 20 Nov 2017 01:43:44 -0500
Jérôme Carretero <cJ-ko@zougloub.eu> wrote:

> Hi,
> 
> 
> While doing a test (to evaluate drives), where I'm filling a bunch of
> drives in RAID6, one of the disks failed in the process.
> (System with v4.14 / ECC).
> I remounted the array in degraded, launched a "btrfs delete missing"
> as I have no replacement device.
> 
> The command (takes ages and) fails with:
>  ERROR: error removing device 'missing': Input/output error

> Since this is RAID6, I wasn't expecting to not be able to recover
> from a checksum issue, also it's not very practical to bail out on
> the first error of this kind during a delete... the offending blocks
> could be left as is.

While doing a "tar c /mnt/test | pv >/dev/null" I see the csum errors,
but they are corrected then.
I guess I'll try to scrub and see. But there's probably a bug, if
delete/replace/balance can't do that.


Regards,

-- 
Jérôme

