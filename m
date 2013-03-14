Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46275 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3CNEYm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 00:24:42 -0400
Received: by mail-ie0-f170.google.com with SMTP id c11so2545535ieb.29
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 21:24:42 -0700 (PDT)
MIME-Version: 1.0
From: Queen Adam <adam900710@gmail.com>
Date: Thu, 14 Mar 2013 12:24:21 +0800
Message-ID: <CAFy8SQVzHYXmCkwgJ2tmE4QoZDGF4z1efN4z4CkVACQi2LEY_Q@mail.gmail.com>
Subject: Any method to 'umount' a subvolume?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

When using "btrfs sub create test" commands to create a subvolume, it
will create test directory in the current directory.

But the subvol directory can only be delete by "btrfs sub delete"
command, which seems also delete all the data in the subvolume.

Any method about the 'umount'-like method to 'umount' the subvolume
and delete the subvolume directory without deleting all the data?
The method now seems less flexible (can mount -o subvol=test to other
path but the test/ can't be deleted)

Thanks.
