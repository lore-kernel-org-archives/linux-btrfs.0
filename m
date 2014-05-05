Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61239 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaEESgN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 14:36:13 -0400
Received: by mail-ie0-f174.google.com with SMTP id ar20so8275024iec.5
        for <linux-btrfs@vger.kernel.org>; Mon, 05 May 2014 11:36:12 -0700 (PDT)
Message-ID: <1399314969.4155.1.camel@sasami>
Subject: Re: Please review and comment, dealing with btrfs full issues
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Date: Mon, 05 May 2014 14:36:09 -0400
In-Reply-To: <5367C551.6020604@swiftspirit.co.za>
References: <20140505121603.GO10159@merlins.org>
	 <5367C551.6020604@swiftspirit.co.za>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-05-05 at 19:07 +0200, Brendan Hide wrote:
> On 05/05/14 14:16, Marc MERLIN wrote:
> > I've just written this new page:
> > http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
> >
> > First, are there problems in it?
> >
> > Second, are there other FS full issues I should mention in it?
> >

> The issue I'm not sure of how to get through is if you can't balance 
> *because* of ENOSPC errors. I'd probably start scouring the mailing list 
> archives if I ever come across that.

The standard response on the mailing list for this issue is to
temporarily add an additional device to the filesystem (even e.g. a 4GB
USB flash drive is often enough) - this will add space to allocate a few
new chunks, allowing the balance to proceed. You can remove the extra
device after the balance completes.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

