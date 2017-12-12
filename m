Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50281 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752131AbdLLSjQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 13:39:16 -0500
Date: Tue, 12 Dec 2017 19:37:14 +0100
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs-progs: doc: remove explanation of 'X' attribute
Message-ID: <20171212183714.GQ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <6dabbe1b-87a2-77cd-4fca-9835a1573961@jp.fujitsu.com>
 <93de4c81-b80e-068c-3f4b-30860febc7fe@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <93de4c81-b80e-068c-3f4b-30860febc7fe@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 12, 2017 at 04:08:17PM +0900, Misono, Tomohiro wrote:
> e2fsprogs has removed compression support since v1.43 and there is no field
> 'X' (no compress) for lxattr now. So, just remove the explanation.

Hm right, I hoped that we could export the NOCOMP flag through
lsattr/chattr, but this relied on a compile-time compression support of
e2fsprogs.
