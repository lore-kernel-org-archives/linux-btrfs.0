From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Backup Command
Date: Fri, 21 Jan 2011 11:44:24 -0800
Message-ID: <AANLkTikpV70ktA4+m1gpKpArMQRTVRQEMPMB=POV5Pue@mail.gmail.com>
References: <201101211107.25039.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101211107.25039.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 21, 2011 at 11:07 AM,  <CACook@quantum-sci.com> wrote:
>
> Well thanks to some help from you guys I seem to have my backup serve=
r almost fully running and functional with rsync. =C2=A0Amazing functio=
ns, this snapshotting and rsync.
>
> I still don't know why I cannot remove snapshots though. (Debian Test=
ing with 2.6.32-28)
>
> And I don't know how to reach out from the backup server to the HTPC =
and stop MythTV there, so I can export the Mysql database safely, from =
a cron job on the backup server. =C2=A0Suggestions?

Simplified, but workable:

#!/bin/sh

ssh someuser@mythtv.pc "/path/to/some/script stop"

/path/to/your/rsync/script

ssh someuser@mythtv.pc "/path/to/some/script start"

The above script would be your backup wrapper script, that gets called =
by cron.

On the HTPC, "/path/to/some/script" would be a script that takes 2
arguments (stop|start).

The stop argument would stop mythtv using the init script for it.
Then would do whatever you need to do to the database (stop it, dump
it, whatever).

The start argument would do the reverse, starting the database and Myth=
TV.

And, "/path/to/your/rsync/script" would call your actual backups
script that runs rsync.

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
