Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A762ECAAD4
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Aug 2022 00:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbiH0Aw1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Aug 2022 20:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiH0Aw0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2022 20:52:26 -0400
Received: from out20-15.mail.aliyun.com (out20-15.mail.aliyun.com [115.124.20.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B822DAEE5
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Aug 2022 17:52:24 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.04818081|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.00513821-0.000999786-0.993862;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.P0yXpGS_1661561541;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.P0yXpGS_1661561541)
          by smtp.aliyun-inc.com;
          Sat, 27 Aug 2022 08:52:22 +0800
Date:   Sat, 27 Aug 2022 08:52:26 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 0/2] btrfs-progs: read device fsid from the sysfs
Cc:     David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
In-Reply-To: <ae82f677-42dc-fe00-d7f9-0b9a71ebb16e@oracle.com>
References: <20220826081444.A633.409509F4@e16-tech.com> <ae82f677-42dc-fe00-d7f9-0b9a71ebb16e@oracle.com>
Message-Id: <20220827085225.BBC5.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.75.04 [en]
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

> It worked on my end. I am on 6.0.0-rc1+.
> 
> Without the btrfs-progs patch mentioned in the test case:
> 
> ----------------
> btrfs/249       [failed, exit status 1]- output mismatch (see /xfstests-dev/results//btrfs/249.out.bad)
>      --- tests/btrfs/249.out	2022-03-19 20:34:36.307019541 +0800
>      +++ /xfstests-dev/results//btrfs/249.out.bad	2022-08-26 17:23:53.912993906 +0800
>      @@ -1,2 +1,5 @@
>       QA output created by 249
>      -Silence is golden
>      +ERROR: unexpected number of devices: 1 >= 1
>      +ERROR: if seed device is used, try running this command as root
>      +FAILED: btrfs filesystem usage, ret 1. Check btrfs.ko and btrfs-progs version.
>      +(see /xfstests-dev/results//btrfs/249.full for details)
>      ...
>      (Run 'diff -u /xfstests-dev/tests/btrfs/249.out /xfstests-dev/results//btrfs/249.out.bad'  to see the entire diff)
> Ran: btrfs/249
> Failures: btrfs/249
> Failed 1 of 1 tests
> ----------------
> 
> 
> With the btrfs-progs patch mentioned in the test case:
> 
> ----------------
> btrfs/249        1s
> Ran: btrfs/249
> Passed all 1 tests
> ----------------
> 
> 
> > [ 1064.768430] BTRFS: device fsid 00ebd666-e838-4377-b9b6-aa69449297af devid 1 transid 6 /dev/sdb2 scanned by systemd-udevd (3602)
> > [ 1064.781504] BTRFS: device fsid 00ebd666-e838-4377-b9b6-aa69449297af devid 2 transid 6 /dev/sdb3 scanned by systemd-udevd (3605)
> > [ 1065.065938] BTRFS: device fsid 00ebd666-e838-4377-b9b6-aa69449297af devid 2 transid 7 /dev/sdb3 scanned by systemd-udevd (3602)
> 
> Two processes 3605 and 3602 are scanning the same device /dev/sdb3.
> One finds transid 6, and the other 7.
> 
> You may want to re-test on a clean machine again.

btrfs/249 passed on a clean machine here.

Thanks a lot.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/08/27


