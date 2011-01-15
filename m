From: cwillu <cwillu@cwillu.com>
Subject: Re: Backup Command
Date: Fri, 14 Jan 2011 23:25:01 -0600
Message-ID: <AANLkTimK7jhFz2STdpU1-odTuUoaD0EDtHY0uNoAaL0O@mail.gmail.com>
References: <201101100525.32427.CACook@quantum-sci.com>
	<201101141717.34772.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101141717.34772.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 14, 2011 at 7:17 PM, Carl Cook <CACook@quantum-sci.com> wro=
te:
>
> Apparently my command is no good. =A0No one ever responded to my ques=
tion below, so maybe I'm not smart enough to ask the right way.
>
> I can ssh from the backup server to the HTPC, but it crashes with a '=
dirty' error:
> # rsync --progress --archive --hard-links --links --delete-during --d=
elete-excluded --inplace --numeric-ids -e "ssh -l root" root@hex:///hom=
e /media/backups/hex-home
> root@hex's password:
> protocol version mismatch -- is your shell clean?
> (see the rsync man page for an explanation)
> rsync error: protocol incompatibility (code 2) at compat.c(173) [Rece=
iver=3D3.0.7]
>
> "see the rsync man page for an explanation"? =A0No idea where, but it=
's sure not in the first third. =A0I have the same rsync and ssh on eac=
h.

rsync can speak ssh already, you shouldn't need to provide '-e "ssh -l
root"' unless you're doing something odd.  That said, try:  '-e "ssh
-l root -e none"' to disable ssh's escape character.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
