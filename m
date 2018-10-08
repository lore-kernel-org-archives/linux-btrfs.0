Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0214C65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 14:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80A7C2075C
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 14:27:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80A7C2075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbeJHVju (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:39:50 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:33518 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeJHVju (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 17:39:50 -0400
Received: from tux.wizards.de (p3EE2F45F.dip0.t-ipconnect.de [62.226.244.95])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 5FCB34160642
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 16:27:49 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 03552ED347C
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 16:27:48 +0200 (CEST)
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Curious problem: btrfs device stats & unpriviliged access
Organization: Applied Asynchrony, Inc.
Message-ID: <05c64256-71d3-81dc-3189-628e8cc0a5db@applied-asynchrony.com>
Date:   Mon, 8 Oct 2018 16:27:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

(moving the discussion here from GH [1])

Apparently there is something weird going on with the device stats
ioctls. I cannot get them to work as regular user, while they work
for David. A friend confirms the same issue on his system - no access
as non-root.

So I made a new empty fs, mounted it, built btrfs-progs-4.17.1 with
debug symbols and stepped into search_chunk_tree_for_fs_info().
Everything is fine, all args are correct, right until:

(gdb) s
1614	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &search_args);
(gdb) s
1615	if (ret < 0)
(gdb) p ret
$4 = -1
(gdb) p search_args
$5 = {key = {tree_id = 3, min_objectid = 1, max_objectid = 1, min_offset = 1,
max_offset = 18446744073709551615, min_transid = 0, max_transid = 18446744073709551615,
min_type = 216, max_type = 216, nr_items = 30, unused = 0, unused1 = 0, unused2 = 0,
unused3 = 0, unused4 = 0}, buf = '\000' <repeats 3991 times>}

Looking at the kernel side of things in fs/btrfs/ioctl.c I see both
BTRFS_IOC_TREE_SEARCH[_V2} unconditionally require CAP_SYS_ADMIN.

So why can Dave get his dev stats as unprivileged user?
Does this work for anybody else? And why? :)

cheers
Holger

[1] https://github.com/prometheus/node_exporter/issues/1100#issuecomment-427823190
