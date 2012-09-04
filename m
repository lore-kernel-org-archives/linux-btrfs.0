Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:39697 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529Ab2IDJXO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Sep 2012 05:23:14 -0400
Message-ID: <5045C881.40402@jan-o-sch.net>
Date: Tue, 04 Sep 2012 11:23:13 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Suman C <schakrava@gmail.com>
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>
Subject: Re: Btrfs-Progs integration branch question
References: <CAPF83mvX6ueqaR62bvRygapGtw6RPuSTo1+oeYUrYAD0MPsULA@mail.gmail.com>
In-Reply-To: <CAPF83mvX6ueqaR62bvRygapGtw6RPuSTo1+oeYUrYAD0MPsULA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, September 03, 2012 at 18:31 (+0200), Suman C wrote:
> I am trying to integrate the quota patch from August 10th by Jan
> Schmidt and getting conflicts when I git apply.

I've rebased it on top of Chris' current master, you can pull from

	git://git.jan-o-sch.net/btrfs-progs qgroup

if you like.

Chris: probably saves you some minutes too if you just pull that one :-)

-Jan
