Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41538 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeDEJip (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Apr 2018 05:38:45 -0400
Subject: Re: [PATCH 02/16] btrfs: make success path out of
 btrfs_init_dev_replace_tgtdev more clear
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <21dd8dd69ac4cfd2fb97474421cc50736ba7876c.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f7bcb061-674f-1653-441c-67f9a1dfc9a1@oracle.com>
Date: Thu, 5 Apr 2018 17:40:43 +0800
MIME-Version: 1.0
In-Reply-To: <21dd8dd69ac4cfd2fb97474421cc50736ba7876c.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2018 02:34 AM, David Sterba wrote:
> This is a preparatory cleanup that will make clear that the only
> successful way out of btrfs_init_dev_replace_tgtdev will also set the
> device_out to a valid pointer. With this guarantee, the callers can be
> simplified.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
