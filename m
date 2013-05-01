Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:36808 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab3EAWFt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 18:05:49 -0400
Received: by mail-vc0-f169.google.com with SMTP id gd11so13049vcb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 15:05:49 -0700 (PDT)
Received: from [192.168.0.127] ([177.183.12.139])
        by mx.google.com with ESMTPSA id lb10sm2310049veb.5.2013.05.01.15.05.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 01 May 2013 15:05:48 -0700 (PDT)
Message-ID: <518191C8.5090207@gmail.com>
Date: Wed, 01 May 2013 19:06:00 -0300
From: Cesar Strauss <cestrauss@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Finding the objid of a subvolume on an unmounted filesystem
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I would like to" btrfs restore" a broken btrfs filesystem before I
attempt to recover it. However, I only need to recover a subvolume
inside of it. It seems the -r option should do the job, but I do not
know the objid number of the subvolume I want, only the path. Is there a
way to know the objid of a subvolume given its path, without mounting
the filesystem?

Thanks,

Cesar



