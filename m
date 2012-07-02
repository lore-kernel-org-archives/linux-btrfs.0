Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:56395 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2GBMtj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 08:49:39 -0400
Date: Mon, 2 Jul 2012 08:49:37 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: fio reports data corruption with btrfs
Message-ID: <20120702124937.GC6185@localhost.localdomain>
References: <CAHf9xvafQugP2c_3_rxNAn55TgF_GiCM7udNS6yLEqVfPD1_wg@mail.gmail.com>
 <20120625192632.GF7404@localhost.localdomain>
 <CAHf9xvYGWvOCCUUte8Y29RG+G0aXAbKkE3up7r=2SDRLCRQKwg@mail.gmail.com>
 <CAHf9xvb2iGtyBY_28JexHa4w==Haiy4BN_e0qc2Df6Q+rBG98Q@mail.gmail.com>
 <20120627134633.GA2819@localhost.localdomain>
 <CAHf9xvY7eoDA6BSAwz+-Nbn0hzC89N5EPS-KJ=qXfvyJ2q2b5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHf9xvY7eoDA6BSAwz+-Nbn0hzC89N5EPS-KJ=qXfvyJ2q2b5A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2012 at 05:48:43AM -0600, Alex Lyakas wrote:
> Hi Josef,
> which branch from your (or another?) repo should I try this on:
> 

Master, and make sure you've checked out a more recent fio from git to make sure
it's not a bug in fio.  Thanks,

Josef
