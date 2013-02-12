Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:33984 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab3BLVjk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 16:39:40 -0500
Received: from [85.222.100.130] (zlom.siedziba.pl [85.222.100.130])
	by zlom.siedziba.pl (Postfix) with ESMTPSA id 2938988A2FB
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 22:39:37 +0100 (CET)
Message-ID: <511AB675.3070105@siedziba.pl>
Date: Tue, 12 Feb 2013 22:39:01 +0100
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs and LVM snapshots (Re: kernel BUG at fs/btrfs/extent-tree.c:1772)
References: <55e4fbbdada4ee37bdccac2537683d83.squirrel@lampka.siedziba.pl> <20130204165825.GC2275@localhost.localdomain> <c70388910a26ddb79b9f358e0ccb78f5.squirrel@lampka.siedziba.pl> <20130205135147.GD2275@localhost.localdomain> <5116EAA1.1030901@siedziba.pl> <5117A071.8060607@gmail.com>
In-Reply-To: <5117A071.8060607@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I can confirm that, even with a single-device btrfs filesystem. However
> I am curious why you want to use the lvm snapshot capability instead of
> the btrfs one.

You can't use btrfs snapshots on a broken FS. LVM snapshots would be 
useful to save the original state, before any potentially destructive 
repair attempts, and for further analysis.

Regards
