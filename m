Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47807 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752496AbcLHPN4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 10:13:56 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CC53DABDD
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Dec 2016 15:13:04 +0000 (UTC)
Date: Thu, 8 Dec 2016 16:13:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs-progs: Initialize ret to suppress compiler warning
Message-ID: <20161208151300.GH12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161201172820.1139-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161201172820.1139-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 01, 2016 at 11:28:20AM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>

The path that leaves ret unintialized goes through the second if block
and requires dback->found_ref to be 0. Quick search leads to several
places where it's set according to found items so we won't reach the for
loop with found_ref 0.

Cleaning up such compiler warnings is desired, but the fix description
should also say why it is ok to just set the value. Patch applied with
updated description.
