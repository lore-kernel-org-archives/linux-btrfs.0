Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938936AbcJXRFx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 13:05:53 -0400
Date: Mon, 24 Oct 2016 19:05:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Domagoj =?utf-8?B?VHLFoWFu?= <domagoj.trsan@gmail.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com
Subject: Re: [PATCH v2] btrfs: change btrfs_csum_final result param type to u8
Message-ID: <20161024170550.GF22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161021114702.29425-1-domagoj.trsan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20161021114702.29425-1-domagoj.trsan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 21, 2016 at 12:47:02PM +0100, Domagoj Tršan wrote:
> csum member of struct btrfs_super_block has array type of u8. It makes sense
> that function btrfs_csum_final should be also declared to accept u8 *. I
> changed the declaration of method void btrfs_csum_final(u32 crc, char *result);
> to void btrfs_csum_final(u32 crc, u8 *result);

Ok that's better, just the signed-off-by line is missing. I would add it
myself on behalf of contributors I know, but as a matter of practice,
fix it please and resend the patch.  Using the "git commit -s" adds the
line for you.

It is a formality, established in the linux kernel development. If you
need more explanatino what and why, please refer to the following docs.

http://elinux.org/Developer_Certificate_Of_Origin
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches
