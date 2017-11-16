Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42376 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932825AbdKPBw0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 20:52:26 -0500
Subject: Re: [PATCH] btrfs: fix deadlock when writing out space cache
To: Josef Bacik <josef@toxicpanda.com>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>,
        Josef Bacik <jbacik@fb.com>
References: <1510780852-8862-1-git-send-email-josef@toxicpanda.com>
 <20171115234606.GA23320@dhcp-whq-twvpn-1-vpnpool-10-159-153-242.vpn.oracle.com>
From: Chris Mason <clm@fb.com>
Message-ID: <14317852-ba78-6859-8785-62ac779ea6fb@fb.com>
Date: Wed, 15 Nov 2017 20:52:16 -0500
MIME-Version: 1.0
In-Reply-To: <20171115234606.GA23320@dhcp-whq-twvpn-1-vpnpool-10-159-153-242.vpn.oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/15/2017 06:46 PM, Liu Bo wrote:
> On Wed, Nov 15, 2017 at 04:20:52PM -0500, Josef Bacik wrote:
>> From: Josef Bacik <jbacik@fb.com>
>>
>> If we fail to prepare our pages for whatever reason (out of memory in
>> our case) we need to make sure to drop the block_group->data_rwsem,
>> otherwise hilarity ensues.
>>

Thanks Josef, I searched all the logs and it looks like we've really 
only hit this twice this month.  It's surprising we haven't seen this 
more given how often we OOM.

-chris
