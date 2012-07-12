Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:56296 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859Ab2GLSlq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 14:41:46 -0400
Message-ID: <4FFF1A68.2060003@jan-o-sch.net>
Date: Thu, 12 Jul 2012 20:41:44 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "daniel@quora.org" <daniel@quora.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "sensille@gmx.net" <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs: allow delayed refs to be merged
References: <1341946331-18058-1-git-send-email-jbacik@fusionio.com> <4FFD7D61.8070502@jan-o-sch.net> <20120712170521.GE2059@localhost.localdomain>
In-Reply-To: <20120712170521.GE2059@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12.07.2012 19:05, Josef Bacik wrote:
> Which test, 278 is an xfs specific test.  Thanks,

Oops. The test finally made it into xfstests-dev as 276.

Sorry,
-Jan
