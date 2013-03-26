Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37262 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3CZSrO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 14:47:14 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C90269A0370
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 12:47:13 -0600 (MDT)
Date: Tue, 26 Mar 2013 14:47:11 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug on mismatching generation_v2 in inode.c:835
Message-ID: <20130326184711.GE28030@localhost.localdomain>
References: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com>
 <20130326144855.GM1955@localhost.localdomain>
 <CAAr69zbBXr_c1_xroqueHG0Zobo8H94a2p6kB+GTsZVfkFCtGg@mail.gmail.com>
 <20130326181713.GD28030@localhost.localdomain>
 <CAAr69zbgQn4sTSXw+AF69Pr78EDXVq7VM5uj90uHmnN5xxH5_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAAr69zbgQn4sTSXw+AF69Pr78EDXVq7VM5uj90uHmnN5xxH5_w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 12:25:44PM -0600, Szőts Ákos wrote:
> If my memory servers me well, it was taken in unmounted state. Do you
> want me to take an other one and compare the SHA1 values?

Nope I found the bug, just a problem with the restore.  Thanks,

Josef
