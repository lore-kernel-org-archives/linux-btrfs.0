Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D8CC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 15:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DD8D204FD
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 15:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbfAOPRI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 10:17:08 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:41919 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfAOPRH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 10:17:07 -0500
X-Originating-IP: 217.233.237.245
Received: from localhost (pD9E9EDF5.dip0.t-ipconnect.de [217.233.237.245])
        (Authenticated sender: leonard@lausen.nl)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 26FE9240018;
        Tue, 15 Jan 2019 15:17:04 +0000 (UTC)
From:   Leonard Lausen <leonard@lausen.nl>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS critical corrupt leaf bad key order
In-Reply-To: <3a74079a-7e13-9368-93fb-0c25a10450e0@gmx.com>
References: <87d0oyw46b.fsf@lausen.nl> <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com> <3a74079a-7e13-9368-93fb-0c25a10450e0@gmx.com>
Date:   Tue, 15 Jan 2019 15:17:03 +0000
Message-ID: <87sgxurlw0.fsf@lausen.nl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>> I'm working on the fix.
>> Please make sure there is no write into the fs (just in case, since the
>> fs should be RO).
>
> Here it is:
> https://github.com/adam900710/btrfs-progs/tree/dirty_fix_for_leonard_lausen
>
> You need to git checkout the branch, and then compile.
> (No need to install)
>
> Then inside the directory, execute:
> # ./btrfs-corrupt-block -X <device>
>
> It will try to locate the corrupted leaf using the dump-tree result.
> If it doesn't find the corrupted leaf or the content isn't expected, it
> will just exit without writing anything.

Thanks Qu for the quick fix! After running some BIOS system check to
verify that there is no persistent hardware problem, your fix resolved
the corruption issue. According to btrfs check there are no remaining
issues and the system booted up fine.

  root@archiso ~/btrfs-progs (git)-[dirty_fix_for_leonard_lausen] # ./btrfs check -p --readonly /dev/mapper/vg1-root
  Opening filesystem to check...
  Checking filesystem on /dev/mapper/vg1-root
  UUID: ea519c2e-3571-46f8-905a-99c824327caa
  [1/7] checking root items                      (0:00:24 elapsed, 7398633 items checked)
  [2/7] checking extents                         (0:03:07 elapsed, 578278 items checked)
  [3/7] checking free space cache                (0:00:13 elapsed, 814 items checked)
  [4/7] checking fs roots                        (0:07:07 elapsed, 464005 items checked)
  [5/7] checking csums (without verifying data)  (0:00:19 elapsed, 1827711 items checked)
  [6/7] checking root refs                       (0:00:00 elapsed, 277 items checked)
  [7/7] checking quota groups skipped (not enabled on this FS)
  found 848209637510 bytes used, no error found
  total csum bytes: 785717792
  total tree bytes: 9469886464
  total fs tree bytes: 7635271680
  total extent tree bytes: 848330752
  btree space waste bytes: 1936310259
  file data blocks allocated: 5230984867840
   referenced 1031230742528
  ./btrfs check -p --readonly /dev/mapper/vg1-root  374.85s user 45.16s system 62% cpu 11:11.17 total
