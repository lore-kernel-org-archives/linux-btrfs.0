Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53167 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbdLDX35 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 18:29:57 -0500
Date: Tue, 5 Dec 2017 00:27:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] Btrfs: compress_file_range() change page dirty status
 once
Message-ID: <20171204232758.GF3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171023222948.10648-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171023222948.10648-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 24, 2017 at 01:29:48AM +0300, Timofey Titovets wrote:
> We need to call extent_range_clear_dirty_for_io()
> on compression range to prevent application from changing
> page content, while pages compressing.
> 
> extent_range_clear_dirty_for_io() run on each loop iteration,
> "(end - start)" can be much (up to 1024 times) bigger
> then compression range (BTRFS_MAX_UNCOMPRESSED).
> 
> That produce extra calls to page managment code.
> 
> Fix that behaviour by call extent_range_clear_dirty_for_io()
> only once.
> 
> v1 -> v2:
>  - Make that more obviously and more safeprone
> 
> v2 -> v3:
>  - Rebased on:
>    Btrfs: compress_file_range() remove dead variable num_bytes
>  - Update change log
>  - Add comments
> 
> v3 -> v4:
>  - Rebased on: kdave for-next
>  - To avoid dirty bit clear/set behaviour change
>    call clear_bit once, istead of per compression range

This version looks safe to me. There's no functional difference if we
redirty the pages repeatedly, but there's probably a noticeable runtime
difference if we do it just once.

Reviewed-by: David Sterba <dsterba@suse.com>
