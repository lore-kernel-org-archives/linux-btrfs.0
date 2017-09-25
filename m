Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:40760 "EHLO
        smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751336AbdIYJLQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 05:11:16 -0400
Received: from smtp12.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp12.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 95A0DC02F0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 05:11:15 -0400 (EDT)
Received: by smtp12.relay.ord1c.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id 3D3EEC02F1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 05:11:15 -0400 (EDT)
From: Marat Khalili <mkh@rqc.ru>
Subject: Re: [PATCH] btrfs-progs: subvolume: outputs message only when
 operation succeeds
To: linux-btrfs@vger.kernel.org
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
 <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
 <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
 <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>
 <20170925075250.GC25529@carfax.org.uk>
Message-ID: <623eb691-a20a-0a78-7b22-ec2f800fc7ac@rqc.ru>
Date: Mon, 25 Sep 2017 12:11:15 +0300
MIME-Version: 1.0
In-Reply-To: <20170925075250.GC25529@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/09/17 10:52, Hugo Mills wrote:

> Isn't the correct way to catch the return value instead of grepping
> the output?
>     It is, but if, for example, you're using the command in a cron
> script which is expected to work, you don't want it producing output
> because then you get a mail every time the script runs. So you have to
> grep -v on the "success" output to make the successful script silent.
>
>> If it's some command not returning value properly, would you please
>> report it as a bug so we can fix it.
>     It's not the return value that's problematic (although those used
> to be a real mess). It's the fact that a successful run of the command
> produces noise on stdout, which most commands don't.
Yes, exactly: cron, mail -E and just long scripts where btrfs operations 
are small steps here and there.

(On top of this, actually catching the return value from the right 
command before `| grep -v` with errexit and pipefail on is so difficult 
that I usually end up rewriting whole mess in Python. Which would be 
nice result in itself if it didn't take a whole day in place of one 
minute for bash line.)

--

With Best Regards,
Marat Khalili

