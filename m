From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Various Questions
Date: Fri, 7 Jan 2011 11:37:46 -0600
Message-ID: <AANLkTi=Kmfjz+3=0m_mzUKS2++j1kxu1C34sZ3dxqyH6@mail.gmail.com>
References: <201101070915.20468.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101070915.20468.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 11:15 AM, Carl Cook <CACook@quantum-sci.com> wro=
te:
>
> On Fri 07 January 2011 08:14:17 Hubert Kario wrote:
>> I'd suggest at least
>> mkfs.btrfs -m raid1 -d raid0 /dev/sdc /dev/sdd
>> if you really want raid0
>
> I don't fully understand -m or -d. =A0Why would this make a truer rai=
d0 that with no options?

this will give you RAID0 for your data, but RAID1 for your metadata,
making it less likely that the FS itself gets corrupted, even though
you will lose some data in crash cases, if i understand correctly.

> Is it necessary to use fdisk on new drives in creating a BTRFS multi-=
drive array? =A0Or is this all that's needed:
> # mkfs.btrfs /dev/sdb /dev/sdc
> # btrfs filesystem show

depends on whether you need /boot partitions or other partitions.
what you have works fine though.

> Is this related to 'subvolumes'? =A0The FAQ implies that a subvolume =
is like a directory, but also like a partition. =A0What's the rationale=
 for being able to create a subvolume under a subvolume, as Hubert says=
 so he can "use the shadow_copy module for samba to publish the snapsho=
ts =A0to windows clients." =A0I don't have any windows clients, but wha=
t difference does his structure make?

just his preference to put it there... the snapshot of a snapshot can
go anywhere.  it doesn't have to reside under it's "parent", the
parent was just used as a base, it's not bound to it in any way AFAIK.

> How do you know what options to rsync are on by default? =A0I can't f=
ind this anywhere. =A0For example, it seems to me that --perms -ogE =A0=
--hard-links and --delete-excluded should be on by default, for a true =
sync?

the links and command Freddie Cash posted are a really good base to wor=
k from.

> So for my system where there is a backup server, I guess I run the rs=
ync daemon on the backup server which presents a port, then when the ot=
her systems decide it's time for a backup (cron) they:
> - stop mysql, dump the database somewhere, start mysql;
> - connect to the backup server's rsync port and dump their data to (h=
opefully) some specific place there.
> Right?

you don't have to stop mysql, you just need to "freeze" any new,
incoming writes, and flush (ie. let finish) whatever is happening
right now.  this ensures mysql is _internally_ consistent on the disk.

see comment by Lloyd Standish here:

http://dev.mysql.com/doc/refman/5.1/en/backup-methods.html

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
