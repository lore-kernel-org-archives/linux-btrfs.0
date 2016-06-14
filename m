Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:16141 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbcFNFvM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 01:51:12 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E694BAC0113
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 14:51:00 +0900 (JST)
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: doc: correct the destination of btrfs-receive
Message-ID: <491d91eb-0d51-b8ba-a046-61e2e392f06e@jp.fujitsu.com>
Date: Tue, 14 Jun 2016 14:50:19 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can set not only btrfs mount point but also any path belong to
btrfs mount point as btrfs-receive's destination.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
  Documentation/btrfs-receive.asciidoc | 6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/btrfs-receive.asciidoc b/Documentation/btrfs-receive.asciidoc
index fbbded2..e246603 100644
--- a/Documentation/btrfs-receive.asciidoc
+++ b/Documentation/btrfs-receive.asciidoc
@@ -7,14 +7,14 @@ btrfs-receive - receive subvolumes from send stream

  SYNOPSIS
  --------
-*btrfs receive* [options] <mount>
+*btrfs receive* [options] <path>

  DESCRIPTION
  -----------

  Receive a stream of changes and replicate one or more subvolumes that were
  previously used with *btrfs send* The received subvolumes are stored to
-'mount'.
+'path'.

  *btrfs receive* will fail int the following cases:

@@ -37,7 +37,7 @@ by default, btrfs receive uses standard input to receive the stream,
  use this option to read from a file instead

  -C|--chroot::
-confine the process to 'mount' using `chroot`(1)
+confine the process to 'path' using `chroot`(1)

  -e::
  terminate after receiving an 'end cmd' marker in the stream.
-- 
2.5.5
