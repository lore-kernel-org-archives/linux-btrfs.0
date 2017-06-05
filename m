Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59063 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751077AbdFEQAT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Jun 2017 12:00:19 -0400
Date: Mon, 5 Jun 2017 17:59:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 1/2] Btrfs: lzo.c - compressed data size must be less
 then input size
Message-ID: <20170605155916.GW12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170529231805.4797-1-nefelim4ag@gmail.com>
 <20170529231805.4797-2-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170529231805.4797-2-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 30, 2017 at 02:18:04AM +0300, Timofey Titovets wrote:
> Logic already return error if compression
> make data bigger, let's sync logic with zlib
> and also return error if compressed size
> are equal to input size
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I've updated the changelog a bit.
