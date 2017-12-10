Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45541 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751420AbdLJJUG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 04:20:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBA9HLnc029468
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Dec 2017 09:20:06 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2es24h80br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Dec 2017 09:20:06 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBA9K6XA003443
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Dec 2017 09:20:06 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBA9K5YD026902
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Dec 2017 09:20:05 GMT
Subject: Re: [bug report] btrfs: cleanup device states define
 BTRFS_DEV_STATE_IN_FS_METADATA
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-btrfs@vger.kernel.org
References: <20171207202858.vomwdy3r4b3hsc7n@mwanda>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <61f9e1bc-b66a-53ba-c72d-8efff487cad2@oracle.com>
Date: Sun, 10 Dec 2017 17:20:37 +0800
MIME-Version: 1.0
In-Reply-To: <20171207202858.vomwdy3r4b3hsc7n@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/08/2017 07:08 PM, Dan Carpenter wrote:
> Hello Anand Jain,
> 
> The patch 2dcfcdc43524: "btrfs: cleanup device states define
> BTRFS_DEV_STATE_IN_FS_METADATA" from Dec 4, 2017, leads to the
> following static checker warning:
> 
> 	fs/btrfs/super.c:2007 btrfs_calc_avail_data_space()
> 	warn: test_bit() takes a bit number
> 
> fs/btrfs/super.c
>    2004
>    2005          rcu_read_lock();
>    2006          list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
>    2007                  if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This BTRFS_DEV_STATE_IN_FS_METADATA define is BIT(1) but for test_bit()
> we should just take 1.  In other words we are doing double BIT(BIT(1)).
> 
>    2008                                                  &device->dev_state) ||
>    2009                      !device->bdev ||
>    2010                      test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
>    2011                          continue;
>    2012
>    2013                  if (i >= nr_devices)
>    2014                          break;
>    2015

  Thanks Dan. I fixed all these in v3.

- Anand
