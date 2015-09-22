Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:35838
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbbIVNxG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:53:06 -0400
Subject: Re: problem with long running btrfs mount operation
To: "S. Fricke" <silvio.fricke@gmail.com>, linux-btrfs@vger.kernel.org
References: <20150922133813.GA14395@sfserver>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56015D3F.8020406@googlemail.com>
Date: Tue, 22 Sep 2015 15:53:03 +0200
MIME-Version: 1.0
In-Reply-To: <20150922133813.GA14395@sfserver>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/15 15:38, S. Fricke wrote:
> I have a problem with one of my btrfs hdds. If I mount it, it needs more than
> 135 minutes for this operation. After the mounting it works normaly. This is
> reproducible only with this hdd.
> 
> Maybe someone has a clue what is going wrong here.

On remount it tries to continue a previously started balance, which fails with
an error (as can be seen at the end of your log). You should:

a) immediately stop what you're doing on that fs and unmount it
b) get btrfs-progs-4.2.1 (not 4.2) and see what it says

Depending on the outcome of b) you can use -o skip_balance on the next mount.

-h

