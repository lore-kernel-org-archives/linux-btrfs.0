Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750971AbcISRgq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 13:36:46 -0400
Date: Mon, 19 Sep 2016 19:34:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Domagoj =?utf-8?B?VHLFoWFu?= <domagoj.trsan@gmail.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com
Subject: Re: [PATCH] btrfs-progs: change btrfs_csum_final result param type
 to u8
Message-ID: <20160919173450.GO16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1474153823-6671-1-git-send-email-domagoj.trsan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1474153823-6671-1-git-send-email-domagoj.trsan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 18, 2016 at 12:10:22AM +0100, Domagoj Tršan wrote:
> csum member of struct btrfs_super_block has array type of u8. It makes sense
> that function btrfs_csum_final should be also declared to accept u8 *. I
> changed the declaration of method void btrfs_csum_final(u32 crc, char *result);
> to void btrfs_csum_final(u32 crc, u8 *result);
> Also, I changed definitions of various csum variables to be consistent with
> kernel code.

Aligning the progs code with kernel is useful, even the seemingly
trivial changes (through there will be always some differences). Feel
free to send more patches like that.

Patch applied, thanks.
