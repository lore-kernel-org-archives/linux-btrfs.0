Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:40210 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab2F0Nqh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 09:46:37 -0400
Date: Wed, 27 Jun 2012 09:46:34 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: fio reports data corruption with btrfs
Message-ID: <20120627134633.GA2819@localhost.localdomain>
References: <CAHf9xvafQugP2c_3_rxNAn55TgF_GiCM7udNS6yLEqVfPD1_wg@mail.gmail.com>
 <20120625192632.GF7404@localhost.localdomain>
 <CAHf9xvYGWvOCCUUte8Y29RG+G0aXAbKkE3up7r=2SDRLCRQKwg@mail.gmail.com>
 <CAHf9xvb2iGtyBY_28JexHa4w==Haiy4BN_e0qc2Df6Q+rBG98Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHf9xvb2iGtyBY_28JexHa4w==Haiy4BN_e0qc2Df6Q+rBG98Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2012 at 02:15:59AM -0600, Alex Lyakas wrote:
> Hi Josef,
> I have rerun the test with btrfs-next master branch. fio reported
> mismatched blocks again. Mount options were the same (-o
> noatime,nodatacow).
> 

Ok I'll try running it again here locally, I didn't realize it was nodatacow.
In the meantime can you try a newer version of fio, I'm running
fio-2.0.6-1.fc18.x86_64 but I think git is even newer than that.  Thanks,

Josef
