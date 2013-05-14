Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48051 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab3ENIcs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 04:32:48 -0400
Received: by mail-ea0-f182.google.com with SMTP id r16so153870ead.13
        for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 01:32:46 -0700 (PDT)
Received: from [192.168.3.130] ([194.9.67.191])
        by mx.google.com with ESMTPSA id w52sm27884274eev.12.2013.05.14.01.32.45
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 14 May 2013 01:32:45 -0700 (PDT)
Message-ID: <5191F6AB.6020106@statystyka.net>
Date: Tue, 14 May 2013 10:32:43 +0200
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BTRFS in laptop-mode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Welcome,

What are perspectives on BTRFS complying with laptop-mode and stop 
writing to disk every 30 sec?

The thread was asked several years before 
(http://mailman.samwel.tk/pipermail/laptop-mode/2012-February/000520.html), 
but time went by and maybe the situation became a little more on the 
bright side...? With kernel 3.8.11 I can still see with lm-profiler a 
lot of "btrfs-transacti" and ""btrfs-submit-1" events, roughly once 
every 30 sec.

Is there any tunable switch, that can delay such writes to, say, 15 
minutes, or better yet: until the disk started spinning anyway?

-- 

Adam Ryczkowski
+48505919892 <callto:+48505919892>
Skype:sisteczko <skype:sisteczko>

