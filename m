Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36532 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3C0N6b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 09:58:31 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 29C787C0681
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 07:58:31 -0600 (MDT)
Date: Wed, 27 Mar 2013 09:58:28 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug on mismatching generation_v2 in inode.c:835
Message-ID: <20130327135828.GI28030@localhost.localdomain>
References: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com>
 <20130326144855.GM1955@localhost.localdomain>
 <CAAr69zbBXr_c1_xroqueHG0Zobo8H94a2p6kB+GTsZVfkFCtGg@mail.gmail.com>
 <20130326181713.GD28030@localhost.localdomain>
 <CAAr69zbgQn4sTSXw+AF69Pr78EDXVq7VM5uj90uHmnN5xxH5_w@mail.gmail.com>
 <20130326184711.GE28030@localhost.localdomain>
 <CAAr69zaZNe7u1=MEmwYZBt20H8O9-Ybe-_CMjZ-2pnKsDUBcMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAAr69zaZNe7u1=MEmwYZBt20H8O9-Ybe-_CMjZ-2pnKsDUBcMg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 27, 2013 at 05:51:32AM -0600, Szőts Ákos wrote:
> What do you think; is this issue in the file system can be repaired
> with btrfsck? Or should I install a new, patched kernel on my
> partition somehow?

Ok I've successfully restored your image and I've reproduced your problem, I
will let you know when I've fixed it.  Thanks,

Josef
