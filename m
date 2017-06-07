Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51796 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdFGJQW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 05:16:22 -0400
Subject: Re: [PATCH 7/8] btrfs: opencode trivial compressed_bio_alloc,
 simplify error handling
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1496422340.git.dsterba@suse.com>
 <c1045c6859c18ce20d4f55e162399b708f9bfcf4.1496422340.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2bcb3036-5cf6-884b-71bd-e3e92bd0010f@oracle.com>
Date: Wed, 7 Jun 2017 17:21:42 +0800
MIME-Version: 1.0
In-Reply-To: <c1045c6859c18ce20d4f55e162399b708f9bfcf4.1496422340.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/17 00:58, David Sterba wrote:
> compressed_bio_alloc is now a trivial wrapper around btrfs_bio_alloc, no
> point keeping it. The error handling can be simplified, as we know
> btrfs_bio_alloc will never fail.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
