From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfsck integration with userlevel API for fsck
Date: Fri, 30 Mar 2012 10:22:53 +0700
Message-ID: <CAG1y0sfiZ_A282OxnF0qMS52jYpJyBZ_hQ1x2HrV5bmfnX1XFQ@mail.gmail.com>
References: <CAO_nJAbXsqU+dnZaEME-OjC-4Y8jZ5HhtyGV24BgFebPMhCW=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: member graysky <graysky@archlinux.us>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO_nJAbXsqU+dnZaEME-OjC-4Y8jZ5HhtyGV24BgFebPMhCW=w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2012 at 5:08 AM, member graysky <graysky@archlinux.us> =
wrote:
> Are there plans to integrate btrfsck with the userlevel API for fsck?

There isn't even a stable, working, fixing btrfsck yet :)

> AFAIK, it currently does not work as such (i.e. `shutdown -rF now`
> does not trigger a check on the next boot). =A0What is the recommende=
d
> method to check a btrfs root filesystem? =A0Live media?

Currently? None. Set the last part of root line in fstab to "0" to
disable fsck.
Newer kernels should be smart enough to recover from unclean shutdown
automatically, kinda like what zfs does, or what ext3/4 does with its
journal replay.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
