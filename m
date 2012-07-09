Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48492 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2GIS7N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 14:59:13 -0400
Received: by obbuo13 with SMTP id uo13so20928275obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jul 2012 11:59:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341409174-13619-7-git-send-email-ablock84@googlemail.com>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
	<1341409174-13619-7-git-send-email-ablock84@googlemail.com>
Date: Mon, 9 Jul 2012 21:59:12 +0300
Message-ID: <CAHf9xvZqQRBZraH4jGu+mRXQFk1aqKaCKMJno=ubypd2rYkicA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] Btrfs-progs: add btrfs send/receive commands
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alexander,

I studied all the kernel + user code, and I have a long list of questions.

Meanwhile, I want to report two small bugs:

# BTRFS_SEND_C_MKNOD command: the receive path expects
BTRFS_SEND_A_MODE, but kernel doesn't send it. So currently it errors.
It looks like kernel need to send it, otherwise how do we know which
kind of mknod to create.

# BTRFS_SEND_C_LINK -> process_link()
ret = link(lnk, full_path); ==> I think it should be the other way
around, the old path comes first and then the new path. Otherwise, it
fails.

If you prefer, I can send you patches for those.

I will keep playing with your code & let you know what else I find.

Thanks!
Alex.
