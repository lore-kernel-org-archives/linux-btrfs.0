Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:37539 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab3G2IFX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 04:05:23 -0400
Date: Mon, 29 Jul 2013 15:05:10 +0700
From: Tomasz Chmielewski <tch@virtall.com>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs quota examples?
Message-ID: <20130729150510.19e5886a@virtall.com>
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

I've played with qgroups for some time, but the results are rather
inconsistent.

I.e. here - what does a negative number represent in 0/1181 row?

# btrfs qgroup show /mnt/lxc2
0/260 151490953216 151490953216
0/261 180969472 180969472
0/262 155557888 983040
0/377 180310016 25776128
0/378 304088072192 304088072192
0/535 571944960 417370112
0/536 68550987776 68550987776
0/642 247463936 92921856
0/1175 617213952 827392
0/1181 16112013312 -22184235008
0/1268 38296248320 0
0/1269 616386560 0
0/1270 4096 4096
0/1271 4096 4096


-- 
Tomasz Chmielewski
http://wpkg.org
