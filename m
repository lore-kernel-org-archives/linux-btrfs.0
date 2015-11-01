Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31715 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbbKANpP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 08:45:15 -0500
Subject: Re: Crash during mount -o degraded, kernel BUG at
 fs/btrfs/extent_io.c:2044
To: Philip Seeger <p0h0i0l0i0p@gmail.com>,
        Erik Berg <btrfs@slipsprogrammoer.no>, linux-btrfs@vger.kernel.org
References: <n0bqib$2om$1@ger.gmane.org> <5635140F.7040206@googlemail.com>
From: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.cz>
Message-ID: <56361756.4060705@oracle.com>
Date: Sun, 1 Nov 2015 21:44:54 +0800
MIME-Version: 1.0
In-Reply-To: <5635140F.7040206@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> This is misleading, these error messages might make one think that the
> 4th drive is bad and has to be replaced, which would reduce the
> redundancy to the minimum because it's the second drive that's actually
> bad.

following RFC will solve the misleading part of the problem..

     [RFC PATCH] Btrfs: fix fs logging for multi device

Thanks, Anand
