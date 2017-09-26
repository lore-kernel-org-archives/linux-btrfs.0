Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51138 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964802AbdIZHud (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 03:50:33 -0400
Subject: Re: [PATCH 2/3] btrfs: cleanup btrfs_init_new_device()
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170925123104.16526-1-anand.jain@oracle.com>
 <20170925123104.16526-3-anand.jain@oracle.com>
 <6af9ec03-712a-d78e-6ad5-f4aff0f0dd61@suse.com>
 <bbd6b15b-146a-9373-7242-f69a69bd0c4f@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <26696307-d343-e75a-5dd8-b401a8fe02d0@oracle.com>
Date: Tue, 26 Sep 2017 15:57:49 +0800
MIME-Version: 1.0
In-Reply-To: <bbd6b15b-146a-9373-7242-f69a69bd0c4f@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> The
> sysfs rm stands though

  This is a preparatory patch for 3/3, at BUG_ON it needs an exit 
without  the btrfs_sysfs_add_device_link() part.

-Anand
