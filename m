Return-Path: <SRS0=0DI8=CJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500C2C433E2
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 02:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F8EF2078D
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 02:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgHaCUU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 22:20:20 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:35752 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgHaCUU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Aug 2020 22:20:20 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id B9F2A1F66E;
        Mon, 31 Aug 2020 02:20:19 +0000 (UTC)
Date:   Mon, 31 Aug 2020 02:20:19 +0000
From:   Eric Wong <e@80x24.org>
To:     Hamish Moffatt <hamish-btrfs@moffatt.email>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: new database files not compressed
Message-ID: <20200831022019.GA27823@dcvr>
References: <6992fae3-ce87-8ae1-8dfe-1cb65578a16a@moffatt.email>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6992fae3-ce87-8ae1-8dfe-1cb65578a16a@moffatt.email>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hamish Moffatt <hamish-btrfs@moffatt.email> wrote:
> I am trying to store Firebird database files compressed on btrfs. Although I
> have mounted the file system with -o compress-force, new files created by
> Firebird are not being compressed according to compsize. If I copy them, or
> use btrfs filesystem defrag, they compress well.
> 
> Other files seem to be compressed automatically OK. Why are the Firebird
> files different?

Maybe Firebird creates DB with the No_COW attribute?
"lsattr -l /path/to/file" to check.

I don't know much about Firebird; but No_COW is pretty much
required for big database, VM images, etc which are subject to
random writes.  Unfortunately, neither compression nor
checksumming are available with No_COW set.

Big SQLite and Xapian DBs gave me trouble even on an SSD before
I recreated them with No_COW.  Small DBs can probably get away
with autodefrag.
