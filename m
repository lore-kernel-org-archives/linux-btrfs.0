Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667E1C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 06:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F012320685
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 06:48:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="ukzjpR7c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F012320685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393318AbeKWRa5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 12:30:57 -0500
Received: from mail-lj1-f172.google.com ([209.85.208.172]:44063 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393293AbeKWRa5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 12:30:57 -0500
Received: by mail-lj1-f172.google.com with SMTP id k19-v6so9727792lji.11
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 22:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ULND6JdRCfQOkAkB06GYkQWSAjogZQRYxXwZnF+MtoM=;
        b=ukzjpR7csB89zezippRUkLlgAJTTHCCxunOfZwduEty2dpCEsAgZjZeTo+TiHrspUI
         cluVquhEAh5+4L3JcpVWRGHEv3+L5ziqSdcYRAx5VQZ5NJZyxZMovf13nTyirCcEukNi
         AY6z4LwbndhiwcbzUGnN8/5x1n5sbRB5CO3/+uHArfnIpHOueFqxTIWurHMpuw7Mhk3W
         usJP+zSLKUB6gMqxT7i3iaFNtYqWSaT4y464a/FPunru8slyhIHEltjKpuuCh2VFHhBI
         ltsdN5DTOvAOvr11qsFZ4QAUxAB5GbPIxAQ6SRyUPUrdUVqySS2S0pc1zl+Gnz/3X91Z
         Q1HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULND6JdRCfQOkAkB06GYkQWSAjogZQRYxXwZnF+MtoM=;
        b=HF7O0HMCzTSBjfOnuGYf+e/e6j1hrif92Nmqs8DxT3T4RkQXqnGxzA7h6o9/xRjNKX
         HBXcz682NWVeL3bBQtiKsXIy++J801+50j/lSGf3I+Dey/8De5hNEZc9whfs4QgtdwIe
         MdNtLxvC0sZoq+kqpvimAX5262lC0t+qh57hDPBJ0tM4j71TB36aqv+wfRTtU48oi4sM
         Kn2RA/cpIN2cjebFogLAPC7QmBVWKPtp/LFlAX29R7I4jxcTdlAHIQGwkn80naSGko4o
         GzGZ1ZWEaxvCR1JHi64SQTFaSmMGJOFX9aQDfAJxgcYHIJbLXeOViDGff2wNLo0WxARJ
         D1aA==
X-Gm-Message-State: AA+aEWZejvsztiBFuIfo7D7H2J1HqH98rWbnsHA57nSsH+2n27u2p1sd
        15Rft9fqfCDeyPvvOPXbSU7Xt7AjPlgCffOnwzhDVA==
X-Google-Smtp-Source: AFSGD/VZWjzOzh0+o7CWqDELa06chMVWPaszulLjynhB0wMZTW4nRSuBE4a023lxd/nw2JldI+R4Fojc/TdG9t1SGc8=
X-Received: by 2002:a2e:9ad0:: with SMTP id p16-v6mr9607539ljj.102.1542955681690;
 Thu, 22 Nov 2018 22:48:01 -0800 (PST)
MIME-Version: 1.0
References: <ca2de2a36290496ccf41b6ed23c799d8@virtall.com> <f9e07d50-be2e-36fb-8953-2419200522f0@suse.com>
 <0df02574bdf0fb676cee7b5a3d1890e3@virtall.com>
In-Reply-To: <0df02574bdf0fb676cee7b5a3d1890e3@virtall.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 22 Nov 2018 23:47:49 -0700
Message-ID: <CAJCQCtQBvXZURXAtCyDgy15iw3hOuPTTMWGMdPsPK+W1m0MbZg@mail.gmail.com>
Subject: Re: btrfs-cleaner 100% busy on an idle filesystem with 4.19.3
To:     Tomasz Chmielewski <tch@virtall.com>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 6:07 AM Tomasz Chmielewski <tch@virtall.com> wrote:
>
> On 2018-11-22 21:46, Nikolay Borisov wrote:
>
> >> # echo w > /proc/sysrq-trigger
> >>
> >> # dmesg -c
> >> [  931.585611] sysrq: SysRq : Show Blocked State
> >> [  931.585715]   task                        PC stack   pid father
> >> [  931.590168] btrfs-cleaner   D    0  1340      2 0x80000000
> >> [  931.590175] Call Trace:
> >> [  931.590190]  __schedule+0x29e/0x840
> >> [  931.590195]  schedule+0x2c/0x80
> >> [  931.590199]  schedule_timeout+0x258/0x360
> >> [  931.590204]  io_schedule_timeout+0x1e/0x50
> >> [  931.590208]  wait_for_completion_io+0xb7/0x140
> >> [  931.590214]  ? wake_up_q+0x80/0x80
> >> [  931.590219]  submit_bio_wait+0x61/0x90
> >> [  931.590225]  blkdev_issue_discard+0x7a/0xd0
> >> [  931.590266]  btrfs_issue_discard+0x123/0x160 [btrfs]
> >> [  931.590299]  btrfs_discard_extent+0xd8/0x160 [btrfs]
> >> [  931.590335]  btrfs_finish_extent_commit+0xe2/0x240 [btrfs]
> >> [  931.590382]  btrfs_commit_transaction+0x573/0x840 [btrfs]
> >> [  931.590415]  ? btrfs_block_rsv_check+0x25/0x70 [btrfs]
> >> [  931.590456]  __btrfs_end_transaction+0x2be/0x2d0 [btrfs]
> >> [  931.590493]  btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
> >> [  931.590530]  btrfs_drop_snapshot+0x489/0x800 [btrfs]
> >> [  931.590567]  btrfs_clean_one_deleted_snapshot+0xbb/0xf0 [btrfs]
> >> [  931.590607]  cleaner_kthread+0x136/0x160 [btrfs]
> >> [  931.590612]  kthread+0x120/0x140
> >> [  931.590646]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
> >> [  931.590658]  ? kthread_bind+0x40/0x40
> >> [  931.590661]  ret_from_fork+0x22/0x40
> >>
> >
> > It seems your filesystem is mounted with the DSICARD option meaning
> > every delete will result in discard this is highly suboptimal for
> > ssd's.
> > Try remounting the fs without the discard option see if it helps.
> > Generally for discard you want to submit it in big batches (what fstrim
> > does) so that the ftl on the ssd could apply any optimisations it might
> > have up its sleeve.
>
> Spot on!
>
> Removed "discard" from fstab and added "ssd", rebooted - no more
> btrfs-cleaner running.
>
> Do you know if the issue you described ("discard this is highly
> suboptimal for ssd") affects other filesystems as well to a similar
> extent? I.e. if using ext4 on ssd?

Quite a lot of activity on ext4 and XFS are overwrites, so discard
isn't needed. And it might be discard is subject to delays. On Btrfs,
it's almost immediate, to the degree that on a couple SSDs I've
tested, stale trees referenced exclusively by the most recent backup
tree entires in the superblock are already zeros. That functionally
means no automatic recoveries at mount time if there's a problem with
any of the current trees.

I was using it for about a year to no ill effect, BUT not a lot of
file deletions either. I wouldn't recommend it, and instead suggest
enabling the fstrim.timer which by default runs fstrim.service once a
week (which in turn issues fstrim, I think on all mounted volumes.)

I am a bit more concerned about the read errors you had that were
being corrected automatically? The corruption suggests a firmware bug
related to trim. I'd check the affected SSD firmware revision and
consider updating it (only after a backup, it's plausible the firmware
update is not guaranteed to be data safe). Does the volume use DUP or
raid1 metadata? I'm not sure how it's correcting for these problems
otherwise.


-- 
Chris Murphy
