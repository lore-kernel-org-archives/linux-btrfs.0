Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:52924 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3EILFv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 07:05:51 -0400
Received: by mail-lb0-f176.google.com with SMTP id v20so2900444lbc.35
        for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 04:05:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <kmfsnb$bu1$1@ger.gmane.org>
References: <kmfsnb$bu1$1@ger.gmane.org>
From: Harald Glatt <mail@hachre.de>
Date: Thu, 9 May 2013 13:05:29 +0200
Message-ID: <CAFWF=anFPQ2_xoemP=Eja+mANbzHjtaTm4tg=4WgdJ=yxB_i1w@mail.gmail.com>
Subject: Re: How many subvols/snapshots are possible? (limits?)
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can only speak from experience, a snapshot can take up to a minute
to create later on, so minutely snapshots are out of the question
then... I have snapshots every hour and I have no problems with that
at all :)

On Thu, May 9, 2013 at 12:10 PM, Martin <m_btrfs@ml1.co.uk> wrote:
> Dear Devs,
>
> This is more a use case question of what is a good idea to do...
>
>
> Can btrfs support snapshots of the filesystem at very regular intervals,
> say minute by minute or even second by second?
>
> Or are there limits that will be hit with metadata overheads or
> links/reference limits or CPU overheads if 'too many' snapshots/subvols
> are made?
>
> If snapshots were to be taken once a minute and retained, what breaks first?
>
>
> What are 'reasonable' (maximum) numbers for frequency and number of held
> versions?
>
>
> Thanks,
> Martin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
