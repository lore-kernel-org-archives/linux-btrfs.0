Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51414 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdFJSZ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Jun 2017 14:25:26 -0400
Subject: Re: btrfs native encryption
To: Chris Murphy <lists@colorremedies.com>,
        Filip Bystricky <filipbystricky@google.com>
References: <CADvCoti_3iDwXfqepMdva6E6OOis_rqqVQ4adCV1T67PVhRrOQ@mail.gmail.com>
 <CAJCQCtRvzveHJuzRg9fqTAiPNpjAQxaZbcf+t1E65hojhzXaXQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <593C2CF4.8000509@oracle.com>
Date: Sun, 11 Jun 2017 02:31:32 +0900
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRvzveHJuzRg9fqTAiPNpjAQxaZbcf+t1E65hojhzXaXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>  dealing with inheritance of
> encryption when making snapshots, and dealing with reflinks.

  Right. To address this, there is a proposal to bring encryption down 
to the extent level, it solves these limitations.

Thanks, Anand
