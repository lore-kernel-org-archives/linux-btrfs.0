Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:35956 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2HOKMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 06:12:34 -0400
Received: from 67.155.79.188.dynamic.jazztel.es ([188.79.155.67] helo=mail.viric.name)
	by mho-01-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1T1aaW-000DQj-Sg
	for linux-btrfs@vger.kernel.org; Wed, 15 Aug 2012 10:12:33 +0000
Date: Wed, 15 Aug 2012 12:12:29 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: State of nocow file attribute
Message-ID: <20120815101229.GH25996@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

some time ago we discussed on #btrfs that the nocow attribute for files wasn't
working (around 3.3 or 3.4 kernels). That was evident by files fragmenting even
with the attribute set.

Chris mentioned to find a fix quickly for that, and posted some lines of change
into irc. But recently someone mentioned that 3.6-rc looks like still not
respecting nocow for files.

Is there really a fix upstream for that? Do nocow attribute on files work for
anyone already?

Regards,
Lluís.
