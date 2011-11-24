From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs and load (sys)
Date: Thu, 24 Nov 2011 08:11:42 +0700
Message-ID: <CAG1y0sfkbhBADfM_dXiTGqTVgwsOnNKR-z=yLFXnzVrUYkEmcg@mail.gmail.com>
References: <CAJ1PRSnhqo3yU4b0sbcYLfByb_pTDuAOL2xo4fryiEoacr8iYg@mail.gmail.com>
	<20111123205616.73b4d0a7@natsu>
	<CAJ1PRSk4cker8WbSL5t9sKYde=f4XRAkQGQVYVC=8wnJKT8EwQ@mail.gmail.com>
	<4ECD971A.2050808@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ECD971A.2050808@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 24, 2011 at 8:00 AM, Chris Samuel <chris@csamuel.org> wrote=
:
> Another possibility I *think* is that you could try 3.1 with
> Chris Mason's for-linus git branch pulled into it. =A0Hopefully
> someone who knows the procedure better than I can correct me
> on this! :-)

My method is:
- use 3.1.1 (latest stable at the time I was compiling it), compiie
btrfs as module
- use only fs/btrfs directory from Chris' for-linus tree, compile the
module externally (make -C /lib/modules/`pwd`/build M=3D$(pwd) modules)
- put the resulting btrfs.ko on /lib/modules/`uname -r`/updates/manual/
- depmod -a
- verify the new module is selected by default (modinfo btrfs)
- rebuild initrd
- reboot

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
