Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:23722 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbcEIM7b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 08:59:31 -0400
Subject: Re: btrfs goes readonly + No space left on 4.3
To: Omar Sandoval <osandov@osandov.com>
References: <561B5AA6.7040704@profihost.ag> <5723C88F.30903@profihost.ag>
 <20160502220549.GB24432@vader.DHCP.thefacebook.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <573089AD.6090108@profihost.ag>
Date: Mon, 9 May 2016 14:59:25 +0200
MIME-Version: 1.0
In-Reply-To: <20160502220549.GB24432@vader.DHCP.thefacebook.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 03.05.2016 um 00:05 schrieb Omar Sandoval:
> On Fri, Apr 29, 2016 at 10:48:15PM +0200, Stefan Priebe wrote:
>> just want to drop a note that all those ENOSPC msg are gone with v4.5 and
>> space_cache=v2. Any plans to make space_cache=v2 default?
>>
>> Greets,
>> Stefan
> 
> Yup, we want to make space_cache=v2 the default at some point. I'm
> running it on my own machines and testing it here at Facebook and
> haven't run into any issues yet. Besides stability, I also want to make
> sure there aren't any performance regressions versus the old free space
> cache that we haven't thought about yet.
> 
> Thanks for trying it out :)

Can i patch v2 as a default for me? I just looked at the code but didn't
find an easy way to make v2 the default.

Greets,
Stefan
