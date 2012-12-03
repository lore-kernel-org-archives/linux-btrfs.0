Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56356 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2LCQ6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2012 11:58:34 -0500
Message-ID: <50BCDA36.1050900@petaramesh.org>
Date: Mon, 03 Dec 2012 17:58:30 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Example of BTRFS uglyssima performance : Bitcoin
References: <50BC92F6.6050404@petaramesh.org> <50BCCB85.9010905@jan-o-sch.net>
In-Reply-To: <50BCCB85.9010905@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 03/12/2012 16:55, Jan Schmidt a écrit :
> Use ubuntu (which in the default setup means you're using ecryptfs for
> your /home),
I actually do not use ecryptfs here, but OTOH I have BTRFS over LUKS/LVM.

But I've been using pretty *anything over LUKS/LVM for years, and I've
never notice it cause any (noticeable to the point of becoming annoying)
system slowdown, whatever tasks I may have processed in such setups
(including servers, big databases, compilations, NAS, etc...)

So I doubt that the encryption is involved here... At least not very
heavily involved. But I may ask my son if he volunteers to test the same
on his unencrypted BTRFS netbook...

> Besides that, as Hugo told you, you can disable btrfs cow on the database files,
> but given my experiences I wouldn't put too much hope into that part.

As far as I understood, this option won't work unless I have a 3.7+
kernel...

BTW, what is the effect of "nocow" with respect to snapshots ? I would
assume that then, snapshots contain the current data ?

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

