Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43613 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760025Ab3B0ObL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 09:31:11 -0500
MIME-Version: 1.0
In-Reply-To: <20130227132736.GH19641@localhost.localdomain>
References: <20130227052247.GA20213@redhat.com>
	<20130227132736.GH19641@localhost.localdomain>
Date: Wed, 27 Feb 2013 15:31:11 +0100
Message-ID: <CAFDW0jK6zigx0YgVMHomUkRQkqpw5mUgkdeynv36LUiQn4XTxg@mail.gmail.com>
Subject: Re: btrfs crash when low on memory.
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Yeah we have a lot of
>
> ptr = kmalloc();
> BUG_ON(ptr);
>
> everywhere.  I'll fix this one up but I really need to sit down and go through
> all of them and make sure we do the right thing in all these places.  Thanks,

But what would be the right thing to do when you got no memory?
Spinlock until you can kmalloc? Pre-reserve some memory?

At the moment im using:

vm.min_free_kbytes = 65536

Which helps most of the time and i think is the better way to handle
this kind of Situation.

Ahmet
