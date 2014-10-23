Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:48999 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751233AbaJWXEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 19:04:40 -0400
Received: from [10.0.0.169] ([10.0.0.169])
	(authenticated bits=0)
	by mail.nuclearwinter.com (8.14.4/8.14.4) with ESMTP id s9NN4cIA016330
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 18:04:39 -0500
Message-ID: <5449898B.4090708@nuclearwinter.com>
Date: Thu, 23 Oct 2014 18:04:43 -0500
From: Larkin Lowrey <llowrey@nuclearwinter.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Heavy nocow'd VM image fragmentation
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a 240GB VirtualBox vdi image that is showing heavy fragmentation
(filefrag). The file was created in a dir that was chattr +C'd, the file
was created via fallocate and the contents of the orignal image were
copied into the file via dd. I verified that the image was +C.

After initial creation there were about 2800 fragments, according to
filefrag. That doesn't surprise me because this image took up about 60%
of the free space. After an hour of light use the filefrag count was the
same. But, after a day of heavy use, the count is now well over 600,000.

There were no snapshots during the period of use. The fs does not have
compression enabled. These usual suspects don't apply in my case.

The process I used to copy the image to a noCOW image was:

fallocate -n -l $(stat --format %s old.vdi) new.vdi
dd if=old.vdi of=new.vdi conv=notrunc oflags=append bs=1M

Performance does seem much worse in the VM but could it be that the
image isn't actually severely fragmented and I'm just misunderstanding
the output from filefrag?

Is there a problem with how I copied over the old image file?

--Larkin

