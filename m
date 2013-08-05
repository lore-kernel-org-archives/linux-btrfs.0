Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab3HEWr5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 18:47:57 -0400
Date: Mon, 5 Aug 2013 15:47:55 -0700
From: Zach Brown <zab@redhat.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: race free update of super flags
Message-ID: <20130805224755.GK12314@lenny.home.zabbo.net>
References: <1375555397-10886-1-git-send-email-fdmanana@gmail.com>
 <20130805221059.GJ12314@lenny.home.zabbo.net>
 <CAL3q7H6yq=Y_iX4w40t5k0-UOmnghphTRc7T56jn-PAeK5HzWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6yq=Y_iX4w40t5k0-UOmnghphTRc7T56jn-PAeK5HzWA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I guess got confused, must have thought both referred to
> root->fs_info->super_copy.

No worries.  I honestly wasn't sure if I was just missing something :)

- z
("you are in a maze of twisty little super blocks, all alike")
