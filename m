Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:40208 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3C0TSR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 15:18:17 -0400
Received: by mail-ie0-f177.google.com with SMTP id tp5so6403068ieb.36
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 12:18:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130327183325.GK28030@localhost.localdomain>
References: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com>
 <20130327183325.GK28030@localhost.localdomain>
From: =?UTF-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
Date: Wed, 27 Mar 2013 19:17:56 +0000
Message-ID: <CAAr69zaQ22_SLg4sfUkDE=NBNTAUaSr9ZgaL=sTPJ-kvXkFRug@mail.gmail.com>
Subject: Re: Kernel bug on mismatching generation_v2 in inode.c:835
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I ran two different versions of btrfsck on the partition.

The first one was shipped with openSUSE 12.3, kernel 3.7.
This is the original tool with which the partition was checked:
http://paste.opensuse.org/74569620

The second one is from your tree (maybe it's newer):
http://filebin.ca/bfbwJezYwCV/btrfsck-v2.txt

Ákos
