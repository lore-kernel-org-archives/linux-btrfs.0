Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56719 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaFVBQ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Jun 2014 21:16:59 -0400
Received: by mail-ie0-f176.google.com with SMTP id rd18so4349447iec.7
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Jun 2014 18:16:58 -0700 (PDT)
Received: from [192.168.1.6] ([216.26.106.6])
        by mx.google.com with ESMTPSA id aw9sm18456561igc.9.2014.06.21.18.16.58
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 21 Jun 2014 18:16:58 -0700 (PDT)
Message-ID: <53A62E89.6040900@gmail.com>
Date: Sat, 21 Jun 2014 20:16:57 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Removing file = quota exceded
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

so ive come accross the issue of being unable to remove a file when a
subvolume quota is reached. This can be resolved by truncating the file
first, or removing the quota temporarily.
However, it should be reasonable that you should alwasy be able to
remove a file, regardless of quota limitations yes?
Upon delving into the code, I found the comment that an unlink may not
always free space. This seems reasonable on a COW filesystem, however,
it should not preclude a removal IMO (please correct me if i missed
something)
Personally I'm looking to try and fix this issue to allow a removal of a
file even when the subvol quota has been reached. I'm hoping one of the
current developers may be able to assist me in where to focus my
efforts, as I am still unable to follow exactly where a remove operation
would check the quota limitations.
Any help is appreciated.

-Kevin Brandstatter
