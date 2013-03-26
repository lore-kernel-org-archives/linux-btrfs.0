Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34077 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759782Ab3CZOKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 10:10:51 -0400
Received: by mail-ie0-f180.google.com with SMTP id a11so8533851iee.25
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 07:10:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130326130111.GI1955@localhost.localdomain>
References: <1420920.Yent3fKO0t@linux-suse> <20130326130111.GI1955@localhost.localdomain>
From: =?UTF-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
Date: Tue, 26 Mar 2013 14:10:30 +0000
Message-ID: <CAAr69zYBpeJw-faQjdEXTgrsp3p0AN7i8CU+FJnyEjTb8n1GKg@mail.gmail.com>
Subject: Re: Kernel BUG on corrupted space cache under 3.7 and 3.8
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I fixed my file system here, so I can't provide more details now.

Anyway, I cloned your repository and successfully compiled the tree
(except for the mkfs program). But when I try to issue the command
"./btrfs-image -c9 /dev/sda7 /home/linux/image.img" I get the
following:

Could not open /dev/sda7
Open ctree failed

I tried when it was unmounted and also when was mounted.

An other thing happened in the meantime, but I write it to an other
thread, because that's an other bug :).

Ákos
