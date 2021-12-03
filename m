Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AD8C433EF
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Dec 2021 08:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351072AbhLCIU2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 Dec 2021 03:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238936AbhLCIU2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Dec 2021 03:20:28 -0500
Received: from mail.virtall.com (mail.virtall.com [IPv6:2a01:4f8:141:216f::203])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FD1C06173E
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Dec 2021 00:17:04 -0800 (PST)
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id E0B509975AA0;
        Fri,  3 Dec 2021 08:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wpkg.org; s=default;
        t=1638519422; bh=We2/35FLG5VYTkgG50yCYAdxLj4/sZyJM0r3RYNld6s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=S+cJLucu5drRIaZDfCUOSNUxQs4zhgOik4Rh+Btssl66JEr0f34My98fvI8Ct88cX
         7cS8QBuS/kWKaWL+M3A0RZWRhavs7FG9jvITYAES/db11rOe0wY6AsUczh+oFAdan1
         XnNtYsmsvw+TckQ+b0IrRvXhObz8HL0vlx+/2yMOK4LQ/Sc42kpppYGfG6rjg5qzB1
         n8i4X/nmcW97WyJVBhscs8j9Y/aIB793Ubgif2gbrGoEZZZcx9vh0sy4iglP/phe91
         q5BVkQNRydgnQWubkqC3tdjwBSUyCD60SjYuHvBrH6tU4JQy+P+zbwlGxsQIq/wDmT
         jpXNpRr2V3CmA==
X-Fuglu-Suspect: d5d9e6ed355a4b248bb5a56d17df6648
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA;
        Fri,  3 Dec 2021 08:17:00 +0000 (UTC)
MIME-Version: 1.0
Date:   Fri, 03 Dec 2021 09:16:59 +0100
From:   Tomasz Chmielewski <mangoo@wpkg.org>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: kworker/u32:5+btrfs-delalloc using 100% CPU
In-Reply-To: <PH0PR04MB7416465C59F5F339FA87AB839B6A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <c5af7d3735e68237fbd49a2ae69a7e7f@wpkg.org>
 <PH0PR04MB7416465C59F5F339FA87AB839B6A9@PH0PR04MB7416.namprd04.prod.outlook.com>
Message-ID: <93111e00ad2e42738d65d426f82ad17f@wpkg.org>
X-Sender: mangoo@wpkg.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2021-12-03 09:09, Johannes Thumshirn wrote:
> On 03/12/2021 00:23, Tomasz Chmielewski wrote:
>> On two of my servers running Linux 5.15.5 I can observe
>> kworker/u32:5+btrfs-delalloc process using 100% CPU.
>> 
>> The servers receive files with rsync and I suspect that because of 
>> that
>> process using 100% CPU, the speed is very slow, less than 1 MB/s over 
>> a
>> gigabit network.
>> 
> 
> Hi,
> 
> We're currently working on a similar hang with btrfs on zoned
> block devices. Which brings me to the question, are you seeing this 
> issues
> on a zoned device, like an SMR drive, or on a regular device?

It's a regular HDD.


Tomasz
