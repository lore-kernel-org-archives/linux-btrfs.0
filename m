Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:23104 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaDJQYD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 12:24:03 -0400
Received: from fuchsia.localnet (p57A571D5.dip0.t-ipconnect.de [87.165.113.213])
	by smtp.strato.de (RZmta 32.33 DYNA|AUTH)
	with ESMTPSA id v01661q3AGO01dR
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Thu, 10 Apr 2014 18:24:00 +0200 (CEST)
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Copying a disk containing a btrfs filesystem
Date: Thu, 10 Apr 2014 18:24 +0200
Message-ID: <1924982.LHpDrRg8EQ@fuchsia>
In-Reply-To: <CAPpBBdNo0ar8+2Kt9O_mNyQsmmOvFNfVJ=a_EA1HW=TnS4uTXQ@mail.gmail.com>
References: <4783411.VVGoQz5kVU@fuchsia> <3414746.Gera7uWrI1@fuchsia> <CAPpBBdNo0ar8+2Kt9O_mNyQsmmOvFNfVJ=a_EA1HW=TnS4uTXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 10 April 2014 18:01:31 George Eleftheriou wrote:
> > What makes the case complicate is
> > not the question how to preserve and copy the current data; it's how
> > to retain the historic data embodied in snapshots.
> 
> You can always rsync (incrementally with --link-dest) to "another
> place" the sequence of snapshots, provided of course there is enough
> space in this "other place". However I understand this may not be the
> coolest thing to do especially taking into account the SMART warnings
> for imminent deterioration.

In the case at hand, I'll go with ddrescue. As far as backups are 
concerned, rsync --link-dest may be an option, however even at best it 
would only give file-granularity COW as opposed to block-granularity. 
I'm not sure if this would work for me in terms of disk space 
consumption.

I *think* send/receive with clone sources might be the key to a 
solution. I'm still hoping that someone with a far better understanding 
of btrfs than me gives it a try first...

Michael

-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/

