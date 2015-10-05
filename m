Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:54332
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbbJEQEu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 12:04:50 -0400
Subject: Re: Issues with unmountable BTRFS raid1 filesystem
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <56126D59.7070505@gmail.com>
 <20151005131426.GP25907@carfax.org.uk> <561286F2.40607@gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56129F9F.4020006@googlemail.com>
Date: Mon, 5 Oct 2015 18:04:47 +0200
MIME-Version: 1.0
In-Reply-To: <561286F2.40607@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/05/15 16:19, Austin S Hemmelgarn wrote:
> If so, that's good news (that is, that it's just a mkfs bug). I guess

It is, both in mkfs and check.

> it's time for me to quit waiting around for Gentoo to package the
> newest version and build it myself.

Copy away:
https://github.com/hhoffstaette/portage/tree/master/sys-fs/btrfs-progs

;)

-h

