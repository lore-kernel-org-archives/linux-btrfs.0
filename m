Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:53347 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654AbaBUOoY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 09:44:24 -0500
Received: by mail-ea0-f172.google.com with SMTP id l9so1610412eaj.17
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 06:44:23 -0800 (PST)
Received: from linuxpc.localnet (178-190-154-74.adsl.highway.telekom.at. [178.190.154.74])
        by mx.google.com with ESMTPSA id d9sm27219164eei.9.2014.02.21.06.44.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 21 Feb 2014 06:44:22 -0800 (PST)
From: GEO <1g2e3o4@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup over writable snapshot
Date: Fri, 21 Feb 2014 15:44:17 +0100
Message-ID: <2333267.X1am0Dsk8s@linuxpc>
In-Reply-To: <2285169.jbztTl7OC0@linuxpc>
References: <17860756.QfG9CfNMqv@linuxpc> <EEA604EA-983B-4F5F-88B5-4FD229FEC61F@colorremedies.com> <2285169.jbztTl7OC0@linuxpc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First of all, I am sorry that I screw up the whole structure of the discussion 
(I have not subscribed to the mailing list, and as Kai replied to the mailing 
list only, I could not reply to his answer.)

Kai: Yeah, your point was neutral and I did never understand it otherwise. 
Thank you for your answer!
I already had idea of creating a subvolume called DATA in my home directory, 
however I find that pretty annoying, as most applications will open home by 
default. 
In fact I would find it more elegant to generally backup without making changes 
to my file system structure in home. 

I know that there other possibilities to do what I want, but I am asking 
whether the initially described method would work reliably, given that the 
user makes not a fundamental mistake himself. 
I know it may sound stubborn but I am really interested if my method works 
just as reliable as the other suggested methods.

As I am not having the level required to check the code myself, I am asking 
here, in the hope someone knowing the code could state if it should work or 
not. 

Thank you all for your help!
