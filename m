Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27659 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752002AbdFQNsV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Jun 2017 09:48:21 -0400
Subject: Re: [PATCH 3/3 v2] btrfs: move dev stats accounting out of
 wait_dev_flush
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1497621455.git.dsterba@suse.com>
 <42dd9010ed622ba5a7d499bb8389b9ff386aaf86.1497621455.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ed4c0749-2d65-2461-de64-c1f5205e1660@oracle.com>
Date: Sat, 17 Jun 2017 21:53:51 +0800
MIME-Version: 1.0
In-Reply-To: <42dd9010ed622ba5a7d499bb8389b9ff386aaf86.1497621455.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/16/2017 10:04 PM, David Sterba wrote:
> We should really just wait in wait_dev_flush and let the caller decide
> what to do with the error value.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
