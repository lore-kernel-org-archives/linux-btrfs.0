From: "Matthias G. Eckermann" <mge@suse.com>
Subject: Re: [RFC] btrfs auto snapshot
Date: Wed, 17 Aug 2011 15:31:08 +0200
Message-ID: <20110817133108.GA24578@suse.com>
References: <4E4B2452.9070407@oracle.com>
Reply-To: "Matthias G. Eckermann" <mge@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Chris Mason <chris.mason@oracle.com>
To: Anand Jain <Anand.Jain@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4B2452.9070407@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Anand and all,

On 2011-08-17 T 10:15 +0800 Anand Jain wrote:
=20
>  Appears that no one is working on the auto-snapshot feature for
>  btrfs, so here I am implementing the same.

thanks for bringing this up! The group of features you are listing is
indeed of high interest for people using btrfs.

That said, not only have other people though about this, but a lot of
your question already have been implemented in "snapper", and open
source infrastructure developed as part of openSUSE and SUSE Linux
Enterprise.

Please see:
	http://en.opensuse.org/Portal:Snapper
	http://en.opensuse.org/openSUSE:Snapper_install
	http://lizards.opensuse.org/2011/04/01/introducing-snapper/

Source code is here:
	http://gitorious.org/opensuse/snapper

"snapper" will be part of openSUSE 12.1 and SUSE Linux Enterprise 11
Service Pack 2, and is available as part of the respective Beta
releases and Milestones already.

snapper's concept in short:
- shared library to make the functionality available to
  other tools as well
- libsnapper is implemented on top of the btrfsprogs
- cmdline tool "snapper"
- global configuration file
	/etc/sysconfig/snapper
- one configuration file per subvolume to be snapshotted
	/etc/snapper/configs/<config-name>
  I call this a "single configuration" going forward.
  Here also policies for time based snapshotting and
  cleanup are to be configured.
- Integration into SUSE's management framework (YaST2/zypper),
  however, "snapper" should work independent of those,
  i.e. usable on other distributions easily.

>  Below is a draft on the feature list.  Any comments / questions /
>  suggestions are welcome, please do let me know.

Let me go through the single features quickly and list the matching
snapper functionality.
=20
>  btrfs auto snapshot feature will include:
>  Initially:
>      - configurable timely snapshots

Yes. Configured per single configuration

>      - uses services and crontab to schedule

Yes.

>      - Gnome integration

I more see a need for integration into systems management frameworks.

>      - snapshot rollback and cleanups

Yes. Rules for cleanups (time based, number of snapshots)
per single configuration.

>      - snapshot trashing based on available space

// not yet done.

>      - snapshot destination will be subvol/.btrfs/snapshot@<time> and

snapshot destination is "/.snapshots/<number>/",=20

>        snapshot/.btrfs/snapshot@<time> for subvolume and snapshot
>        respectively

Timestamp and Description of a snapshot are stored in a small XML
file /.snapshots/<number>/info.xml". One small file per snapshot.

[...]

>  Challenges:
>    - rollback per file or dir instead of entire snapshot-rollback ?

snapper implements  "rollback" on a FILE level only.

To differentiate this way of "rolling back" from jumping
into another snapshot, we call it
	"undochange"
for now. This keeps the option to also manage a full
per snapshot-rollback in a later point int time.

[...]
>      modify the snapshot - do we need to implement a kind of read-onl=
y
>      snapshot ?

snapper treats snapshots as read only snapshots, i.e. when doing a
rollback - aehem, I should say "undochange" - only the "master" volume
will be changed, not the single snapshots.  We are aware that this has
pros and cons. But that's another discussion.

I hope that this is a starting point for you.

Enjoy "snapper".

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
