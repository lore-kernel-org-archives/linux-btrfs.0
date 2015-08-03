Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:36324 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbbHCNMG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 09:12:06 -0400
Received: by ykeo23 with SMTP id o23so12662982yke.3
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 06:12:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSj08YcrUTZqcO4gXb_VT5yYoxb5yy8XTUxpiwBn=mFLg@mail.gmail.com>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
	<CAJCQCtSj08YcrUTZqcO4gXb_VT5yYoxb5yy8XTUxpiwBn=mFLg@mail.gmail.com>
Date: Mon, 3 Aug 2015 09:12:04 -0400
Message-ID: <CAP5+4qd1KNrJdW-PfLot6U=m2jZKznOxqhabHrWDWqa0xWK+cA@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Sonic <sonicsmith@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 3, 2015 at 1:42 AM, Chris Murphy <lists@colorremedies.com> wrote:
> I can't tell what the data and metadata profile are? That it won't
> mount degraded makes me think the metadata is not explicitly raid1;
> and it either raid0 or accidentally single or dup which can happen at
> mkfs time on single device

It's been a long time since I created the two disk array but I'm sure
it's raid 0 and it may be single but my memory fails me on that point.
