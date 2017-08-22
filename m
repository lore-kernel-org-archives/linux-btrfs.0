Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:60972 "EHLO
        smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932654AbdHVNpS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 09:45:18 -0400
Received: from smtp30.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp30.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 0400956A1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 09:45:18 -0400 (EDT)
Received: by smtp30.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id A9CCD56E5
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 09:45:17 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id 32B1EF69D
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 13:45:16 +0000 (UTC)
From: Marat Khalili <mkh@rqc.ru>
Subject: Re: finding root filesystem of a subvolume?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
 <20170822125030.GB14804@rus.uni-stuttgart.de>
 <16778020-9167-b7cc-4768-ee33dca2bbb7@gmail.com>
 <20170822133030.GE14804@rus.uni-stuttgart.de>
 <0c35fba9-a514-31dd-a703-17f4727ed229@gmail.com>
Message-ID: <262e50e3-3ad7-2770-7d98-f136eb7a2d68@rqc.ru>
Date: Tue, 22 Aug 2017 16:45:15 +0300
MIME-Version: 1.0
In-Reply-To: <0c35fba9-a514-31dd-a703-17f4727ed229@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Hmm, now I'm really confused, I just checked on the Ubuntu 17.04 and 
> 16.04.3 VM's I have (I only run current and the most recent LTS 
> version), and neither of them behave like this. 

Was also shocked, but:

> $ lsb_release -a
> No LSB modules are available.
> Distributor ID:    Ubuntu
> Description:    Ubuntu 16.04.3 LTS
> Release:    16.04
> Codename:    xenial
>
> $ df -T | grep /mnt/data/lxc
>
> $ df -T /mnt/data/lxc
> Filesystem     Type  1K-blocks     Used  Available Use% Mounted on
> -              -    2907008836 90829848 2815107576   4% /mnt/data/lxc

--

With Best Regards,
Marat Khalili

