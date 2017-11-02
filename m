Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15839 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934030AbdKBDlL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 23:41:11 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 9C5E747F13A7
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Nov 2017 11:41:08 +0800 (CST)
Subject: Re: [PATCH 0/5] btrfs-progs: resolve property and enhance defragment
To: <linux-btrfs@vger.kernel.org>
References: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <ea3e10a2-fdbe-db5f-378b-3767ba85bd5f@cn.fujitsu.com>
Date: Thu, 2 Nov 2017 11:44:39 +0800
MIME-Version: 1.0
In-Reply-To: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, the patchset does not work as expected.
Please ignore it.

On 11/02/2017 11:23 AM, Su Yue wrote:
> The patchset adds an option '--compress-force' to work with
> 'btrfs fi defrag -c'. Then no-compression files will be set with
> compression property specified by '-c' (zlib default).
> 
> patch[1-4] divide property handler to setter, getter, and printer.
> 
> Then patch[5] could enhance defragment easier.
> 
> Su Yue (5):
>    btrfs-progs: property: divide prop_handler_t into
>      setter,getter,printer
>    btrfs-progs: property: set/get/print ro property
>    btrfs-progs: property: set/get/print label property
>    btrfs-progs: property: set/get/print compression property
>    btrfs-progs: fi defrag: extend -c to drop nocompress flag on files
> 
>   cmds-filesystem.c |  94 +++++++++++++++++++++++--
>   cmds-property.c   |   7 +-
>   props.c           | 207 +++++++++++++++++++++++++++++++++++++++++++++---------
>   props.h           |  19 +++--
>   4 files changed, 283 insertions(+), 44 deletions(-)
> 


