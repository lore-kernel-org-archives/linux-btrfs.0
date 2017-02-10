Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:55280 "EHLO
        smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751950AbdBJOhz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 09:37:55 -0500
Received: from smtp13.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp13.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 5DE11A0289
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Feb 2017 09:37:17 -0500 (EST)
Received: by smtp13.relay.ord1c.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id 06AC4A0261
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Feb 2017 09:37:16 -0500 (EST)
Subject: Re: partial quota rescan
To: linux-btrfs@vger.kernel.org
References: <f2600743-a0ac-3afe-0597-9081d3cb976e@rqc.ru>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <7f426cd3-2a10-dae6-3bdd-073f3480d003@rqc.ru>
Date: Fri, 10 Feb 2017 17:37:15 +0300
MIME-Version: 1.0
In-Reply-To: <f2600743-a0ac-3afe-0597-9081d3cb976e@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Suddenly discovered undocumented (in man or anywhere) -i parameter of 
'btrfs subvolume snapshot' that adds snapshot to qgroup without 
invalidating statistics. Amazing!

--

With Best Regards,
Marat Khalili

On 08/02/17 18:46, Marat Khalili wrote:
> I'm using  trying to use qgroups to keep track of storage occupied by 
> snapshots. I noticed that:
> a) no two rescans can run in parallel, and there's no way to schedule 
> another rescan while one is running;
> b) seems like it's a whole-disk operation regardless of path specified 
> in CLI.
>
> I only just started to fill my new 24Tb btrfs volume using qgroups, 
> but rescans already take a long time, and due to (a) above I each time 
> have to wait for previous rescan to finish in my scripts. Can anything 
> be done about it, like trashing and recomputing only statistics for 
> specific qgroup?
>
> Linux host 4.4.0-62-generic #83-Ubuntu SMP Wed Jan 18 14:10:15 UTC 
> 2017 x86_64 x86_64 x86_64 GNU/Linux
> btrfs-progs v4.4
>

