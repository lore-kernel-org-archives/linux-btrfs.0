Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:45529 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdKBENY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 00:13:24 -0400
Received: by mail-pf0-f196.google.com with SMTP id d28so3636242pfe.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 21:13:24 -0700 (PDT)
Content-Type: text/plain; charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 0/5] btrfs-progs: resolve property and enhance defragment
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <ea3e10a2-fdbe-db5f-378b-3767ba85bd5f@cn.fujitsu.com>
Date: Thu, 2 Nov 2017 12:13:23 +0800
Cc: Wang Shilong <wangshilong1991@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <6F415D55-08C6-4517-9DF9-457B3679E7C4@gmail.com>
References: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
 <ea3e10a2-fdbe-db5f-378b-3767ba85bd5f@cn.fujitsu.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


在 2017年11月2日，上午11:44，Su Yue <suy.fnst@cn.fujitsu.com> 写道：

Sorry, the patchset does not work as expected.
Please ignore it.

On 11/02/2017 11:23 AM, Su Yue wrote:
> The patchset adds an option '--compress-force' to work with
> 'btrfs fi defrag -c'. Then no-compression files will be set with
> compression property specified by '-c' (zlib default).
> patch[1-4] divide property handler to setter, getter, and printer.
> Then patch[5] could enhance defragment easier.
> Su Yue (5):
>   btrfs-progs: property: divide prop_handler_t into
>     setter,getter,printer
>   btrfs-progs: property: set/get/print ro property
>   btrfs-progs: property: set/get/print label property
>   btrfs-progs: property: set/get/print compression property
>   btrfs-progs: fi defrag: extend -c to drop nocompress flag on files
>  cmds-filesystem.c |  94 +++++++++++++++++++++++--
>  cmds-property.c   |   7 +-
>  props.c           | 207 +++++++++++++++++++++++++++++++++++++++++++++---------
>  props.h           |  19 +++--
>  4 files changed, 283 insertions(+), 44 deletions(-)

FYI, i think it better to add some tests to btrfs-progs if new interface
or function like this is added.

Thanks,
Shilong


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

