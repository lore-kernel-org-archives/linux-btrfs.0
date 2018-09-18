Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f173.google.com ([209.85.208.173]:38340 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729923AbeIRXoM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 19:44:12 -0400
Received: by mail-lj1-f173.google.com with SMTP id p6-v6so2630892ljc.5
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 11:10:24 -0700 (PDT)
Subject: Re: btrfs receive incremental stream on another uuid
To: "Gervais, Francois" <FGervais@distech-controls.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <BN6PR01MB2531F06B0557C31005C5E6E7F31D0@BN6PR01MB2531.prod.exchangelabs.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <eeba538c-bcc1-8f70-c9b7-b277eec57b36@gmail.com>
Date: Tue, 18 Sep 2018 21:10:21 +0300
MIME-Version: 1.0
In-Reply-To: <BN6PR01MB2531F06B0557C31005C5E6E7F31D0@BN6PR01MB2531.prod.exchangelabs.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

18.09.2018 20:56, Gervais, Francois пишет:
> 
> Hi,
> 
> I'm trying to apply a btrfs send diff (done through -p) to another subvolume with the same content as the proper parent but with a different uuid.
> 
> I looked through btrfs receive and I get the feeling that this is not possible right now.
> 
> I'm thinking of adding a -p option to btrfs receive which could override the parent information from the stream.
> 
> Would that make sense?
> 
No. It is already possible (by setting received UUID); it should not be
made too open to easy abuse.
