Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55119 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbbCQNdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 09:33:31 -0400
Received: from merkaba.localnet (unknown [91.221.105.244])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 4BB7ED2C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 14:33:30 +0100 (CET)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: number of hardlinks for directory in ls -lid always 1?
Date: Tue, 17 Mar 2015 14:33:30 +0100
Message-ID: <9389540.MYekrP2a8Q@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

On BTRFS I see

martin@merkaba:~> ls -lid /usr/local
27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local
martin@merkaba:~> ls -lid /usr/local/.
27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local/.
martin@merkaba:~> ls -lid /usr/local/bin/..
27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local/bin/..

On other filesystems like Ext4 I see the actual number of hardlinks to the 
directory.

Is this intended behaviour of BTRFS or a bug?



With files it works:

martin@merkaba:~> cd Zeit
martin@merkaba:~/Zeit> mkdir links
martin@merkaba:~/Zeit> cd links
martin@merkaba:~/Zeit/links> LANG=C df -hT .
Filesystem             Type   Size  Used Avail Use% Mounted on
/dev/mapper/msata-home btrfs  170G  120G   48G  72% /home
martin@merkaba:~/Zeit/links> echo "hello" > file
martin@merkaba:~/Zeit/links> ls -li
insgesamt 4
12158633 -rw-r--r-- 1 martin martin 6 Mär 17 14:32 file
martin@merkaba:~/Zeit/links> ln file hardlink1
martin@merkaba:~/Zeit/links> ls -li           
insgesamt 8
12158633 -rw-r--r-- 2 martin martin 6 Mär 17 14:32 file
12158633 -rw-r--r-- 2 martin martin 6 Mär 17 14:32 hardlink1

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
