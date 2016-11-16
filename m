Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49287 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753151AbcKPQiM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 11:38:12 -0500
Date: Wed, 16 Nov 2016 17:38:06 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Domagoj =?utf-8?B?VHLFoWFu?= <domagoj.trsan@gmail.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Subject: Re: [PATCH v3] btrfs: change btrfs_csum_final result param type to u8
Message-ID: <20161116163806.GX12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161027075233.4050-1-domagoj.trsan@gmail.com>
 <20161031164724.GR12522@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20161031164724.GR12522@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2016 at 05:47:24PM +0100, David Sterba wrote:
> On Thu, Oct 27, 2016 at 08:52:33AM +0100, Domagoj Tršan wrote:
> > csum member of struct btrfs_super_block has array type of u8. It makes sense
> > that function btrfs_csum_final should be also declared to accept u8 *. I
> > changed the declaration of method void btrfs_csum_final(u32 crc, char *result);
> > to void btrfs_csum_final(u32 crc, u8 *result);
> 
> Sorry, I've noticed it just now, several callers of btrfs_csum_final
> cast the 2nd argument to (char *), which gets change to u8. Can you
> please fix the callers? Thanks.

Done and committed.
