Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:44023 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3KPO6t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 09:58:49 -0500
Message-ID: <528787FB.4040100@czarc.net>
Date: Sat, 16 Nov 2013 09:58:03 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs fi show
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am on Fedora 20-Beta and we just updated to btrfs-progs 
0.20.rc1-20131114git9f0c53f

Previously, when you did a btrfs fi show, you got a list with one output 
for each btrfs storage volume whether it was a single device or 
multi-device volume.

Now, I get multiple outputs for each storage volume.  For example, I 
have a system with two SSDs as one btrfs storage volume and two USB 
round-and-brown disks as a second btrfs storage volume.  Each has three 
subvols defined and mounted.

Previously, I got two outputs; one for each volume.

Now I get three outputs for the SSD storage volume and SIX outputs for 
the out volume.

Is this a bug or a feature?  If it is a feature, what is it telling me?

Gene
