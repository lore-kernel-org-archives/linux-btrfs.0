Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:46046 "EHLO
        smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752729AbdC2Fxz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 01:53:55 -0400
Received: from smtp6.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp6.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 1690D5367
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Mar 2017 01:53:54 -0400 (EDT)
Received: by smtp6.relay.iad3a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id BD1D15343
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Mar 2017 01:53:53 -0400 (EDT)
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: linux-btrfs@vger.kernel.org
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
 <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
 <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
 <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
 <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
 <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
 <CAJCQCtRikr0CaYRj1rQid-UPukNm6NXem_8QD_e-VZYoZ3HPWA@mail.gmail.com>
 <11740657-b2f9-36ab-9644-df2db29dd174@gmail.com>
 <1c8a021b-d258-3a50-3104-d898662c4375@rqc.ru>
 <8c87b1fb-c7ba-5494-0ecd-b692637cdd54@gmail.com>
 <ecf7f048-65f9-3f81-76c1-61528859ddc3@rqc.ru>
 <9038f785-90c2-2e68-1c7f-4b53e8b9e4c5@gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <c4f1afbb-857e-87fe-eeea-a76ee5488117@rqc.ru>
Date: Wed, 29 Mar 2017 08:53:51 +0300
MIME-Version: 1.0
In-Reply-To: <9038f785-90c2-2e68-1c7f-4b53e8b9e4c5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> If we were going to reserve something, it should be a high number, not 
> a low one.  Having 0 reserved makes some sense, but reserving other 
> low numbers seems kind of odd when they aren't already reserved. 

I did some experiments.

Currently assigning higher-level qgroup to lower-level qgroup is not 
possible. Consequently, assigning anything to 0-level qgroup is not 
possible.

On the other hand, assigning qgroups while skipping levels (e.g. qgroup 
2/P to 10/Q) is possible. So setting default snapshot level high is 
technically possible, but you'll not be able to assign these high-level 
qgroups anywhere low later.


> although I hadn't realized that the snapshot command _does not_ have 
> this argument, when it absolutely should. 
It does here in 4.4, it's just not documented :) I too found it by accident.


> Perhaps have an option
Options always suit everyone except developers who need to implement and 
support them :)

Here I'd like to wrap up since I seriously doubt any real btrfs 
developers are still reading our discussion :)

--

With Best Regards,
Marat Khalili

