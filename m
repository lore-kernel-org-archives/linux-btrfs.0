Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60537 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2GSN0A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jul 2012 09:26:00 -0400
Received: by qaas11 with SMTP id s11so1655231qaa.19
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2012 06:25:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvZqQRBZraH4jGu+mRXQFk1aqKaCKMJno=ubypd2rYkicA@mail.gmail.com>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
	<1341409174-13619-7-git-send-email-ablock84@googlemail.com>
	<CAHf9xvZqQRBZraH4jGu+mRXQFk1aqKaCKMJno=ubypd2rYkicA@mail.gmail.com>
Date: Thu, 19 Jul 2012 16:25:59 +0300
Message-ID: <CAHf9xvaTESntqF_tpKL8CUJGig5vh+Dsh3rH136MpCGCGd1geg@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] Btrfs-progs: add btrfs send/receive commands
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

+static int process_link(const char *path, const char *lnk, void *user)
+{
+       int ret;
+       struct btrfs_receive *r = user;
+       char *full_path = path_cat(r->full_subvol_path, path);
+
+       if (g_verbose >= 1)
+               fprintf(stderr, "link %s -> %s\n", path, lnk);
+
+       ret = link(lnk, full_path);
+       if (ret < 0) {
+               ret = -errno;
+               fprintf(stderr, "ERROR: link %s -> %s failed. %s\n", path,
+                               lnk, strerror(-ret));
+       }

Actually it has to be:
char *full_link_path = path_cat(r->full_subvol_path, lnk);
...
ret = link(full_path/*oldpath*/, full_link_path/*newpath*/);
...
free(full_link_path);

Thanks,
Alex.
