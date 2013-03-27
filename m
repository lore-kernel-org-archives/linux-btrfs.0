Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:43547 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3C0Mt4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 08:49:56 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B65989A0645
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 06:49:55 -0600 (MDT)
Date: Wed, 27 Mar 2013 08:49:53 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug on mismatching generation_v2 in inode.c:835
Message-ID: <20130327124953.GH28030@localhost.localdomain>
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

Sorry I was flipping between your problem and somebody elses problem yesterday
and I was having trouble restoring your file system from the image.  Today I
only have your problem and I'm almost done fixing this bug in the restore so I
should have something for you today, hopefully before lunch.  Thanks,

Josef
