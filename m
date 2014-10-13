Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:63352 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaJMMkD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 08:40:03 -0400
Received: by mail-la0-f46.google.com with SMTP id gi9so6507045lab.5
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 05:40:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <543B50F2.2010405@prnet.org>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com>
	<543A61EE.7070200@prnet.org>
	<CANg_oxzGu3SB4Es5tdB4+zsYJ231eWo878XUVPFcoRFM5wNBzA@mail.gmail.com>
	<543AF411.3090408@prnet.org>
	<543B50F2.2010405@prnet.org>
Date: Mon, 13 Oct 2014 14:40:01 +0200
Message-ID: <CANg_oxzzFT5A0Cmn0REAzB5Lm-Tjytp6gaFb5r=F5=zFY-t8Dg@mail.gmail.com>
Subject: Re: btrfs send and kernel 3.17
From: john terragon <jterragon@gmail.com>
To: David Arendt <admin@prnet.org>
Cc: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Actually it seems strange that a send operation could corrupt the
source subvolume or fs. Why would the send modify the source subvolume
in any significant way? The only way I can find to reconcile your
observations with mine is that maybe the snapshots get corrupted not
by the send operation by itself but when they are generated with -r
(readonly, as it is needed to send them). Are the corrupted snapshots
you have in machine 2 (the one in which send was never used) readonly?
