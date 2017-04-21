Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp153.dfw.emailsrvr.com ([67.192.241.153]:51355 "EHLO
        smtp153.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1040443AbdDUOYj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 10:24:39 -0400
Subject: Re: Prevent escaping btrfs quota
To: linux-btrfs@vger.kernel.org
References: <20170421133957.7kax2ktwhh43nnq2@mailbox.org>
Cc: =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <9dd235ce-e119-553f-f3a7-5352ac5516a3@rqc.ru>
Date: Fri, 21 Apr 2017 17:24:35 +0300
MIME-Version: 1.0
In-Reply-To: <20170421133957.7kax2ktwhh43nnq2@mailbox.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just some food for thought: there's already a tag that correctly assigns 
filesystem objects to users. It is called owner(ship). Instead of making 
qgroups repeat ownership logic, why not base qgroup assignments on 
ownership itself? (At least on per-subvolume basis.)

--

With Best Regards,
Marat Khalili

