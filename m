Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:25668 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2GVPG2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jul 2012 11:06:28 -0400
Message-ID: <500C16F0.6000205@petaramesh.org>
Date: Sun, 22 Jul 2012 17:06:24 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Change "small" filesystem to normal
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've created a "small" BTRFS filesystem, where metadata+data are mixed
(and metadata are not DUP'ed).

Then I've enlarged the FS to 1 GB ; now I'd like to make it "normal"
with separate data and metadata, and "DUP'ed" metadata.

Is there a way tp do this without reformatting the FS ?

TIA, kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

