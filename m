Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F857C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 11:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCD152077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 11:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCD152077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lausen.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbeJKTDx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 15:03:53 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:40259 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbeJKTDw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 15:03:52 -0400
X-Originating-IP: 219.76.24.153
Received: from localhost (wtsc4b153.netvigator.com [219.76.24.153])
        (Authenticated sender: leonard@lausen.nl)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id A003040007;
        Thu, 11 Oct 2018 11:36:59 +0000 (UTC)
From:   Leonard Lausen <leonard@lausen.nl>
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send receive ERROR: chown failed: No such file or directory
In-Reply-To: <CAL3q7H5MbO41q-t-gGNYQuVG6dqfajbGLeZYLOOJyspuJuVFqg@mail.gmail.com>
References: <87a7obowwn.fsf@lausen.nl> <87pnws7usa.fsf@lausen.nl> <CAL3q7H5MbO41q-t-gGNYQuVG6dqfajbGLeZYLOOJyspuJuVFqg@mail.gmail.com>
Date:   Thu, 11 Oct 2018 11:36:56 +0000
Message-ID: <87r2gwg1ev.fsf@lausen.nl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hey Filipe,

thanks for the feedback. I ran the command again with -vv. Below are
the last commands logged by btrfs receive to stderr:

  mkfile o2138798-5016457-0
  rename leonard/mail/lists/emacs-orgmode/new/1530428589.M675528862P21583Q6R28ec1af3.leonard-xps13 -> o2138802-5207521-0
  rename o2138798-5016457-0 -> leonard/mail/lists/emacs-orgmode/new/1530428589.M675528862P21583Q6R28ec1af3.leonard-xps13
  utimes leonard/mail/lists/emacs-orgmode/new
  ERROR: cannot open /mnt/_btrbk_backups/leonard-xps13/@home.20180902T0045/o2138798-5016457-0: No such file or directory

The file which is mentioned above has in fact not changed between the
parent and current snapshot. I computed further a hash of the file on
source volume for parent and current snapshot and target on target
volume for parent snapshot. I get the same hash value in all 3 cases, so
the parent snapshot was apparently transferred correctly.

Note that the folder in which this file is placed contains 96558 files
whose sizes sum to 774M.

I further observed that the snapshot that previously failed to transfer
via send receive could now be sent / received without error. However,
the error then occured again for the next snapshot (which has the now
successfully transferred one as parent). There may be a race condition
that leads to non-deterministic failures.

Please let me know if I can help with any further information.

Best regards
Leonard

Filipe Manana <fdmanana@gmail.com> writes:

>> > 1) Machine 1 takes regular snapshots and sends them to machine 2. btrfs
>> >    btrfs send ... | ssh user@machine2 "btrfs receive /path1"
>> > 2) Machine 2 backups all subvolumes stored at /path1 to a second
>> >    independent btrfs filesystem. Let /path1/rootsnapshot be the first
>> >    snapshot stored at /path1 (ie. it has no Parent UUID). Let
>> >    /path1/incrementalsnapshot be a snapshot that has /path1/rootsnapshot
>> >    as a parent. Then
>> >    btrfs send -v /path1/rootsnapshot | btrfs receive /path2
>> >    works without issues, but
>> >    btrfs send -v -p /path1/rootsnapshot /path1/incrementalsnapshot | btrfs receive /path2
>
> -v is useless. Use -vv, which will dump all commands.
>
>> >    fails as follows:
>> >    ERROR: chown o257-4639416-0 failed: No such file or directory
>> >
>> > No error is shown in dmesg. /path1 and /path2 denote two independent
>> > btrfs filesystems.
>> >
>> > Note that there was no issue with transferring incrementalsnapshot from
>> > machine 1 to machine 2. No error is shown in dmesg.
