Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gremlin.yadt.co.uk ([149.255.108.98]:59274 "EHLO
	gremlin.yadt.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaELL2T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 07:28:19 -0400
Date: Mon, 12 May 2014 12:28:09 +0100
From: David Taylor <davidt-btrfs@yadt.co.uk>
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: replace simple_strtoul() with kstrtoul()
Message-ID: <20140512112808.GA5103@yadt.co.uk>
References: <1399892355-3781-1-git-send-email-zhenzhang.zhang@huawei.com>
 <5370A9ED.9000106@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <5370A9ED.9000106@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 12 May 2014, Zhang Zhen wrote:

>use the newer and more pleasant kstrtoul() to replace simple_strtoul(),
>because simple_strtoul() is marked for obsoletion.
[...]
>-		devid = simple_strtoull(devstr, &end, 10);
>+		devid = kstrtoul(devstr, &end, 10);

kstrtoul appears to take its arguments in a different order:

unsigned long long simple_strtoull(const char * cp,
  char ** endp, unsigned int base);

int kstrtoul(const char *s, unsigned int base, unsigned long *res);

-- 
David Taylor
