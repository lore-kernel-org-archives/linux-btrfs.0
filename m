From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Various Questions
Date: Fri, 7 Jan 2011 09:41:19 -0800
Message-ID: <AANLkTinCSW-JpwYPYNNAaxHnvXqAy02fMr=Hd34CGxh3@mail.gmail.com>
References: <201101070915.20468.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101070915.20468.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 9:15 AM, Carl Cook <CACook@quantum-sci.com> wrot=
e:
> How do you know what options to rsync are on by default? =C2=A0I can'=
t find this anywhere. =C2=A0For example, it seems to me that --perms -o=
gE =C2=A0--hard-links and --delete-excluded should be on by default, fo=
r a true sync?

Who cares which ones are on by default?  List the ones you want to use
on the command-line, everytime.  That way, if the defaults change,
your setup won't.

> If using the =C2=A0--numeric-ids switch for rsync, do you just have t=
o manually make sure the IDs and usernames are the same on source and d=
estination machines?

You use the --numeric-ids switch so that it *doesn't* matter if the
IDs/usernames are the same.  It just sends the ID number on the wire.
Sure, if you do an ls on the backup box, the username will appear to
be messed up.  But if you compare the user ID assigned to the file,
and the user ID to the backed up etc/passwd file, they are correct.
Then, if you ever need to restore the HTPC from backups, the
etc/passwd file is transferred over, the user IDs are transferred
over, and when you do an ls on the HTPC, everything matches up
correctly.

> For files that fail to transfer, wouldn't it be wise to use =C2=A0--p=
artial-dir=3DDIR to at least recover part of lost files?

Or, just run rsync again, if the connection is dropped.

> The rsync man page says that rsync uses ssh by default, but is that t=
he case? =C2=A0I think -e may be related to engaging ssh, but don't und=
erstand the explanation.

Does it matter what the default is, if you specify exactly how you
want it to work on the command-line?

> So for my system where there is a backup server, I guess I run the rs=
ync daemon on the backup server which presents a port, then when the ot=
her systems decide it's time for a backup (cron) they:
> - stop mysql, dump the database somewhere, start mysql;
> - connect to the backup server's rsync port and dump their data to (h=
opefully) some specific place there.
> Right?

That's one way (push backups).  It works ok for small numbers of
systems being backed up.  But get above a handful of machines, and it
gets very hard to time everything so that you don't hammer the disks
on the backup server.

Pull backups (backups server does everything) works better, in my
experience.  Then you just script things up once, run 1 script, worry
about 1 schedule, and everything is stored on the backups server.  No
need to run rsync daemons everywhere, just run the rsync client, using
-e ssh, and let it do everything.

If you need it to run a script on the remote machine first, that's
easy enough to do:
  - ssh to remote system, run script to stop DBs, dump DBs, snapshot
=46S, whatever
  - then run rsync
  - ssh to remote system run script to start DBs, delete snapshot, what=
ever

You're starting to over-think things.  Keep it simple, don't worry
about defaults, specify everything you want to do, and do it all from
the backups box.

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
