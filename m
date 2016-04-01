Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:24963 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcDAUyk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 16:54:40 -0400
From: "James Johnston" <johnstonj.public@codenest.com>
To: "'mitch'" <msfossen@gmail.com>, "'Duncan'" <1i5t5.duncan@cox.net>,
        <linux-btrfs@vger.kernel.org>
References: <001b01d188ac$16740630$435c1290$@codenest.com>	 <pan$284e3$6ee9615a$919b0339$15e3af27@cox.net>	 <003801d188fe$e8c9b920$ba5d2b60$@codenest.com>	 <CA+ve2MbcU8W_084oOo_JGToJB5XZ1cWnwW=wGhT2gp4fCZa30w@mail.gmail.com> <1459536804.8310.8.camel@gmail.com>
In-Reply-To: <1459536804.8310.8.camel@gmail.com>
Subject: RE: Compression causes kernel crashes if there are I/O or checksum errors (was: RE: kernel BUG at fs/btrfs/volumes.c:5519 when hot-removing device in RAID-1)
Date: Fri, 1 Apr 2016 20:54:40 -0000
Message-ID: <008e01d18c58$b6b793f0$2426bbd0$@codenest.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I grabbed this part from the log after the machine crashed again
> following trying to transfer a bunch of files that included ones with
> csum errors, let me know if this looks like the same issue you were
> having:
> 

Idk?  You hit a soft lockup, mine got a "kernel BUG at..."

Your stack trace diverges from mine after bio_endio.

James 



