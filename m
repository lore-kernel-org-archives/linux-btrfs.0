Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6322EC43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B12020870
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="ICuuNoWG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbfCaOit (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 10:38:49 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:22214 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbfCaOit (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 10:38:49 -0400
Date:   Sun, 31 Mar 2019 14:38:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1554043123;
        bh=LZgCFy12fbN2Voh3zpiAgBHdfbOd9WdaxXEF7sBjEnM=;
        h=Date:To:From:Reply-To:Subject:In-Reply-To:References:Feedback-ID:
         From;
        b=ICuuNoWGUn7/3ko06hyfZEfK7FK7utF5OfrQi1lwsdkysvwLNFJjS62R3MTDhYEWL
         YmDnTgowjWllUZKZl57/IBxu9hy1kBqiUxLMdIvNkSqWeB1tfdVlMmTk025n0f8AoH
         jyIfNs/a+RHhnJIAIJmeImwreBZLUWgcISUlg7ro=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   berodual_xyz <berodual_xyz@protonmail.com>
Reply-To: berodual_xyz <berodual_xyz@protonmail.com>
Subject: Re: volumes.c:1762: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
Message-ID: <T4L8uzfFCkKlUCEdxlfLO__xJm-Mgx7cNxaG9f0MoHLC1J4iotdvlcyBvErwcHGYPhaH5v6PgW7dNdoRnKKYcLpydgp1LAOCc0kWuZcva8k=@protonmail.com>
In-Reply-To: <OBcqa2Fc0jqI9Dnn8nBkHh_ywiNByvFWAIUiQ9VSYP2TTQKacDXe-gmeqXmEeWg4JXwFN0abkfoVjdgfkkLj0-Z9SpinIg6uvM0ALCKkTY8=@protonmail.com>
References: <OBcqa2Fc0jqI9Dnn8nBkHh_ywiNByvFWAIUiQ9VSYP2TTQKacDXe-gmeqXmEeWg4JXwFN0abkfoVjdgfkkLj0-Z9SpinIg6uvM0ALCKkTY8=@protonmail.com>
Feedback-ID: I1q2L7VvFsdXESkLE1a2aLBALpN2HWsXO5F205qEARYXtg94zW3HdiV9HI52kzHEEqfcUdbqlfVMVRPA6rJltg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Adding to last email, being more brave to test out commands now:

Different crash than on last report.

Command:

# btrfs check --init-extent-tree --mode=3Dlowmem -p /dev/sdh

#########

$ btrfs check --init-extent-tree --mode=3Dlowmem -p /dev/sdh
WARNING: low-memory mode repair support is only partial
Opening filesystem to check...
Checking filesystem on /dev/sdh
UUID: 8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
Creating a new extent tree
Failed to find [6815744, 168, 16384]
btrfs unable to find ref byte nr 55431977238528 parent 0 root 10  owner 2 o=
ffset 0
Failed to find [6815744, 168, 16384]
btrfs unable to find ref byte nr 55431977254912 parent 0 root 10  owner 1 o=
ffset 0
Failed to find [6815744, 168, 16384]
btrfs unable to find ref byte nr 55431977271296 parent 0 root 10  owner 0 o=
ffset 0
Failed to find [6815744, 168, 16384]
btrfs unable to find ref byte nr 55431977287680 parent 0 root 10  owner 1 o=
ffset 0
Failed to find [6815744, 168, 16384]
btrfs unable to find ref byte nr 55431977304064 parent 0 root 10  owner 0 o=
ffset 0
parent transid verify failed on 55431977353216 wanted 60235 found 60236
Ignoring transid failure
Failed to find [55431977238528, 168, 16384]
btrfs unable to find ref byte nr 55431977320448 parent 0 root 1  owner 1 of=
fset 0
Failed to find [55431977238528, 168, 16384]
btrfs unable to find ref byte nr 55431977336832 parent 0 root 1  owner 0 of=
fset 0
Failed to find [55431977353216, 168, 16384]
btrfs unable to find ref byte nr 55431977369600 parent 0 root 1  owner 0 of=
fset 0
[1/7] checking root items... skipped
ERROR: extent[1048576 16384] backref lost (owner: 3, level: 1) root 3

## (shortened - same output repeating several times)

