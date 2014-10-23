Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:41303 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbaJWPop (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 11:44:45 -0400
Message-ID: <5449226E.606@siedziba.pl>
Date: Thu, 23 Oct 2014 17:44:46 +0200
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: "Transaction commit" in btrfs sub del
References: <20141023202411.701bd1f3@natsu>
In-Reply-To: <20141023202411.701bd1f3@natsu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23.10.2014 16:24, Roman Mamedov wrote:
> I was under impression that the "Transaction commit:" setting in 'btrfs sub
> del' finally allows us to make it not return until all free space from the
> snapshots that are being deleted, is completely freed up.

This is not what "commit-each" or "commit-after" options do. These are 
only to make sure, that the deletion is commited and the subvolume 
doesn't reappear after a crash.

You probably want "subvolume sync" command, introduced in btrfs-progs 3.17:

btrfs subvolume sync <path> [<subvol-id>...]
         Wait until given subvolume(s) are completely removed from the 
filesystem.

Regards
