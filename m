From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: Re: cow versus data erasure
Date: Sun, 15 May 2011 12:00:08 +0200
Message-ID: <1305453608.5117.6.camel@tethys>
References: <72d360c3a60a791182b5901cca382570@email.freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: radames42@freenet.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <72d360c3a60a791182b5901cca382570@email.freenet.de>
List-ID: <linux-btrfs.vger.kernel.org>

Le dimanche 15 mai 2011 =C3=A0 11:43 +0200, radames42@freenet.de a =C3=A9=
crit :

> since btrfs uses cow I wonder how I can erase confidential data.
> Replacing the file does not work, since the new content is written to=
 new
> blocks while the old confidential content remains in its old block (w=
hich
> may be unused now - depending on snapshots).

Yep. COW filesystems typically do not allow secure deletion, there's no
way to work around this AFAIK.

> Alternatives are:
> - using encfs to save confidential data
> - using luks to encrypt the whole disk/partition
> other suggestions?

I'm currently writing this message from a machine using a BTRFS inside
an LVM built upon LUKS. That works fine.

I also use some ecryptfs on other machines, that comes standard with
Ubuntu and is allright.

It may be worth noting that encryption is not equivalent to secure
deletion : If it's secure-deleted, it's truly gone. If it's "unsecurely=
"
deleted from an encrypted container, somebody getting the decryption
key, possibly by force, might be able to recover the data.

OTOH, even though COW filesystems don't allow secure deletion, they're
typically known to generally not have any reliable "undelete" tools, an=
d
COW filesystems have a greater chance to overwrite relased blocks soone=
r
than non-COW FSes would do, so the average lifespan of "parts of erased
files data on disk" is probably typically much shorter with a COW FS
than with a non-COW one.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
