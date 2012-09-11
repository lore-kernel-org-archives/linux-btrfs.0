Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65146 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2IKIf1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 04:35:27 -0400
Received: by lbbgj3 with SMTP id gj3so192962lbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 01:35:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <504ED7EA.903@gmx.net>
References: <504A4CBF.7000605@gmail.com>
	<504A6F67.3060506@gmx.net>
	<CAAdM646auV2U43HnoYG=32RipWU8hzaKa5RBNia+krCYWY6muA@mail.gmail.com>
	<504ED7EA.903@gmx.net>
Date: Tue, 11 Sep 2012 04:35:26 -0400
Message-ID: <CAAdM645dJhB8O0uXkCmDNWTnZ93rRN4r5nBgqyO9iSrdxUH4fA@mail.gmail.com>
Subject: Re: Cannot create subvolume with quota enabled
From: Marios Titas <redneb8888@gmail.com>
To: Arne Jansen <sensille@gmx.net>
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2012 at 2:19 AM, Arne Jansen <sensille@gmx.net> wrote:
>
> instead of applying my patch, could you please just revert
>
> commit 5986802c2fcc754040bb7ed95f30bb16c4a843b7
> Author: Dan Carpenter <dan.carpenter@oracle.com>
> Date:   Mon Jul 30 02:16:10 2012 -0600
>
>     Btrfs: fix some error codes in btrfs_qgroup_inherit()
>
> It introduces both faulty return codes.

Yes, reverting 5986802 and completely ignoring your earlier patch works.