Added an extent item [1048576 16384]
Added one tree block ref start 1048576 root 3
ERROR: extent[1064960 16384] backref lost (owner: 3, level: 0) root 3
Added an extent item [1064960 16384]
Added one tree block ref start 1064960 root 3
ERROR: Dev extent's total-byte 15123666173952 is not equal to bytes-used 15=
121518690304 in dev[1, 204, 1]
ERROR: Dev extent's total-byte 15123687145472 is not equal to bytes-used 15=
121539661824 in dev[1, 204, 2]
ERROR: Dev extent's total-byte 15123653591040 is not equal to bytes-used 15=
121506107392 in dev[1, 204, 3]
ERROR: Dev extent's total-byte 15123653591040 is not equal to bytes-used 15=
121506107392 in dev[1, 204, 4]
ERROR: extent[1163264 16384] backref lost (owner: 3, level: 0) root 3
Added an extent item [1163264 16384]
Added one tree block ref start 1163264 root 3
ERROR: extent[1179648 16384] backref lost (owner: 3, level: 0) root 3
Added an extent item [1179648 16384]
Added one tree block ref start 1179648 root 3
ERROR: extent[1196032 16384] backref lost (owner: 3, level: 0) root 3
Added an extent item [55431977877504 16384]
Added one tree block ref start 55431977877504 root 1
ERROR: extent[55431977861120 16384] backref lost (owner: 10, level: 0) root=
 1
Added an extent item [55431977861120 16384]
Added one tree block ref start 55431977861120 root 1
ERROR: extent[54142438047744 16384] backref lost (owner: 10, level: 0) root=
 1
Added an extent item [54142438047744 16384]
Added one tree block ref start 54142438047744 root 1
ERROR: extent [54142438047744 16384] referencer bytenr mismatch, wanted: 54=
142438047744, have: 55432766324736
Delete backref in extent [54142438047744 16384]
Failed to find [55432521760768, 168, 16384]    (0:00:06 elapsed, 225 items =
checked)
btrfs unable to find ref byte nr 55432762015744 parent 0 root 10  owner 0 o=
ffset 0
transaction.c:168: btrfs_commit_transaction: BUG_ON `ret` triggered, value =
-5
btrfs[0x43ebef]
btrfs(btrfs_commit_transaction+0x89)[0x43f07a]
btrfs[0x47baec]
btrfs(check_chunks_and_extents_lowmem+0x1a4)[0x47c8b2]
btrfs(cmd_check+0x1e34)[0x460cd4]
btrfs(main+0x24a)[0x40ca02]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f6ce4825b35]
btrfs[0x40c509]
[1]    1049 abort      btrfs check --init-extent-tree --mode=3Dlowmem -p /d=
ev/sdh


###

And on another run of the same command, yet another crash:

###



ERROR: extent[34096057876480 16384] backref lost (owner: 1, level: 0) root =
1
Added an extent item [34096057876480 16384]
Added one tree block ref start 34096057876480 root 1
ERROR: extent[3543721410560 16384] backref lost (owner: 1, level: 0) root 1
Added an extent item [3543721410560 16384]
Added one tree block ref start 3543721410560 root 1
ERROR: extent[55432521760768 16384] backref lost (owner: 10, level: 0) root=
 1
Added an extent item [55432521760768 16384]
Added one tree block ref start 55432521760768 root 1
ERROR: extent[55431977877504 16384] backref lost (owner: 10, level: 0) root=
 1
Added an extent item [55431977877504 16384]
Added one tree block ref start 55431977877504 root 1
check/mode-lowmem.c:4588: walk_down_tree: Warning: assertion `1` failed, va=
lue 1
btrfs[0x478fb4]
btrfs(check_chunks_and_extents_lowmem+0x4b)[0x47c759]
btrfs(cmd_check+0x1e34)[0x460cd4]
btrfs(main+0x24a)[0x40ca02]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f348d9a4b35]
btrfs[0x40c509]
check/mode-lowmem.c:4588: walk_down_tree: Warning: assertion `1` failed, va=
lue 1
btrfs[0x478fb4]
btrfs(check_chunks_and_extents_lowmem+0x4b)[0x47c759]
btrfs(cmd_check+0x1e34)[0x460cd4]
btrfs(main+0x24a)[0x40ca02]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f348d9a4b35]
btrfs[0x40c509]
ERROR: extent[55432747909120 16384] backref lost (owner: 10, level: 1) root=
 1
Added an extent item [55432747909120 16384]
Added one tree block ref start 55432747909120 root 1
ctree.c:1725: leaf_space_used: Warning: assertion `data_len < 0` failed, va=
lue 1
btrfs[0x40cb13]
btrfs(btrfs_leaf_free_space+0x7f)[0x40ee06]
btrfs[0x474092]
btrfs[0x47906f]
btrfs(check_chunks_and_extents_lowmem+0x4b)[0x47c759]
btrfs(cmd_check+0x1e34)[0x460cd4]
btrfs(main+0x24a)[0x40ca02]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f348d9a4b35]
btrfs[0x40c509]
leaf is not a leaf 55432747909120
ERROR: extent [55431977877504 16384] referencer bytenr mismatch, wanted: 55=
431977877504, have: 55432766324736
Delete backref in extent [55431977877504 16384]
ERROR: extent [55432747909120 16384] referencer bytenr mismatch, wanted: 55=
432747909120, have: 55432766324736
Delete backref in extent [55432747909120 16384]
Failed to find [55432521760768, 168, 16384]
btrfs unable to find ref byte nr 55432746516480 parent 0 root 10  owner 0 o=
ffset 0
transaction.c:168: btrfs_commit_transaction: BUG_ON `ret` triggered, value =
-5
btrfs[0x43ebef]
btrfs(btrfs_commit_transaction+0x89)[0x43f07a]
btrfs[0x47baec]
btrfs(check_chunks_and_extents_lowmem+0x1a4)[0x47c8b2]
btrfs(cmd_check+0x1e34)[0x460cd4]
btrfs(main+0x24a)[0x40ca02]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f348d9a4b35]
btrfs[0x40c509]
[1]    1652 abort      btrfs check --init-extent-tree --mode=3Dlowmem -p /d=
ev/sdh



=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Sunday, March 31, 2019 4:21 PM, berodual_xyz <berodual_xyz@protonmail.co=
m> wrote:

> Dear list,
>
> following from earlier this weeks case of attempting data rescue on a cor=
rupt FS, we have now cloned all devices and can do potentially dangerous re=
scue attempts (since we can re-clone the original disks).
>
> On kernel 4.20.17 and btrfs-progs 4.20.2:
>
> --
>
> $ btrfs inspect-internal tree-stats /dev/sdh
> parent transid verify failed on 1048576 wanted 60234 found 60230
> parent transid verify failed on 1048576 wanted 60234 found 60230
> Ignoring transid failure
> volumes.c:1762: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
> btrfs[0x426fdc]
> btrfs(btrfs_chunk_readonly+0x98)[0x429acd]
> btrfs(btrfs_read_block_groups+0x1c1)[0x41cd44]
> btrfs(btrfs_setup_all_roots+0x368)[0x416540]
> btrfs[0x416a8a]
> btrfs(open_ctree_fs_info+0xd0)[0x416bcc]
> btrfs(open_ctree+0x75)[0x416c61]
> btrfs(cmd_inspect_tree_stats+0xfa)[0x4706ad]
> btrfs(handle_command_group+0x5d)[0x40c7b3]
> btrfs(cmd_inspect+0x15)[0x4499f1]
> btrfs(main+0x24a)[0x40ca02]
> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7f0f26c7cb35]
> btrfs[0x40c509]
> [1] 15273 abort btrfs inspect-internal tree-stats /dev/sdh
>
> ###
>
> $ btrfs rescue zero-log /dev/sdh
> parent transid verify failed on 1048576 wanted 60234 found 60230
> parent transid verify failed on 1048576 wanted 60234 found 60230
> Ignoring transid failure
> volumes.c:1762: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
> btrfs[0x426fdc]
> btrfs(btrfs_chunk_readonly+0x98)[0x429acd]
> btrfs(btrfs_read_block_groups+0x1c1)[0x41cd44]
> btrfs(btrfs_setup_all_roots+0x368)[0x416540]
> btrfs[0x416a8a]
> btrfs(open_ctree_fs_info+0xd0)[0x416bcc]
> btrfs(open_ctree+0x75)[0x416c61]
> btrfs[0x4657ff]
> btrfs(handle_command_group+0x5d)[0x40c7b3]
> btrfs(cmd_rescue+0x15)[0x465b98]
> btrfs(main+0x24a)[0x40ca02]
> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7f4507ab1b35]
> btrfs[0x40c509]
> [1] 30211 abort btrfs rescue zero-log /dev/sdh
>
> ###
>
> Even if we will not be able to recover the data, adding these traces here=
 hopefully helps enhancing the tools in the future as a crash is most defin=
itely not the "expected behavior".
>
> Have a nice weekend and I hope to receive some feedback.
>
> Thanks in advance,
>
> Marcel

