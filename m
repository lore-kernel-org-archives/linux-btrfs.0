Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57431 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab2K3GEO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 01:04:14 -0500
Date: Fri, 30 Nov 2012 06:04:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Abhijit Pawar <abhi.c.pawar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [RESEND PATCH] fs/super.c set_anon_super calling optimization
Message-ID: <20121130060412.GG4939@ZenIV.linux.org.uk>
References: <CA+kxV1F5VxBGawhkV=02LcgHNWiKF-H_k6N-d1TEYNeFAScezg@mail.gmail.com>
 <508924AB.4060902@gmail.com>
 <20121026131441.GA22256@andromeda.usersys.redhat.com>
 <20121130040556.GD4939@ZenIV.linux.org.uk>
 <50B846B2.9040700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50B846B2.9040700@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 30, 2012 at 11:10:02AM +0530, Abhijit Pawar wrote:

> > 	Because we want it to be a valid sget() callback.  I doubt that this
> > optimization is worth doing, though - might even micro-pessimize the things
> > on architectures where all arguments are passed in registers.
> > 
> Al,
> Yes. it will be helpful in registers case.

How so?  Consider something like
static int btrfs_set_super(struct super_block *s, void *data)
{
        int err = set_anon_super(s, data);
        if (!err)
                s->s_fs_info = data;
        return err;
}
Compile it e.g. for alpha.  Or powerpc.  Or amd64, for that matter.
With and without your change.  And compare the resulting assembler.

Hell, if the arguments are passed in register, without your patch
we have the args for set_anon_super() all set just as we enter
btrfs_set_super().  With your patch the second one needs to be zeroed
out...

In any case, that's microoptimization in the best case and on quite a few
architectures it's a pessimization (granted, an equally minor one).
