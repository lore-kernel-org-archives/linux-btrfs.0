Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:33961 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab2K3OEA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 09:04:00 -0500
Received: from [84.145.132.19] (helo=hermione.invalid)
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.68)
	(envelope-from <berberic@fmi.uni-passau.de>)
	id 1TeR5V-0006a0-CM
	for linux-btrfs@vger.kernel.org; Fri, 30 Nov 2012 14:57:05 +0100
Received: from berberic by hermione.invalid with local (Exim 4.80)
	(envelope-from <berberic@fmi.uni-passau.de>)
	id 1TeR5U-0004S3-AZ
	for linux-btrfs@vger.kernel.org; Fri, 30 Nov 2012 14:57:04 +0100
Date: Fri, 30 Nov 2012 14:57:04 +0100
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: Performance with lots of small files
Message-ID: <20121130135704.GF19186@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

how would btrfs perform with 200M files on a 3TByte-disk with up to
18K files in a directory? Ext4 performs very, very poor, would btrfs
do better?

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | berberic@fmi.uni-passau.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | www.fmi.uni-passau.de/~berberic
