Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872AAC43217
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 May 2022 21:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353653AbiETV16 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 May 2022 17:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353641AbiETV14 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 May 2022 17:27:56 -0400
Received: from savella.carfax.org.uk (2001-ba8-1f1-f0e6-0-0-0-2.autov6rev.bitfolk.space [IPv6:2001:ba8:1f1:f0e6::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034C4186281
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2022 14:27:55 -0700 (PDT)
Received: from hrm by savella.carfax.org.uk with local (Exim 4.92)
        (envelope-from <hrm@savella.carfax.org.uk>)
        id 1nsAA4-0006me-2f; Fri, 20 May 2022 22:27:52 +0100
Date:   Fri, 20 May 2022 22:27:51 +0100
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Neko-san <nekoNexus@proton.me>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [Help Please] Missing FIle Permissions Irrecoverably
Message-ID: <20220520212751.GE22627@savella.carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Neko-san <nekoNexus@proton.me>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <LQBIObJ0wXAJiClnJItZ5QlGJPGLx5G3_cbQYB6Yle5t7wg7-MX233_rkpCs_ybzN9-DWoQBSlPD6EZRa6HDjdo6PWJjFWO0qb4XB7UsK1E=@proton.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LQBIObJ0wXAJiClnJItZ5QlGJPGLx5G3_cbQYB6Yle5t7wg7-MX233_rkpCs_ybzN9-DWoQBSlPD6EZRa6HDjdo6PWJjFWO0qb4XB7UsK1E=@proton.me>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, May 20, 2022 at 09:13:25PM +0000, Neko-san wrote:
> Greetings,
> 
> I'm having a pretty severe issue right now where I don't have permission access to many of the files / directories on my system (namely my home folder and some others) and superuser privileges aren't helping to fix these issues. I'd really like to not have to reinstall Arch Linux just because of this... I'd appreciate assistance...
> 
> I have no idea what's caused it and this is the only sensible conclusion I've been able to come to thus far...
> 
> ```
> neko-san@ARCH ~> btrfs check --readonly --progress /dev/nvme0n1p2
> Opening filesystem to check...
> ERROR: /dev/nvme0n1p2 is currently mounted, use --force if you really intend to check the filesystem

   You can't expect an fsck on a mounted filesystem to produce any useful output.

> neko-san@ARCH ~ [1]> btrfs check --readonly --progress --force /dev/nvme0n1p2

   ... and so this is useless, I'm afraid.

[snip]

> [ 1646.159335] systemd-journald[387]: Failed to rotate /var/log/journal/63f413b0af0c43ae9345a082aaf00bd3/user-1000.journal: Read-only file system

   That would be a read-only filesystem, then. Most likely caused by
some serious error on the FS, which caused it to go read-only to
protect itself. You'll have to go back in dmesg to see what happened
to cause that. There's most likely a kernel oops in there at around
the same time that the systemd journal started spewing those errors.

   Hugo.

-- 
Hugo Mills             | You shouldn't anthropomorphise computers. They
hugo@... carfax.org.uk | really don't like that.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |
