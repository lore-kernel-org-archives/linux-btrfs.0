Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49154 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719AbbLPBuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 20:50:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a91EC-0000KE-O9
	for linux-btrfs@vger.kernel.org; Wed, 16 Dec 2015 02:50:05 +0100
Received: from 14.139.238.2 ([14.139.238.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 02:50:04 +0100
Received: from coderinme by 14.139.238.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 02:50:04 +0100
To: linux-btrfs@vger.kernel.org
From: Manish <coderinme@outlook.com>
Subject: Re: Btrfs: check for empty bitmap list in =?utf-8?b?c2V0dXBfY2x1c3Rlcl9iaXRtYXBz?=
Date: Wed, 16 Dec 2015 01:48:01 +0000 (UTC)
Message-ID: <loom.20151216T024617-945@post.gmane.org>
References: <20151215170827.GA6322@ret.masoncoding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I have one coding comment for this patch.

Following line can be merged into single:
  if (!list_empty(bitmaps))
     entry = list_first_entry(bitmaps, struct btrfs_free_space, list);


new change as below-:

    entry = list_first_entry_or_null(bitmaps, struct btrfs_free_space,list);


Manish


