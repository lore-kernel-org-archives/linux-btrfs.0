Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44974 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933734AbcJLOnW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 10:43:22 -0400
Date: Wed, 12 Oct 2016 16:43:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Domagoj =?utf-8?B?VHLFoWFu?= <domagoj.trsan@gmail.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com
Subject: Re: [PATCH] btrfs: change btrfs_csum_final result param type to u8
Message-ID: <20161012144319.GQ11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1474153835-6728-1-git-send-email-domagoj.trsan@gmail.com>
 <20160919172228.GN16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160919172228.GN16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2016 at 07:22:28PM +0200, David Sterba wrote:
> On Sun, Sep 18, 2016 at 12:10:34AM +0100, Domagoj Tršan wrote:
> > csum member of struct btrfs_super_block has array type of u8. It makes sense
> > that function btrfs_csum_final should be also declared to accept u8 *. I
> > changed the declaration of method void btrfs_csum_final(u32 crc, char *result);
> > to void btrfs_csum_final(u32 crc, u8 *result);
> 
> You should put a similar text to the patch itself, it's not necessary to
> send the cover letter for single patches. Otherwise the change is ok.

Please update the patch according to the above and resend.
