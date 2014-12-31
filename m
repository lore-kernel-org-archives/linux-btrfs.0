Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.114.20]:60788 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaLaSRx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Dec 2014 13:17:53 -0500
Date: Wed, 31 Dec 2014 23:17:48 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: should I use btrfs on Centos 7 for a new production server?
Message-ID: <20141231231748.5db3dcea@natsu>
In-Reply-To: <pan$b5028$e294cf67$70ec31a2$f06c9aab@cox.net>
References: <20141230192910.50345rkrnf3a8akm@webmail.uniserve.com>
	<B12D4A1D-8EB5-4C9B-A8DC-7280D333E2BC@gmail.com>
	<D5E9E585-E843-4D79-A881-EB5863FB4F8B@gmail.com>
	<54A391D8.6020201@redhat.com>
	<CAG1y0seVZipbGtonxt2iFfNYO_8kzvQZgzJeYd-zJxHUCod+sQ@mail.gmail.com>
	<pan$b5028$e294cf67$70ec31a2$f06c9aab@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 31 Dec 2014 16:28:17 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> I also noticed that they mention reiserfs as btrfs-convert-ready.  That I 
> didn't know.  I thought btrfs-convert only supported ext*.

This might have been a mistake, or they have their own very special fork of it.

There is no sign of any ReiserFS support in 
http://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/tree/btrfs-convert.c

-- 
With respect,
Roman
