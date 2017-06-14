Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40105 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753624AbdFNIy7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Jun 2017 04:54:59 -0400
Subject: Re: [PATCH 1/3 v2.1] btrfs: write_dev_flush does not return ENOMEM
 anymore
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1497344741-1135-1-git-send-email-anand.jain@oracle.com>
 <1497346349-1194-1-git-send-email-anand.jain@oracle.com>
 <20170613152328.GY25451@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <873d0302-a3ea-4017-9487-889d0f88a469@oracle.com>
Date: Wed, 14 Jun 2017 17:01:11 +0800
MIME-Version: 1.0
In-Reply-To: <20170613152328.GY25451@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> All 3 reviewed and queued, thanks. 

  Thanks indeed.

> I have a prototype for the
> preallocated flush bio but was waiting until these cleanups are in
> before snding it.

  oh. sorry for the delay if any. -ENOMEM was only purpose I had/have
  in mind for peralloc, but looks like there is another purpose which
  I am not aware of.

> I've noticed that threre are two more "if (!device->bdev)" checks under
> the device lock in write_all_supers, that might be worth removing.

> However, a NULL bdev and device->missing are related and I think there
> are some dark corners in dev replace where the invariant can be
> temporarily broken.

  Ok. Thanks for the hints. Trying to dig.

> Given that we probably don't have great testing
> coverage of devices with the flush capabilities,

  Any hints on what type of test coverage ?

Thanks, Anand
