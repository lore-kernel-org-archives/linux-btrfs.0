Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35262 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbcCOQA4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 12:00:56 -0400
Received: by mail-ig0-f174.google.com with SMTP id vf5so91294048igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 09:00:55 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 15 Mar 2016 16:00:55 +0000
Message-ID: <CABxShh-vwxqU5wq+Ouhn8H6ye=7wV4VgNx+fL2JM30H7=i0rWg@mail.gmail.com>
Subject: btrfs error
From: Paul Harrison <paulharrisonsipad@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm new to btrfs, and have just taken over management of this system; can
anyone point me in the right direction with regard to the following error:

BTRFS error (device sda3): unable to find ref byte nr 402100224 parent 0
root 256 owner 1 offset
btrfs: Transaction aborted (error -2)
BTRFS error (device sda3) in _btrfs_free_extent:5696: errno=-2 No such entry
BTRFS error (device sda3) in btrfs_run_delayed_refs:2681: errno=-2 No such
entry
BTRFS error (device sda3) in cleanup_transaction:1530: errno=-2 No such
entry
iTCO_wdt: probe of iTCO_wdt failed with error -16

The filesystem is now read-only, can I recover from this?

I am running SUSE Linux Enterprise 11 SP4 64-bit.

Thanks in advance,

Paul
