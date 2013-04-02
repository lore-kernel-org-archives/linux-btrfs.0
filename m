Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35730 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab3DBRhg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 13:37:36 -0400
Received: by mail-la0-f54.google.com with SMTP id gw10so642552lab.27
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2013 10:37:34 -0700 (PDT)
MIME-Version: 1.0
From: Harald Glatt <mail@hachre.de>
Date: Tue, 2 Apr 2013 19:37:14 +0200
Message-ID: <CAFWF=ak8pDRocvUgWuTHK+6SCOoCiuNAbhY_FNwwifsT+u6VHw@mail.gmail.com>
Subject: Backup Options
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

what are currently the backup options for btrfs?

Is it possible to somehow duplicate the entire filesystem including
all snapshots without using the real space for each snapshot onto a
remote server? (Maybe given the remote server uses btrfs too?) Are
these features planned?

Right now the only solution I know of is dd if=eachDevice, netcat and
xz or something combined. But that is not exactly a great solution.

The other thing is rsyncing a single snapshot, but if I rsync several
they occupy the full space on the remote machine each which is also
less than optimal...

Any other suggestions?

Thanks!
Harald
