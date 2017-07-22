Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:39438 "EHLO
        smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750750AbdGVGZZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Jul 2017 02:25:25 -0400
Received: from smtp5.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp5.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id AF8B125477
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Jul 2017 02:25:24 -0400 (EDT)
Received: by smtp5.relay.iad3a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id 264482546A
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Jul 2017 02:25:23 -0400 (EDT)
Date: Sat, 22 Jul 2017 09:25:18 +0300
In-Reply-To: <1500663236.2611541.1048467944.0014B72B@webmail.messagingengine.com>
References: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com> <3dd83854-362d-001a-e075-2156931a5cc2@mendix.com> <1500593465.333509.1047657672.4D69CB55@webmail.messagingengine.com> <1500617212.422990.1047894640.3B975261@webmail.messagingengine.com> <6f8c41cc-39a0-270e-0b8b-5debbdf455c9@codepoets.co.uk> <1500663236.2611541.1048467944.0014B72B@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: kernel btrfs file system wedged -- is it toast?
To: linux-btrfs@vger.kernel.org
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <F141B30A-8B05-40D6-B9BF-439007CAFC3F@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> The btrfs developers should have known this, and announced this,
a long time ago, in various prominent ways that it would be difficult
for potential new users to miss. 

I'm also a user like you, and I felt like this too when I came here (BTW there are several traps in BTRFS, and other are causing partial or whole filesystem loss, so you're lucky). There's truth in your words that some warning is needed, but in this open-source business it is not clear who should give it to whom. Developers in the list are actually spending their time on adding such warnings to kernel and command-line tools, but e.g. people using GUI and not reading dmesg over breakfast won't see them anyways. All situation is unfortunate because hardware and OS vendors keep hyping BTRFS and making it default in their products when it is clearly not ready, but you're now talking to and blaming the wrong people.

Personally for me coming to this list was the most helpful thing in understanding BTRFS current state and limitations. I'm still using it, although in a very careful and controlled manner. But browsing the list every day sadly takes time. If you can't afford it or are running something absolutely critical, better look to other, more mature filesystems. After all, as adage says: "legacy is what we run in production".
-- 

With Best Regards,
Marat Khalili
