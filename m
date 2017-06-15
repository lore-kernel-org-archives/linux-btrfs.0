Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50631 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbdFOUWu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 16:22:50 -0400
Subject: Re: [PATCH 1/3 v2.1] btrfs: write_dev_flush does not return ENOMEM
 anymore
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1497344741-1135-1-git-send-email-anand.jain@oracle.com>
 <1497346349-1194-1-git-send-email-anand.jain@oracle.com>
 <20170613152328.GY25451@twin.jikos.cz>
 <873d0302-a3ea-4017-9487-889d0f88a469@oracle.com>
 <20170615162758.GE25451@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2b8439f1-79b2-50cf-8084-a40a743f2c6e@oracle.com>
Date: Fri, 16 Jun 2017 04:29:03 +0800
MIME-Version: 1.0
In-Reply-To: <20170615162758.GE25451@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




>>> Given that we probably don't have great testing
>>> coverage of devices with the flush capabilities,
>>
>>    Any hints on what type of test coverage ?
> 
> Devices used for normal testing, any sort of test basically, that do not
> have the flush capabilities will never exercise the in write_dev_flush.

  Right. Same with -o nobarrier as well.

> So any reference counts or failures will not get covered.

  hm. Still I didn't understand your point of view, sorry.
  But the contrary is also true that when device cache is enabled,
  the write_dev_flush() gets exercised, so we are fine.

  I toggled the device write cache manually for testing this set.
     # echo "write through" > /sys/block/sdd/queue/write_cache
     # echo "write back" > /sys/block/sdd/queue/write_cache


Thanks, Anand


