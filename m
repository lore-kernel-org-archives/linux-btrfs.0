Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout01.t-online.de ([194.25.134.80]:37677 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab3CUP6o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 11:58:44 -0400
Date: 21 Mar 2013 16:35:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CTGgK889CXB@helmut.hullen.de>
In-Reply-To: <CAKuK5J05iXaDd7Q4fLby9vJyPXBURx06xb0_--WmgTpJ0j2RoA@mail.gmail.com>
Subject: Re: btrfs-show vs. btrfs different output
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Jon,

Du meintest am 21.03.13:

> First btrfs-show (git):

> **
> ** WARNING: this program is considered deprecated
> ** Please consider to switch to the btrfs utility

"btrfs-show" makes nasty errors, especially together with "blkid".  
Delete "btrfs-show". That's the safe way.

Viele Gruesse!
Helmut
