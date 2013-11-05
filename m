Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:35003 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3KECDd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 21:03:33 -0500
Received: by mail-ie0-f170.google.com with SMTP id at1so14178360iec.15
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 18:03:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52780E20.8020405@friedels.name>
References: <52742B59.3060405@friedels.name>
	<CAE5mzvijfSOi9dP0MWCMd6=R5MW3bhabote4QYmFnqNEerDifw@mail.gmail.com>
	<5274BEC8.5060804@friedels.name>
	<52780E20.8020405@friedels.name>
Date: Mon, 4 Nov 2013 20:03:32 -0600
Message-ID: <CAE5mzvgrKqrv3LpmiF6iUK=GYsnGOQnSwLTM0dSfBE8ZP-4AuA@mail.gmail.com>
Subject: Re: btrfsck errors is it save to fix?
From: cwillu <cwillu@cwillu.com>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 4, 2013 at 3:14 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello,
>
> the list was quite full with patches, so this might have been hidden.
> Here the complete Stack.
> Does this help? Is this what you needed?
>> [95764.899294] CPU: 1 PID: 21798 Comm: umount Tainted: GF        CIO
>> 3.11.0-031100rc2-generic #201307211535

Can you reproduce the problem under the released 3.11 or 3.12?  An
-rc2 is still pretty early in the release cycle, and I wouldn't be at
all surprised if it was a bug added and fixed in a later rc.
