Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:39282 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbeFDOIK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2018 10:08:10 -0400
Subject: Re: BTRFS losing SE Linux labels on power failure or "reboot -nffd"
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Russell Coker <russell@coker.com.au>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <1598911.AOxyaR8aoy@liv>
 <342e22e7-448d-e11d-80cf-c619aa281ea5@mendix.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <8c2393e1-8d10-ffc3-3918-c6c5ab623f61@applied-asynchrony.com>
Date: Mon, 4 Jun 2018 15:59:12 +0200
MIME-Version: 1.0
In-Reply-To: <342e22e7-448d-e11d-80cf-c619aa281ea5@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/04/18 15:29, Hans van Kranenburg wrote:
> Hi,
> 
> On 06/04/2018 03:14 PM, Russell Coker wrote:
>> The command "reboot -nffd" (kernel reboot without flushing kernel buffers or
>> writing status) when run on a BTRFS system with SE Linux will often result in
>> /var/log/audit/audit.log being unlabeled.
> 
> This recent fix might be what you're looking for:
> 
> https://www.spinics.net/lists/linux-btrfs/msg77927.html

..which has been in 4.16 since 4.16.11. :)

-h
