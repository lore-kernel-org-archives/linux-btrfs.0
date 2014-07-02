Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46644 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbaGBB7B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 21:59:01 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 64E643EE0B6
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 10:58:59 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 64EC0AC03B8
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 10:58:58 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 1777D1DB8040
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 10:58:58 +0900 (JST)
Message-ID: <53B36756.5030601@jp.fujitsu.com>
Date: Wed, 2 Jul 2014 10:58:46 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: clear compress-force when remounting with compress
 option
References: <1404096685-10591-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140701160457.GM1553@twin.jikos.cz>
In-Reply-To: <20140701160457.GM1553@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/02 1:04), David Sterba wrote:
> On Mon, Jun 30, 2014 at 10:51:25AM +0800, Wang Shilong wrote:
>> Steps to reproduce:
>>   # mkfs.btrfs -f /dev/sdb
>>   # mount /dev/sdb /mnt -o compress-force=lzo
>>   # mount /dev/sdb /mnt -o remount,compress=zlib
>>   # cat /proc/mounts
>>
>> Remounting from compress-force to compress could not clear compress-force
>> option. The problem is there is no way for users to clear compress-force
>> option separately.
>>
>> Fix this problem by clearing @FORCE_COMPRESS flag when remounting to
>> compress=xxx.
>>
>> Suggested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> I'm sorry for lack of answer in the V1 thread, V2 is the minimal bugfix
> and I'm fine with it right away.
>
> Reviewed-by: David Sterba <dsterba@suse.cz>

Test result (I used your reproducer):
   3.16-rc3:               FAIL
   3.16-rc3 w/ your patch: PASS

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

