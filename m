From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: Question of stability
Date: Mon, 20 Sep 2010 11:00:08 +0000 (UTC)
Message-ID: <i77ero$lja$1@dough.gmane.org>
References: <7280394.123.1284845879623.JavaMail.root@zimbra>
	<4C96B682.5080900@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

No, not stable!

Again, after powerloss, I have *two* damaged btrfs filesystems.

/home and also the backup volume, as the backup was running :(

Both show
parent transid verify failed on .... wanted ..... found ....

and the volumes cannot be mounted.

So until there is a way to somehow recover from this type of failures,
speaking about stability is a joke

Lubos Kolouch

