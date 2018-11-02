Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36509C65C22
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 07:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B33472081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 07:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="mw+SvvLm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B33472081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=synology.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbeKBQTZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 12:19:25 -0400
Received: from synology.com ([59.124.61.242]:42667 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728223AbeKBQTZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 12:19:25 -0400
Received: from _ (localhost [127.0.0.1])
        by synology.com (Postfix) with ESMTPA id 49CB227B2553;
        Fri,  2 Nov 2018 15:13:13 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1541142793; bh=HiCd2EX/JIDWPN6ohggArnHpRGCMYwEfem00ta/X8eo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=mw+SvvLmLj8DjbsY+MEuuv2Fgl1L70md5PX4D9bNSptNZ974PgRIDlYBMtYSzDIvM
         R9y4O1ZJQdLAx0xkUru6D4vvAiP1VZgOqcmC9AcWhxNJlN2//UY4MhW6aTcGzha/wJ
         CenffcwWXa0ZByCUfV/dUaU2yOnGGdEsL8M4G2sE=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 02 Nov 2018 15:13:13 +0800
From:   ethanlien <ethanlien@synology.com>
To:     dsterba@suse.cz, Ethan Lien <ethanlien@synology.com>,
        linux-btrfs@vger.kernel.org
Cc:     linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] btrfs: use tagged writepage to mitigate livelock of
 snapshot
In-Reply-To: <20181101180206.GU9136@twin.jikos.cz>
References: <20181101064903.11638-1-ethanlien@synology.com>
 <20181101180206.GU9136@twin.jikos.cz>
Message-ID: <d56ae2d1ac65a6e5f3cd1fd00b5f4784@synology.com>
X-Sender: ethanlien@synology.com
User-Agent: Roundcube Webmail/1.1.2
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

David Sterba 於 2018-11-02 02:02 寫到:
> On Thu, Nov 01, 2018 at 02:49:03PM +0800, Ethan Lien wrote:
>> Snapshot is expected to be fast. But if there are writers steadily
>> create dirty pages in our subvolume, the snapshot may take a very long
>> time to complete. To fix the problem, we use tagged writepage for 
>> snapshot
>> flusher as we do in the generic write_cache_pages(), so we can ommit 
>> pages
>> dirtied after the snapshot command.
>> 
>> We do a simple snapshot speed test on a Intel D-1531 box:
>> 
>> fio --ioengine=libaio --iodepth=32 --bs=4k --rw=write --size=64G
>> --direct=0 --thread=1 --numjobs=1 --time_based --runtime=120
>> --filename=/mnt/sub/testfile --name=job1 --group_reporting & sleep 5;
>> time btrfs sub snap -r /mnt/sub /mnt/snap; killall fio
>> 
>> original: 1m58sec
>> patched:  6.54sec
>> 
>> This is the best case for this patch since for a sequential write 
>> case,
>> we omit nearly all pages dirtied after the snapshot command.
>> 
>> For a multi writers, random write test:
>> 
>> fio --ioengine=libaio --iodepth=32 --bs=4k --rw=randwrite --size=64G
>> --direct=0 --thread=1 --numjobs=4 --time_based --runtime=120
>> --filename=/mnt/sub/testfile --name=job1 --group_reporting & sleep 5;
>> time btrfs sub snap -r /mnt/sub /mnt/snap; killall fio
>> 
>> original: 15.83sec
>> patched:  10.35sec
>> 
>> The improvement is less compared with the sequential write case, since
>> we omit only half of the pages dirtied after snapshot command.
>> 
>> Signed-off-by: Ethan Lien <ethanlien@synology.com>
> 
> This looks nice, thanks. I agree with the The suggestions from Nikolay,
> please update and resend.
> 
> I was bit curious about the 'livelock', what you describe does not seem
> to be one. System under heavy IO can make the snapshot dead slow but 
> can
> recover from that once the IO stops.

I'm not sure if this is indeed the case of 'livelock'. I learn the term 
from commit:
f446daaea9d4a420d, "mm: implement writeback livelock avoidance using 
page tagging".
If this is not the case, I can use another term.

> Regarding the sync semantics, there's AFAIK no change to the current
> state where the sync is done before snapshot but without further other
> guarantees. From that point I think it's safe to select only subset of
> pages and make things faster.
> 
> As the requested changes are not functional I'll add the patch to
> for-next for testing.

