Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:55281
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbIPKqJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 06:46:09 -0400
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
To: =?UTF-8?Q?St=c3=a9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
 <532aadf0f92d08d3d2b274173548aee1@all.all>
 <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
 <f81878fadaf2980a72522e54010e0415@all.all>
Cc: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <55F9486F.4040302@googlemail.com>
Date: Wed, 16 Sep 2015 12:46:07 +0200
MIME-Version: 1.0
In-Reply-To: <f81878fadaf2980a72522e54010e0415@all.all>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/16/15 12:28, Stéphane Lesimple wrote:
> Nice to know that this bug was already somewhat known, but I can
> confirm that it actually doesn't come from an ext4 conversion on my
> case.

In that case the "crossing stripe boundary" messages are false positives
in btrfs-progs-4.2: http://www.spinics.net/lists/linux-btrfs/msg47059.html

This should be fixed in the next release.

-h

