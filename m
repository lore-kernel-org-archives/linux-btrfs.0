Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout05.t-online.de ([194.25.134.82]:52395 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2FFTOR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 15:14:17 -0400
Date: 06 Jun 2012 21:13:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CAMnMZB9CXB@helmut.hullen.de>
In-Reply-To: <20120606131458.GN15986@carfax.org.uk>
Subject: Re: New btrfs-progs integration branch
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 06.06.12:

>>>    The branch is fetchable with git from:
>>
>>> http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
>>> integration-20120605

>> gcc   convert.o   -o convert
>> convert.o: In function `btrfs_item_key':
>> /tmp/btrfs-progs-unstable/ctree.h:1404: undefined reference to
>> `read_extent_buffer' convert.o:

[...]
Solved - thanks for your help!

You have changed the Makefile;

        make convert

does not more work, it has changed to

        make btrfs-convert


-------------------------------

You can find the slackware binary at

  <http://helmut.hullen.de/filebox/Linux/slackware/ap/btrfs-progs-20120606-i486-1hln.txz>

Viele Gruesse!
Helmut
