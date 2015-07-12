Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34635 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbbGLRPR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jul 2015 13:15:17 -0400
Received: by wibud3 with SMTP id ud3so12089448wib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2015 10:15:15 -0700 (PDT)
Message-ID: <D9085F65B8B44087B5F6144AC9356BBB@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
To: <linux-btrfs@vger.kernel.org>, <jbacik@fb.com>
Subject: question about should_cow_block() and BTRFS_HEADER_FLAG_WRITTEN
Date: Sun, 12 Jul 2015 19:15:13 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,
Looking at the code of should_cow_block(), I see:

if (btrfs_header_generation(buf) == trans->transid &&
    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN) &&
...
So if the extent buffer has been written to disk, and now is changed again 
in the same transaction, we insist on COW'ing it. Can anybody explain why 
COW is needed in this case? The transaction has not committed yet, so what 
is the danger of rewriting to the same location on disk? My understanding 
was that a tree block needs to be COW'ed at most once in the same 
transaction. But I see that this is not the case.

I am asking because I am doing some profiling of btrfs metadata work under 
heavy loads, and I see that sometimes btrfs COW's almost twice more tree 
blocks than the total metadata size.

Thanks,
Alex.

