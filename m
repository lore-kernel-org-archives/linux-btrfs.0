Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailsec109.isp.belgacom.be ([195.238.20.105]:38334 "EHLO
	mailsec109.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932841AbaHEJU1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Aug 2014 05:20:27 -0400
Date: Tue, 5 Aug 2014 11:20:25 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Zach Brown <zab@zabbo.net>
Cc: Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Message-ID: <2069847253.202465.1407230425329.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140804183158.GA18659@lenny.home.zabbo.net>
References: <1405451837-8235-1-git-send-email-fabf@skynet.be> <20140716172021.GA10833@lenny.home.zabbo.net> <1762701571.679094.1405622254558.open-xchange@webmail.nmp.skynet.be> <20140717190152.GB24196@lenny.home.zabbo.net> <20140802142449.15f4cfc2c2821e90e04e175e@skynet.be> <20140804183158.GA18659@lenny.home.zabbo.net>
Subject: Re: [PATCH 1/1] Btrfs: fix sparse warning
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> On 04 August 2014 at 20:31 Zach Brown <zab@zabbo.net> wrote:
>
>
> On Sat, Aug 02, 2014 at 02:24:49PM +0200, Fabian Frederick wrote:
> > On Thu, 17 Jul 2014 12:01:52 -0700
> > Zach Brown <zab@zabbo.net> wrote:
> >
> > > > > > @@ -515,7 +515,8 @@ static int write_buf(struct file *filp, const
> > > > > > void *buf,
> > > > > > u32 len, loff_t *off)
> > > > >
> > > > > Though this probably wants to be rewritten in terms of kernel_write().
> > > > > That'd give an opportunity to get rid of the sctx->send_off and have
> > > > > it
> > > > > use f_pos in the filp.
> > > >
> > > > Do you mean directly call kernel_write from send_cmd/send_header ?
> > > > I guess that loop around vfs_write in write_buf is there for something
> > > > ...
> > >
> > > write_buf() could still exist to iterate over the buffer in the case of
> > > partial writes but it doesn't need to muck around with set_fs() and
> > > forcing casts.
> > >
> > > - z
> >
> > Hello Zach,
> >
> >     Here's an untested patch which
>
> Try testing it.  It's easy with virtualization and xfstests.
>
> You'll find that sending to a file fails because each individual file
> write call that makes up a send starts at offset 0 -- at the start of
> the file.
>
> Getting this right means getting the semantics around updating the send
> descriptors f_pos right.  It requires having a bit of a think about send
> semantics and f_pos update locking.

Thanks for those informations Zach,

I've tried btrfs test scripts related to ioctl in xfstests (tests/btrfs/025,
035, 052, 055)
but was not able to trigger that problem. Do I have to create another script,
use some generic one
or maybe use big test/scratch devices ?

Regards,
Fabian
>
> - z
