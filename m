Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:39720 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbaGQTBx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 15:01:53 -0400
Date: Thu, 17 Jul 2014 12:01:52 -0700
From: Zach Brown <zab@zabbo.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/1] Btrfs: fix sparse warning
Message-ID: <20140717190152.GB24196@lenny.home.zabbo.net>
References: <1405451837-8235-1-git-send-email-fabf@skynet.be>
 <20140716172021.GA10833@lenny.home.zabbo.net>
 <1762701571.679094.1405622254558.open-xchange@webmail.nmp.skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1762701571.679094.1405622254558.open-xchange@webmail.nmp.skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > > @@ -515,7 +515,8 @@ static int write_buf(struct file *filp, const void *buf,
> > > u32 len, loff_t *off)
> >
> > Though this probably wants to be rewritten in terms of kernel_write().
> > That'd give an opportunity to get rid of the sctx->send_off and have it
> > use f_pos in the filp.
> 
> Do you mean directly call kernel_write from send_cmd/send_header ?
> I guess that loop around vfs_write in write_buf is there for something ...

write_buf() could still exist to iterate over the buffer in the case of
partial writes but it doesn't need to muck around with set_fs() and
forcing casts.

- z
