Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7161C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 06:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 492A22087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 06:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wpkg.org header.i=@wpkg.org header.b="HWeCVnNW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 492A22087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wpkg.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbeLDGN6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 01:13:58 -0500
Received: from mail.virtall.com ([46.4.129.203]:59684 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbeLDGN5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 01:13:57 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 0084337B3856;
        Tue,  4 Dec 2018 06:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wpkg.org; s=default;
        t=1543904035; bh=D8f7pUMtG+SkvCzgE2d4PEi34fbNgAGal9CRGOjgb0k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=HWeCVnNWI71GJxgJjX2dRNtbNB/c/IoCsx2EcwAOrB3ANdoFbfylooFwy8QOvxDyy
         b3m5IJCn5Y5/OWIGF8k1l8uvtMOeGmVSnmUnHTdxSWpy1zmXI3QHD3Y/CHdD/FRlni
         v8O5B0JGXjZpoBW/81cOa0h/Xu+1h7ti9KaKd1u2sYWWUPAePKxztb56lzbkobf5ev
         VqPP64CZubycn3bY7hrVisOfj9Ti3JECeV2HsrYRXqTYTWJLZHub1c481orz00umle
         jz1uzo6l4y77ioRsHRFsUFSLfBUn61UnYQsWR/FgrkfqQlGZsiExej/l9yyWTQ9YQf
         YA7yNLZgaHvZg==
X-Fuglu-Suspect: 254033dad921455c8443ffe68480d585
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA;
        Tue,  4 Dec 2018 06:13:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 04 Dec 2018 15:13:53 +0900
From:   Tomasz Chmielewski <mangoo@wpkg.org>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: experiences running btrfs on external USB disks?
In-Reply-To: <CAJCQCtRCu5ED+L+j0vWaiPO1ujm=MpMTxD1OvW1v3ZYpT_SMyw@mail.gmail.com>
References: <e94da83b0a57c01663ad1e40fa6b9b5e@wpkg.org>
 <CAJCQCtRCu5ED+L+j0vWaiPO1ujm=MpMTxD1OvW1v3ZYpT_SMyw@mail.gmail.com>
Message-ID: <0dcadfd3d9d1a36341d017ca4804e2b6@wpkg.org>
X-Sender: mangoo@wpkg.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-12-04 14:59, Chris Murphy wrote:

>> Running 4.19.6 right now, but was experiencing the issue also with 
>> 4.18
>> kernels.
>> 
>> 
>> 
>> # btrfs device stats /data
>> [/dev/sda1].write_io_errs    0
>> [/dev/sda1].read_io_errs     0
>> [/dev/sda1].flush_io_errs    0
>> [/dev/sda1].corruption_errs  0
>> [/dev/sda1].generation_errs  0
> 
> 
> Hard to say without a complete dmesg; but errno=-5 IO failure is
> pretty much some kind of hardware problem in my experience. I haven't
> seen it be a bug.

It is a complete dmesg - in sense:

# grep -i btrfs -A5 -B5 /var/log/syslog
Dec  4 05:06:56 step snapd[747]: udevmon.go:184: udev monitor observed 
remove event for unknown device 
"/sys/skbuff_head_cache(1481:anacron.service)"
Dec  4 05:06:56 step snapd[747]: udevmon.go:184: udev monitor observed 
remove event for unknown device "/sys/buffer_head(1481:anacron.service)"
Dec  4 05:06:56 step snapd[747]: udevmon.go:184: udev monitor observed 
remove event for unknown device 
"/sys/ext4_inode_cache(1481:anacron.service)"
Dec  4 05:15:01 step CRON[9352]: (root) CMD (command -v debian-sa1 > 
/dev/null && debian-sa1 1 1)
Dec  4 05:17:01 step CRON[9358]: (root) CMD (   cd / && run-parts 
--report /etc/cron.hourly)
Dec  4 05:23:13 step kernel: [77760.444607] BTRFS error (device sdb1): 
bad tree block start, want 378372096 have 0
Dec  4 05:23:13 step kernel: [77760.550933] BTRFS error (device sdb1): 
bad tree block start, want 378372096 have 0
Dec  4 05:23:13 step kernel: [77760.550972] BTRFS: error (device sdb1) 
in __btrfs_free_extent:6804: errno=-5 IO failure
Dec  4 05:23:13 step kernel: [77760.550979] BTRFS info (device sdb1): 
forced readonly
Dec  4 05:23:13 step kernel: [77760.551003] BTRFS: error (device sdb1) 
in btrfs_run_delayed_refs:2935: errno=-5 IO failure
Dec  4 05:23:13 step kernel: [77760.553223] BTRFS error (device sdb1): 
pending csums is 4096
Dec  4 05:23:14 step postfix/pickup[8993]: 13BBE460F86: uid=0 
from=<root@step>
Dec  4 05:23:14 step postfix/cleanup[9398]: 13BBE460F86: 
message-id=<20181204052314.13BBE460F86@step>
Dec  4 05:23:14 step postfix/qmgr[2745]: 13BBE460F86: from=<root@step>, 
size=404, nrcpt=1 (queue active)
Dec  4 05:23:14 step postfix/pickup[8993]: 40A964603EC: uid=0 
from=<root@step>

[...some emails follow, usual CRON messages etc., but noting at all 
generated by the kernel, no hardware issue reported...]



Tomasz Chmielewski
