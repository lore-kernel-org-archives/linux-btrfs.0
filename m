Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6207C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF1B72086C
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="J9N5r+Dt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731229AbfCaOVn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 10:21:43 -0400
Received: from mail-40130.protonmail.ch ([185.70.40.130]:60315 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbfCaOVn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 10:21:43 -0400
Date:   Sun, 31 Mar 2019 14:21:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1554042100;
        bh=XKmgRJwY0Tn3t+TI5LryrzMkPOiGrsYbOv6vMmjE0Iw=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=J9N5r+DtOoZTKDLOsyV6DPMy5b5QjdutRpog1IFUcs8ghXTucZGacGyXeP31jmkSz
         HJbHD57eCp99VcE7fwg5VxJ+p3k5r0Vxyc0a39YVBpu0tGZar97u1hosdtkYxKwlve
         /Pq9GF8Fjnwt2rm/l0+njfwyo9pndkVUqVH5wi+c=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   berodual_xyz <berodual_xyz@protonmail.com>
Reply-To: berodual_xyz <berodual_xyz@protonmail.com>
Subject: volumes.c:1762: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
Message-ID: <OBcqa2Fc0jqI9Dnn8nBkHh_ywiNByvFWAIUiQ9VSYP2TTQKacDXe-gmeqXmEeWg4JXwFN0abkfoVjdgfkkLj0-Z9SpinIg6uvM0ALCKkTY8=@protonmail.com>
Feedback-ID: I1q2L7VvFsdXESkLE1a2aLBALpN2HWsXO5F205qEARYXtg94zW3HdiV9HI52kzHEEqfcUdbqlfVMVRPA6rJltg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Dear list,

following from earlier this weeks case of attempting data rescue on a corru=
pt FS, we have now cloned all devices and can do potentially dangerous resc=
ue attempts (since we can re-clone the original disks).

On kernel 4.20.17 and btrfs-progs 4.20.2:


##
$ btrfs inspect-internal tree-stats /dev/sdh
parent transid verify failed on 1048576 wanted 60234 found 60230
parent transid verify failed on 1048576 wanted 60234 found 60230
Ignoring transid failure
volumes.c:1762: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
btrfs[0x426fdc]
btrfs(btrfs_chunk_readonly+0x98)[0x429acd]
btrfs(btrfs_read_block_groups+0x1c1)[0x41cd44]
btrfs(btrfs_setup_all_roots+0x368)[0x416540]
btrfs[0x416a8a]
btrfs(open_ctree_fs_info+0xd0)[0x416bcc]
btrfs(open_ctree+0x75)[0x416c61]
btrfs(cmd_inspect_tree_stats+0xfa)[0x4706ad]
btrfs(handle_command_group+0x5d)[0x40c7b3]
btrfs(cmd_inspect+0x15)[0x4499f1]
btrfs(main+0x24a)[0x40ca02]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f0f26c7cb35]
btrfs[0x40c509]
[1]    15273 abort      btrfs inspect-internal tree-stats /dev/sdh


###


$ btrfs rescue zero-log /dev/sdh
parent transid verify failed on 1048576 wanted 60234 found 60230
parent transid verify failed on 1048576 wanted 60234 found 60230
Ignoring transid failure
volumes.c:1762: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
btrfs[0x426fdc]
btrfs(btrfs_chunk_readonly+0x98)[0x429acd]
btrfs(btrfs_read_block_groups+0x1c1)[0x41cd44]
btrfs(btrfs_setup_all_roots+0x368)[0x416540]
btrfs[0x416a8a]
btrfs(open_ctree_fs_info+0xd0)[0x416bcc]
btrfs(open_ctree+0x75)[0x416c61]
btrfs[0x4657ff]
btrfs(handle_command_group+0x5d)[0x40c7b3]
btrfs(cmd_rescue+0x15)[0x465b98]
btrfs(main+0x24a)[0x40ca02]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f4507ab1b35]
btrfs[0x40c509]
[1]    30211 abort      btrfs rescue zero-log /dev/sdh

###

Even if we will not be able to recover the data, adding these traces here h=
opefully helps enhancing the tools in the future as a crash is most definit=
ely not the "expected behavior".


Have a nice weekend and I hope to receive some feedback.

Thanks in advance,

Marcel

