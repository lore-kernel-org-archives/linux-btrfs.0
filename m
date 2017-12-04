Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31663 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750897AbdLDHJQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 02:09:16 -0500
Subject: Re: [PATCH v2] btrfs: handle dynamically reappearing missing device
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>
References: <20171112105650.3248-1-anand.jain@oracle.com>
 <20171117123614.11822-1-anand.jain@oracle.com>
 <2e6fd096-43c6-c6c7-90ae-ac4672ac5797@libero.it>
 <c721f8b5-aedb-6f28-5db9-6b48ac0c1014@oracle.com>
 <73ef4477-0497-fe24-ae17-5c4c08992c9c@libero.it>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c1b50109-1e43-e341-9502-d08d3962b5b8@oracle.com>
Date: Mon, 4 Dec 2017 15:09:42 +0800
MIME-Version: 1.0
In-Reply-To: <73ef4477-0497-fe24-ae17-5c4c08992c9c@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> [..]  would be better an explicit user intervention instead of an automatic one ?

  What is the user intervention method steps that you have in mind ?
  Just curious. Pls remember downtime is not a choice of recovery
  from this context which means FS should be available for the
  applications to perform read/write.

  -o remount was one this which I had skipped for sometime as
  theoretically it can't solve the problem (to bring back missing
  device) as well, but now I have verified it, it won't.

  There is no record of what is the original idea to perform this
  basic volume manager step.

Thanks, Anand

