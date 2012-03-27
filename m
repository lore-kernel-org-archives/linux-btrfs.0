From: "Matthias G. Eckermann" <mge@suse.com>
Subject: Re: Create subvolume from a directory?
Date: Wed, 28 Mar 2012 00:24:22 +0200
Message-ID: <20120327222422.GA32675@suse.com>
References: <loom.20120327T190041-268@post.gmane.org>
Reply-To: "Matthias G. Eckermann" <mge@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: Alex <alex@bpmit.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120327T190041-268@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Alex and all,

On 2012-03-27 T 17:19 +0000 Alex wrote:

> Just a quick question but can't find an obvious answer.
>=20
> Can I create/convert a existing (btrfs) directory into a
> subvolume?
>=20
> It would be very helpful when transferring 'partitions'
> into btrfs.  I found a similar question way back in
> google, but that site is down now generally.

As far as I am aware, this is not possible directly. My
approach to this would be using copy with reflinks:

------------------------------< snip >------------------------------

## migrate /var/lib/lxc/installserver=20
## from directory to btrfs subvolume

# du -ks /var/lib/lxc/installserver
500332  /var/lib/lxc/installserver

# mv /var/lib/lxc/installserver /var/lib/lxc/installserver_tmp

# btrfs subvol create /var/lib/lxc/installserver
Create subvolume '/var/lib/lxc/installserver'

# time cp -a --reflink /var/lib/lxc/installserver_tmp/rootfs /var/lib/l=
xc/installserver

real    0m1.367s
user    0m0.148s
sys     0m1.108s

## Now remove /var/lib/lxc/installserver_tmp (or not)

------------------------------< snap >------------------------------

Just to compare this with a "mv":

------------------------------< snip >------------------------------

## Go back to former state

# btrfs subvol delete /var/lib/lxc/installserver
Delete subvolume '/var/lib/lxc/installserver'

# btrfs subvol create /var/lib/lxc/installserver
Create subvolume '/var/lib/lxc/installserver'

# time mv /var/lib/lxc/installserver_tmp/rootfs /var/lib/lxc/installser=
ver/

real    0m12.917s
user    0m0.208s=20
sys     0m2.508s=20

------------------------------< snap >------------------------------

While the time measurement might be flawed due to the subvol
actions inbetween, caching etc.: I tried several times, and
"cp --reflinks" always is multiple times faster than "mv" in
my environment.

Or did I misunderstand your question?

so long -
	MgE

--=20
Matthias G. Eckermann     Senior Product Manager   SUSE=C2=AE Linux Ent=
erprise
SUSE LINUX Products GmbH  Maxfeldstra=C3=9Fe 5          90409 N=C3=BCrn=
berg Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=C3=B6rffer, HRB 16746 (AG N=C3=
=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
