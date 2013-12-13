Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:48312 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3LMQIx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 11:08:53 -0500
Received: by mail-yh0-f41.google.com with SMTP id f11so1656131yha.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 08:08:53 -0800 (PST)
Received: from [192.168.18.6] (cpe-174-106-200-117.ec.res.rr.com. [174.106.200.117])
        by mx.google.com with ESMTPSA id x9sm3671139yhd.13.2013.12.13.08.08.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 13 Dec 2013 08:08:51 -0800 (PST)
Message-ID: <52AB30D4.7050408@czarc.net>
Date: Fri, 13 Dec 2013 11:07:48 -0500
From: Gene Czarcinski <gczarcinski@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: moving a subvol
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have hunted high and low for the information but, if it is out there, 
it is well hidden.

What I want to do:  I want to relocate (move) a subvolume from one BTRFS 
volume to a different BTRFS volume.

I have seen the writeup for incremental backup which takes a snapshot, 
and then using btrfs-send and btrfs-receive to create a copy on a 
different volume.  That works fine except the btrfs-receive set the new 
copy to be readonly.

What I want to do is to use that new subvolume read/write.  The only way 
I have figured out to do this is to create another snapshot on the new 
volume which is NOT readonly.  I believe that means I need to keep both 
of these subvolumes around.

Gene
