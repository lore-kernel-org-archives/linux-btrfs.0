Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:41241 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbcF0NdP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 09:33:15 -0400
Received: from [77.13.67.154] (helo=hermione.invalid)
	by smtprelay04.ispgateway.de with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
	(Exim 4.84)
	(envelope-from <envelope@m-berberich.de>)
	id 1bHWf1-0000nr-6G
	for linux-btrfs@vger.kernel.org; Mon, 27 Jun 2016 15:33:11 +0200
Received: from berberic by hermione.invalid with local (Exim 4.87)
	(envelope-from <envelope@m-berberich.de>)
	id 1bHWf0-0007Jl-SA
	for linux-btrfs@vger.kernel.org; Mon, 27 Jun 2016 15:33:10 +0200
Date: Mon, 27 Jun 2016 15:33:10 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Bug in 'btrfs filesystem du' ?
Message-ID: <20160627133310.GB11661@invalid>
References: <20160627132841.GA11661@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160627132841.GA11661@invalid>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, den 27. Juni schrieb M G Berberich:
> after a balance ‘btrfs filesystem du’ probably shows false data about
> shared data.

Oh, I forgot: I have btrfs-progs v4.5.2 and kernel 4.6.2.

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | mail@m-berberich.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | 
