Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39880 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2JCNBE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 09:01:04 -0400
Received: by obbuo13 with SMTP id uo13so7211426obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 06:01:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345463835-26636-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <5028D57F.5090803@robertbuhren.de>
	<1345463835-26636-1-git-send-email-list.btrfs@jan-o-sch.net>
Date: Wed, 3 Oct 2012 15:01:03 +0200
Message-ID: <CAHf9xvYBKawh-XhVxocNYc6vNXHAXHUQMcs_YhSWSqiScMPWSA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: replace find_mount_root from send code
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Robert Buhren <robert@robertbuhren.de>, linux-btrfs@vger.kernel.org,
        Alexander Block <ablock84@googlemail.com>,
        Arne Jansen <sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,

> +       mnttab = fopen("/etc/mtab", "r");

Isn't it better to use "/proc/mounts" here? Otherwise, if the FS was
mounted using "mount" syscall, then this code will fail to find the
correct mount root.

> +       while ((ent = getmntent(mnttab))) {
> +               len = strlen(ent->mnt_dir);
> +               if (strncmp(ent->mnt_dir, path, len) == 0) {
> +                       /* match found */
> +                       if (longest_matchlen < len) {
> +                               free(longest_match);
> +                               longest_matchlen = len;
> +                               longest_match = strdup(ent->mnt_dir);

Alex.
