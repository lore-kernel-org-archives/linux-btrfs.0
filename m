Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:46793 "EHLO
        smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758118AbdEWFiz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 01:38:55 -0400
Received: from smtp4.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp4.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 4C3F25600
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 01:38:54 -0400 (EDT)
Received: by smtp4.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id E50DE42EA
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 01:38:53 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id 76D139595
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 05:38:51 +0000 (UTC)
Subject: Re: QGroups Semantics
References: <CAMp4zn8CfdzPn7UAHf7S2PT1F8ysf95jMi7F8RBUuyBvqYT5xw@mail.gmail.com>
 <c2e1824a-b395-53da-8cd2-cade09449313@cn.fujitsu.com>
 <CAMp4zn-oFVhrM6C4U-z9EQa1HXw-yzTLRyVoHfati-dX1WVU5Q@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
To: BTRFS ML <linux-btrfs@vger.kernel.org>
Message-ID: <8eae0dd5-10df-7fa7-966c-4517e615eafc@rqc.ru>
Date: Tue, 23 May 2017 08:38:51 +0300
MIME-Version: 1.0
In-Reply-To: <CAMp4zn-oFVhrM6C4U-z9EQa1HXw-yzTLRyVoHfati-dX1WVU5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just some user's point of view:

> I propose the following changes:
> 1) We always cleanup level-0 qgroups by default, with no opt-out.
> I see absolutely no reason to keep these around.

It WILL break scripts that try to do this cleanup themselves. OTOH it 
will simplify writing new ones.

Since qgroups are assigned sequential numbers, it must be possible to 
partially work it around by not returning error on repeated delete. But 
you cannot completely emulate qgroup presence without actually keeping 
it, so some scripts will still break.

More complete workaround would be delayed cleanup. What about (re-)mount 
time? (Should also handle qgroups remaining )

>   We do not allow the creation of level-0 qgroups for (sub)volumes
> that do not exist.

Probably I'm mistaken, but I see no reasons for doing it even now, since 
I don't think it's possible to reliably assign existing 0-level qgroup 
to a new subvolume. So this change should break nothing.

>>> Why do we allow deleting a level 0 qgroup for a currently existing
>>> subvolume?
> 4) Add a flag to the qgroup_delete_v2 ioctl, NO_SUBVOL_CHECK.
> If the flag is present, it will allow you to delete qgroups which
> reference active subvolumes.

Some people doing cleanup in the reverse order? Other than this, I don't 
understand why this feature is needed, so IMO it's unlikely to be needed 
in a new API.

Of course, this is all just one datapoint for you.

--

With Best Regards,
Marat Khalili
