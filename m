Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp129.dfw.emailsrvr.com ([67.192.241.129]:35832 "EHLO
        smtp129.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964930AbdEWHig (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 03:38:36 -0400
Received: from smtp29.relay.dfw1a.emailsrvr.com (localhost [127.0.0.1])
        by smtp29.relay.dfw1a.emailsrvr.com (SMTP Server) with ESMTP id 32F1B400FF
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 03:38:35 -0400 (EDT)
Received: by smtp29.relay.dfw1a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id BC425400F6
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 03:38:34 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id C34619984
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 07:38:32 +0000 (UTC)
Subject: Re: QGroups Semantics
From: Marat Khalili <mkh@rqc.ru>
To: BTRFS ML <linux-btrfs@vger.kernel.org>
References: <CAMp4zn8CfdzPn7UAHf7S2PT1F8ysf95jMi7F8RBUuyBvqYT5xw@mail.gmail.com>
 <c2e1824a-b395-53da-8cd2-cade09449313@cn.fujitsu.com>
 <CAMp4zn-oFVhrM6C4U-z9EQa1HXw-yzTLRyVoHfati-dX1WVU5Q@mail.gmail.com>
 <8eae0dd5-10df-7fa7-966c-4517e615eafc@rqc.ru>
Message-ID: <687cbccd-926a-f293-24bc-3e46616a4646@rqc.ru>
Date: Tue, 23 May 2017 10:38:32 +0300
MIME-Version: 1.0
In-Reply-To: <8eae0dd5-10df-7fa7-966c-4517e615eafc@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hit "Send" a little too early:

> More complete workaround would be delayed cleanup. What about 
> (re-)mount time? (Should also handle qgroups remaining 
... after subvolumes deleted on previous kernels.)

--

With Best Regards,
Marat Khalili

On 23/05/17 08:38, Marat Khalili wrote:
> Just some user's point of view:
>
>> I propose the following changes:
>> 1) We always cleanup level-0 qgroups by default, with no opt-out.
>> I see absolutely no reason to keep these around.
>
> It WILL break scripts that try to do this cleanup themselves. OTOH it 
> will simplify writing new ones.
>
> Since qgroups are assigned sequential numbers, it must be possible to 
> partially work it around by not returning error on repeated delete. 
> But you cannot completely emulate qgroup presence without actually 
> keeping it, so some scripts will still break.
>
> More complete workaround would be delayed cleanup. What about 
> (re-)mount time? (Should also handle qgroups remaining )
>
>>   We do not allow the creation of level-0 qgroups for (sub)volumes
>> that do not exist.
>
> Probably I'm mistaken, but I see no reasons for doing it even now, 
> since I don't think it's possible to reliably assign existing 0-level 
> qgroup to a new subvolume. So this change should break nothing.
>
>>>> Why do we allow deleting a level 0 qgroup for a currently existing
>>>> subvolume?
>> 4) Add a flag to the qgroup_delete_v2 ioctl, NO_SUBVOL_CHECK.
>> If the flag is present, it will allow you to delete qgroups which
>> reference active subvolumes.
>
> Some people doing cleanup in the reverse order? Other than this, I 
> don't understand why this feature is needed, so IMO it's unlikely to 
> be needed in a new API.
>
> Of course, this is all just one datapoint for you.
>
> -- 
>
> With Best Regards,
> Marat Khalili
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

