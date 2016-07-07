Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay02.ispgateway.de ([80.67.31.29]:59683 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbcGGJqZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 05:46:25 -0400
Received: from [77.13.69.70] (helo=hermione.invalid)
	by smtprelay02.ispgateway.de with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
	(Exim 4.84)
	(envelope-from <envelope@m-berberich.de>)
	id 1bL5t0-00069X-AS
	for linux-btrfs@vger.kernel.org; Thu, 07 Jul 2016 11:46:22 +0200
Received: from berberic by hermione.invalid with local (Exim 4.87)
	(envelope-from <envelope@m-berberich.de>)
	id 1bL5sz-0003Lg-SO
	for linux-btrfs@vger.kernel.org; Thu, 07 Jul 2016 11:46:21 +0200
Date: Thu, 7 Jul 2016 11:46:21 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: fstrim problem/bug
Message-ID: <20160707094621.GB7153@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On a filesystem with 40 G free space and 54 G used, ‘fstrim -v’ gave
this result:

    # fstrim -v /
    /: 0 B (0 bytes) trimmed

After running balance it gave a more sensible

    # fstrim -v /
    /: 37.3 GiB (40007368704 bytes) trimmed

As far as I understand, fstrim should report any unused block to the
disk, so its controller can reuse these blocks. I expected ’fstrim -v’
to report about 40 G trimmed. The fact, that after balance fstrim
reports a sensible amount of trimmed bytes leads to the conclusion,
that fstrim on btrfs does not report unused blocks to the disk (as it
should), but only the blocks of unused chunks. As the fstrim-command
only does a ‘ioctl(fd, FITRIM, &range))’ this seems to be a bug in the
fstrim kernel-code.
In the field this means, that without regularly running balance,
fstrim does not work on btrfs.

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | mail@m-berberich.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | 
