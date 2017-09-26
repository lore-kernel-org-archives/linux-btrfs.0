Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38621 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S967138AbdIZIHX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 04:07:23 -0400
Subject: Re: [PATCH 2/3] btrfs: cleanup btrfs_init_new_device()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170925123104.16526-1-anand.jain@oracle.com>
 <20170925123104.16526-3-anand.jain@oracle.com>
 <6af9ec03-712a-d78e-6ad5-f4aff0f0dd61@suse.com>
 <bbd6b15b-146a-9373-7242-f69a69bd0c4f@suse.com>
 <26696307-d343-e75a-5dd8-b401a8fe02d0@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <03b419bf-95de-00cf-6e43-9c462c8f1872@suse.com>
Date: Tue, 26 Sep 2017 11:07:19 +0300
MIME-Version: 1.0
In-Reply-To: <26696307-d343-e75a-5dd8-b401a8fe02d0@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.09.2017 10:57, Anand Jain wrote:
> 
>> The
>> sysfs rm stands though
> 
>  This is a preparatory patch for 3/3, at BUG_ON it needs an exit
> without  the btrfs_sysfs_add_device_link() part.

In this case I'd rather you have this change in 3/3, because on its own
it doesn't really make sense and cannot easily be figured out if doing
git blame.

> 
> -Anand
> 
