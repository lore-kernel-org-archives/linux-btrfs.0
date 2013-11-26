Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49284 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3KZIr1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 03:47:27 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so5070482wgg.16
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 00:47:26 -0800 (PST)
Received: from [192.168.0.29] (ppp-2-85-89-247.home.otenet.gr. [2.85.89.247])
        by mx.google.com with ESMTPSA id w20sm58050021wia.5.2013.11.26.00.47.25
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 26 Nov 2013 00:47:25 -0800 (PST)
Message-ID: <5294600F.8050601@gmail.com>
Date: Tue, 26 Nov 2013 10:47:11 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Btrfs-tools build instructions for Centos
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
in https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories, i 
used the fedora instructions for Centos.
The problem is that lzo2-devel is named lzo-devel in Centos, so if 
somebody follows the fedora instructions and doesn't notice that 
lzo2-devel is missing, btrfs-progs build will fail with "/usr/bin/ld: 
cannot find -llzo2". The solution is to install lzo-devel instead. Can 
this be added to the wiki?

