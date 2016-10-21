Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34873 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754641AbcJULvU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 07:51:20 -0400
Received: by mail-qk0-f196.google.com with SMTP id v138so6893070qka.2
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Oct 2016 04:51:20 -0700 (PDT)
Date: Fri, 21 Oct 2016 12:51:17 +0100
From: Domagoj =?utf-8?B?VHLFoWFu?= <domagoj.trsan@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Subject: Re: [PATCH] btrfs: change btrfs_csum_final result param type to u8
Message-ID: <20161021115117.cuh6x7o3s3ow6pte@nemesis>
References: <1474153835-6728-1-git-send-email-domagoj.trsan@gmail.com>
 <20160919172228.GN16983@twin.jikos.cz>
 <20161012144319.GQ11398@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20161012144319.GQ11398@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-12 16:43 +0200, David Sterba wrote:
> On Mon, Sep 19, 2016 at 07:22:28PM +0200, David Sterba wrote:
> > On Sun, Sep 18, 2016 at 12:10:34AM +0100, Domagoj Tršan wrote:
> > > csum member of struct btrfs_super_block has array type of u8. It makes sense
> > > that function btrfs_csum_final should be also declared to accept u8 *. I
> > > changed the declaration of method void btrfs_csum_final(u32 crc, char *result);
> > > to void btrfs_csum_final(u32 crc, u8 *result);
> > 
> > You should put a similar text to the patch itself, it's not necessary to
> > send the cover letter for single patches. Otherwise the change is ok.
> 
> Please update the patch according to the above and resend.

Hi David,

apologies for the delay. I sent the new version patch.

Cheers!


-- 
(\/)(;,,;)(\/)

