Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:36239 "EHLO
        smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S978968AbdDYFd7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 01:33:59 -0400
Received: from smtp24.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp24.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id D1C8D24CAA
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Apr 2017 01:33:58 -0400 (EDT)
Received: by smtp24.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id 814E024B90
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Apr 2017 01:33:58 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id A7A91731D
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Apr 2017 05:33:55 +0000 (UTC)
Subject: Re: Problem with file system
To: linux-btrfs@vger.kernel.org
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
Date: Tue, 25 Apr 2017 08:33:55 +0300
MIME-Version: 1.0
In-Reply-To: <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/04/17 03:26, Qu Wenruo wrote:
> IIRC qgroup for subvolume deletion will cause full subtree rescan 
> which can cause tons of memory. 
Could it be this bad, 24GB of RAM for a 5.6TB volume? What does it even 
use this absurd amount of memory for? Is it swappable?

Haven't read about RAM limitations for running qgroups before, only 
about CPU load (which importantly only requires patience, does not crash 
servers).

--

With Best Regards,
Marat Khalili
