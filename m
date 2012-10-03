Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail48.e.nsc.no ([193.213.115.48]:40688 "EHLO mail48.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964823Ab2JCRKV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 13:10:21 -0400
Received: from [10.0.0.22] (ti0036a380-dhcp1045.bb.online.no [85.164.250.26])
	by mail48.nsc.no (8.14.4/8.14.4) with ESMTP id q93GZ1qK003121
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Oct 2012 18:35:02 +0200 (MEST)
Message-ID: <506C6934.5010904@middelthun.no>
Date: Wed, 03 Oct 2012 18:35:00 +0200
From: =?ISO-8859-1?Q?=D8ystein_S=E6ttem_Middelthun?=
	<oystein@middelthun.no>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: tree root
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I have a broken btrfs unable to mount because it is unable to find the 
tree root. Using find-root I find the following:

Well block 14102764707840 seems great, but generation doesn't match, 
have=109268, want=109269

Because the filesystem was last in use with a pre 3.2-kernel I am unable 
to use mount -o recovery, but restore seems to work when I specify the 
previous tree-root. My problem is however that the btrfs is so large I 
have nowhere to temporarily put all the files. I am currently running 
kernel 3.5. Does mount have an option to manually tell it to use the 
tree root at block 14102764707840?


-- 
Best regards
Øystein Middelthun
