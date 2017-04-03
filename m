Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp145.dfw.emailsrvr.com ([67.192.241.145]:40228 "EHLO
        smtp145.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752133AbdDCIar (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 04:30:47 -0400
Received: from smtp15.relay.dfw1a.emailsrvr.com (localhost [127.0.0.1])
        by smtp15.relay.dfw1a.emailsrvr.com (SMTP Server) with ESMTP id 0706AC0122
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Apr 2017 04:30:47 -0400 (EDT)
Received: by smtp15.relay.dfw1a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id A0260C00FD
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Apr 2017 04:30:46 -0400 (EDT)
Subject: Re: mix ssd and hdd in single volume
To: linux-btrfs@vger.kernel.org
References: <CAEgruXvAEBfpQaAxCi42Vq6v8w7v1dqthpn9TpE3FDDHoTWRcw@mail.gmail.com>
 <pan$dda3$b8e27938$5de5fd9$136342b5@cox.net>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <c3b00962-6ab2-d289-be77-2586bf57cd6f@rqc.ru>
Date: Mon, 3 Apr 2017 11:30:44 +0300
MIME-Version: 1.0
In-Reply-To: <pan$dda3$b8e27938$5de5fd9$136342b5@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/04/17 03:13, Duncan wrote:
> Meanwhile, since you appear to be designing a mass-market product, it's
> worth mentioning that btrfs is considered, certainly by its devs and
> users on this list, to be "still stabilizing, not fully stable and
> mature." [...] That doesn't sound like a particularly good choice for a mass-market NAS
> product to me.  Of course there's rockstor and others out there already
> shipping such products, but they're risking their reputation and the
> safety of their customer's data in the process, altho there's certainly a
> few customers out there with the time, desire and technical know-how to
> ensure the recommended backups and following current kernel and list, and
> that's exactly the sort of people you'll find already here.  But that's
> not sufficiently mass-market to appeal to most vendors.
You may want to look here: https://www.synology.com/en-global/dsm/Btrfs 
. Somebody forgot to tell Synology, which already supports btrfs in all 
hardware-capable devices. I think Rubicon has been crossed in 
'mass-market NAS[es]', for good or not.

--

With Best Regards,
Marat Khalili

