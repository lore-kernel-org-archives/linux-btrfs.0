From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: Understanding DF, etc.
Date: Fri, 13 May 2011 12:53:58 +0200
Message-ID: <1305284038.3052.46.camel@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

I have trouble understanding this, which doesn't really correspond to
the wiki FAQ (so my question is hopefully not a FAQ ;-) :

# btrfs fi df /
Data: total=74.01GB, used=72.77GB
System, DUP: total=8.00MB, used=16.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.75GB, used=657.48MB
Metadata: total=8.00MB, used=0.00

Some questions are :

What are the "DUP" lines compared to the "non-DUP" ones ?

If I can understand "Metadata" and "Data", what is "System" supposed to
be ?

Is there anyway to know how much space is consumed by any given
subvolume or snapshots (for snapshots, "du" cannot tell how much they
really consume, of course...)

This is so clear in ZFS for example ;-) ...and such a mystery in
BTRFS...

I also have a question relating to quotas : I understand that
per-subvolume quotas are not (yet ?) implemented, but is it possible to
use the user quotas system with btrfs, i.e. mounting it with the "quota"
option such as ol'ext2/3 did ?

TIA, kind regards.


