Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23303 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbdFGJGc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 05:06:32 -0400
Subject: Re: [PATCH 4/8] btrfs: btrfs_io_bio_alloc never fails, skip error
 handling
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1496422340.git.dsterba@suse.com>
 <9035b5dbc57608ed73960504bfc1415ed579dac4.1496422340.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0d96cded-753d-b8b2-a54c-0cf9ec0ebd33@oracle.com>
Date: Wed, 7 Jun 2017 17:11:47 +0800
MIME-Version: 1.0
In-Reply-To: <9035b5dbc57608ed73960504bfc1415ed579dac4.1496422340.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/17 00:58, David Sterba wrote:
> Update direct callers of btrfs_io_bio_alloc that do error handling, that
> we can now remove.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

