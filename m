Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:41405 "EHLO
        smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752729AbdDPIBE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 04:01:04 -0400
Received: from smtp37.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp37.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id C2B6959A5
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Apr 2017 04:01:03 -0400 (EDT)
Received: by smtp37.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id 72B08596A
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Apr 2017 04:01:03 -0400 (EDT)
Received: from mail.rqc.ru (roundcube.thinky.servers.rqc.ru [10.7.7.38])
        by intranet.rqc.ru (Postfix) with ESMTP id 095851A0DBB
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Apr 2017 11:01:01 +0300 (FET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 16 Apr 2017 11:01:00 +0300
From: Marat Khalili <mkh@rqc.ru>
To: linux-btrfs@vger.kernel.org
Subject: Re: Encountered kernel bug#72811. Advice on recovery?
In-Reply-To: <pan$5f10d$2c1e5c86$a2062192$8e2ab6b@cox.net>
References: <CAFKQ2Bs9-=serb7F-PHDVNQ-X2AXcWPG5jBs9xKXTKkTQ59O7Q@mail.gmail.com>
 <pan$29c2d$faf1fff7$a4518780$dbb0b61@cox.net>
 <CAN05THTcoQ6zLrDaVmoZ=pUQ3oMxU8EvYrz8TcUGOAo6a=5qHw@mail.gmail.com>
 <pan$5f10d$2c1e5c86$a2062192$8e2ab6b@cox.net>
Message-ID: <4868ddee9604c8b5aa208580fa01b7e7@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Even making such a warning conditional on kernel version is 
> problematic, because many distros backport major blocks of code, 
> including perhaps btrfs fixes, and the nominally 3.14 or whatever 
> kernel may actually be running btrfs and other fixes from 4.14 or 
> later, by the time they actually drop support for whatever LTS distro 
> version and quit backporting fixes.

This information could be stored in kernel and made available for 
usermode tools via some proc file. This would be very useful 
_especially_ considering backporting. Raid56 could be fixed already (or 
not) by the time it is implemented, but no doubt there will still be 
other highly experimental capabilities judging by how things go. And 
this feature itself could easily be backported.

Some machine-readable readiness level (ok/warning/override flag 
needed/known but disabled in kernel) plus one-line text message 
displayed to users in cases 2-4 is all we need. If proc file is missing 
or doesn't contain information about specific capability, tools could 
default to current behavior (AFAIR there're already warnings in some 
cases). Message should tersely cover any known issues, including 
stability, performance, compatibility and general readiness, and may 
contain links (to btrfs wiki?) for more information. I expect whole file 
to easily fit in 512 bytes.

--

With Best Regards,
Marat Khalili
