Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45472 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754670AbaHKUaa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 16:30:30 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [BUG] btrfs send/receive, page allocation failure
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <6316ceac72f53e0500b28f60ef280ad6@colorremedies.com>
Date: Mon, 11 Aug 2014 14:30:28 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <91397890-7031-41AD-8700-B1341D178B3F@colorremedies.com>
References: <2BBB0EBF-DD55-45B4-8BF5-F8DAA9398A4F@colorremedies.com> <CF539008-5930-447D-B26C-2A2BBE9337EA@colorremedies.com> <CAL3q7H591BbVenxFn_EiBDyqmJEcwgOKjw0Xv2J+jkgic+3dxQ@mail.gmail.com> <16C9BBD0-FD7B-488B-A77F-E937007F292F@colorremedies.com> <CAL3q7H5rpoPFBKjLD9F0_4UdBcG8BgzKUQGGTzbmBmdkG2_Jwg@mail.gmail.com> <51F1A674-280C-4AF9-93BD-82B38F8E9C92@colorremedies.com> <CAL3q7H7MfE84dgfS==HbKE5N9_MiznYM5B6gMN7xQjX5nhKE0Q@mail.gmail.com> <A0E5F699-0F52-4CD4-B60E-42010C6C3361@colorremedies.com> <6316ceac72f53e0500b28f60ef280ad6@colorremedies.com>
To: "fdmanana@gmail.com" <fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 11, 2014, at 10:41 AM, lists@colorremedies.com wrote:
>>> 
>>> https://friendpaste.com/Bgwdjk31P3pZHtArr341G
>> OK that friendpaste is completely different than the [PATCH v4] email.
>> # from above URL
>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>> index 6528aa6..95891c0 100644


I can confirm that the above patch fixes the reported bug. 

I couldn't get this one to apply so it's not tested:
http://www.spinics.net/lists/linux-btrfs/msg36556.html


Chris Murphy
