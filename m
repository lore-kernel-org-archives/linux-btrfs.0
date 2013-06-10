Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:34573 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab3FJHrr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 03:47:47 -0400
Date: Mon, 10 Jun 2013 16:47:31 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs quota examples?
Message-ID: <20130610164731.29b2d6c6@virtall.com>
In-Reply-To: <51B58333.3050901@gmx.net>
References: <20130610152127.38fb8a50@virtall.com>
	<51B58333.3050901@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 10 Jun 2013 09:41:39 +0200
Arne Jansen <sensille@gmx.net> wrote:

> > Now, my questions:
> > 
> > - what do both 104882176 104882176 numbers represent?
> 
> The first number represents the amount of data in that subvolume,
> regardless whether that data is shared with other subvolumes or
> not.
> The second number shows the amount of data that is unique to this
> subvolume and not shared with others, i.e. the amount of space
> that will get freed if you delete this subvolume.

Both numbers are bytes, correct?

-- 
Tomasz Chmielewski
htp://wpkg.org

