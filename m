Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33ECAC43143
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 06:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DD8020878
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 06:00:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DD8020878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lausen.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbeJBMlm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Oct 2018 08:41:42 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:45265 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbeJBMlm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2018 08:41:42 -0400
X-Originating-IP: 182.239.115.70
Received: from localhost (unknown [182.239.115.70])
        (Authenticated sender: leonard@lausen.nl)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id C3FD01BF213
        for <linux-btrfs@vger.kernel.org>; Tue,  2 Oct 2018 06:00:10 +0000 (UTC)
From:   Leonard Lausen <leonard@lausen.nl>
To:     linux-btrfs@vger.kernel.org
Subject: Re: btrfs send receive ERROR: chown failed: No such file or directory
In-Reply-To: <87a7obowwn.fsf@lausen.nl>
References: <87a7obowwn.fsf@lausen.nl>
Date:   Tue, 02 Oct 2018 06:00:05 +0000
Message-ID: <87pnws7usa.fsf@lausen.nl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

does anyone have an idea about below issue? It is a severe issue as it
renders btrfs send / receive dysfunctional and it is not clear if there
may be a data corruption issue hiding in the current send / receive
code.

Thank you.

Best regards
Leonard

Leonard Lausen <leonard@lausen.nl> writes:
> Hello!
>
> I observe the following issue with btrfs send | btrfs receive in a setup
> with 2 machines and 3 btrfs file-systems. All machines run Linux 4.18.9.
> Machine 1 runs btrfs-progs 4.17.1, machine 2 runs btrfs-progs 4.17 (via
> https://packages.debian.org/stretch-backports/btrfs-progs).
>
> 1) Machine 1 takes regular snapshots and sends them to machine 2. btrfs 
>    btrfs send ... | ssh user@machine2 "btrfs receive /path1"
> 2) Machine 2 backups all subvolumes stored at /path1 to a second
>    independent btrfs filesystem. Let /path1/rootsnapshot be the first
>    snapshot stored at /path1 (ie. it has no Parent UUID). Let
>    /path1/incrementalsnapshot be a snapshot that has /path1/rootsnapshot
>    as a parent. Then
>    btrfs send -v /path1/rootsnapshot | btrfs receive /path2
>    works without issues, but
>    btrfs send -v -p /path1/rootsnapshot /path1/incrementalsnapshot | btrfs receive /path2
>    fails as follows:
>    ERROR: chown o257-4639416-0 failed: No such file or directory
>
> No error is shown in dmesg. /path1 and /path2 denote two independent
> btrfs filesystems.
>
> Note that there was no issue with transferring incrementalsnapshot from
> machine 1 to machine 2. No error is shown in dmesg.
>
> Best regards
> Leonard
