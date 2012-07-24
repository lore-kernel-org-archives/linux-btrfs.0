Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38082 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab2GXU1W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jul 2012 16:27:22 -0400
Received: by yhmm54 with SMTP id m54so7140065yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2012 13:27:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvaTESntqF_tpKL8CUJGig5vh+Dsh3rH136MpCGCGd1geg@mail.gmail.com>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
	<1341409174-13619-7-git-send-email-ablock84@googlemail.com>
	<CAHf9xvZqQRBZraH4jGu+mRXQFk1aqKaCKMJno=ubypd2rYkicA@mail.gmail.com>
	<CAHf9xvaTESntqF_tpKL8CUJGig5vh+Dsh3rH136MpCGCGd1geg@mail.gmail.com>
Date: Tue, 24 Jul 2012 22:27:22 +0200
Message-ID: <CAB9VWqBco7__Gjby0j-JjOnd1h7Fh5ECq7BW4U1ubE=boQr0eg@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] Btrfs-progs: add btrfs send/receive commands
From: Alexander Block <ablock84@googlemail.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2012 at 3:25 PM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
> +static int process_link(const char *path, const char *lnk, void *user)
> +{
> +       int ret;
> +       struct btrfs_receive *r = user;
> +       char *full_path = path_cat(r->full_subvol_path, path);
> +
> +       if (g_verbose >= 1)
> +               fprintf(stderr, "link %s -> %s\n", path, lnk);
> +
> +       ret = link(lnk, full_path);
> +       if (ret < 0) {
> +               ret = -errno;
> +               fprintf(stderr, "ERROR: link %s -> %s failed. %s\n", path,
> +                               lnk, strerror(-ret));
> +       }
>
> Actually it has to be:
> char *full_link_path = path_cat(r->full_subvol_path, lnk);
> ...
> ret = link(full_path/*oldpath*/, full_link_path/*newpath*/);
> ...
> free(full_link_path);
>
> Thanks,
> Alex.

Actually, the pathes got mixed up in-kernel. You'll find a pushed fix
in the kernel repo. I also pushed a fix to btrfs-progs containing the
full_link_path. Thanks again :)
