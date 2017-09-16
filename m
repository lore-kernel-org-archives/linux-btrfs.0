Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:59137 "EHLO
        smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751317AbdIPKnZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 06:43:25 -0400
Received: from smtp24.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp24.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 98ED724D8F
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Sep 2017 06:43:24 -0400 (EDT)
Received: by smtp24.relay.iad3a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id 4B6FD24C12
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Sep 2017 06:43:24 -0400 (EDT)
Subject: Re: A user cannot remove his readonly snapshots?!
To: linux-btrfs@vger.kernel.org
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <ce51b681-b86a-242a-1ac1-106454c32ddb@libero.it>
 <20170916101901.GM32347@rus.uni-stuttgart.de>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <e1b1e123-67f5-6911-494e-da9ebdbd65cc@rqc.ru>
Date: Sat, 16 Sep 2017 13:43:23 +0300
MIME-Version: 1.0
In-Reply-To: <20170916101901.GM32347@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16/09/17 13:19, Ulli Horlacher wrote:
> How do I know the btrfs filesystem for a given subvolume?
> Do I really have to manually test the diretory path upwards?

It was discussed recently: the answer is, unfortunately, yes, until 
someone patches df to do it for us. You can do it more or less 
efficiently by analyzing /proc/mounts .

--

With Best Regards,
Marat Khalili

