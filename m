Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailer.hiddenmail.net ([199.195.249.9]:39269 "EHLO
	mailer.hiddenmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbcBPBRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 20:17:03 -0500
Received: from mailer by mailer.hiddenmail.net with local (Exim 4.80)
	(envelope-from <angel@fs.16bits.net>)
	id 1aVTID-0006gv-Ng
	for linux-btrfs@vger.kernel.org; Tue, 16 Feb 2016 01:15:01 +0100
Message-ID: <1455581697.6951.9.camel@fs.16bits.net>
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
From: =?ISO-8859-1?Q?=C1ngel_Gonz=E1lez?= <angel@fs.16bits.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Tue, 16 Feb 2016 01:14:57 +0100
In-Reply-To: <1447365063.7045.7.camel@scientia.net>
References: <1447365063.7045.7.camel@scientia.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody

I have a btrfs filesystem [probably] created with btrfs-progs 4.3.1
that is also spewing some hundred of thousand «bad extent [x, y), type
mismatch with chunk» messages on btrfsck.

The data seems to be fine, so I expect it to be some kind of false
positive. Still, there seems to be disagreement on the list on whether
running btrfs --repair or not, plus I don't know if you may be
interested in getting more information of this.

Which should be my next steps?


Kind regards
