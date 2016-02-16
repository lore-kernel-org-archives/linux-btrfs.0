Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.knebb.de ([85.25.100.221]:33675 "EHLO mail.knebb.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622AbcBPTfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 14:35:38 -0500
Received: from [192.168.0.229] (p4FCEA20E.dip0.t-ipconnect.de [79.206.162.14])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: cvoelker)
	by mail.knebb.de (Postfix) with ESMTPSA id 8BB459C0418
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 20:24:35 +0100 (CET)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Christian_V=c3=b6lker?= <cvoelker@knebb.de>
Subject: [Docs]? Only one Subvolume with DUP (or different parameters)?
Message-ID: <56C377BB.9020101@knebb.de>
Date: Tue, 16 Feb 2016 20:25:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Guys,

sorry for the simple question and I assume every developer here laughs
about this question.

Anyway:

I have read loads of documents but did not find an answer for sure. Even
though I assume I am right.

On a btrfs filesystem created; is it possible to have subvolumes with
data duplication and another subvolume without (resp. with just metadata
duplication)?

I have some large filesystems currently with ext4 and I am thinking of
changing to btrfs. Some of the data is more important than others. So I
want to have data duplication on the important files (sorted in a mount
point) and without for the other subvolume.

So I want to have the advantage of redundancy of important files
combined with the flexibility of the volume manager and shared disk space.

Possible?


GReetings

Christian

