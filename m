Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37777 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaA2LmD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 06:42:03 -0500
Received: by mail-wg0-f43.google.com with SMTP id y10so3179394wgg.34
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 03:42:00 -0800 (PST)
Received: from [192.168.7.7] (a207.net131.okay.pl. [85.28.131.207])
        by mx.google.com with ESMTPSA id r1sm30999792wia.5.2014.01.29.03.41.58
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 29 Jan 2014 03:41:59 -0800 (PST)
Message-ID: <52E8E905.8030105@gmail.com>
Date: Wed, 29 Jan 2014 12:41:57 +0100
From: KC <impactoria@googlemail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Deleting subvolumes - there be dragons
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just read this article here: https://lwn.net/Articles/579009/  which 
states:

---------------------------------
btrfs subvolume delete path

  For ordinary subvolumes (as opposed to snapshots, described below), 
the subvolume indicated by path must be empty before it can be deleted.
---------------------------------

So I gave it a try:

$ sudo btrfs subvolume create /home2
$ sudo mkdir /home2/lalala
< copy a random pdf file into /home2/lalala) >
$ sudo btrfs subvolume delete /home2

And boom! It's all gone!
Even though subvolume was not empty.

So apart from the fact that it looks like the article is wrong here, it 
seems very dangerous to me that one simple command can nuke an entire 
volume, even if it's full of files and folders.

Of course I'm new to btrfs so maybe I'm reading something wrong. If so, 
then please do set me straight.
