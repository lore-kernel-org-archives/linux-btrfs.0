From: C Anthony Risinger <anthony@extof.me>
Subject: Re: default subvolume abilities/restrictions
Date: Sat, 12 Jun 2010 00:24:26 -0500
Message-ID: <AANLkTikHScVP2MylD7EXVC-d-v0RloxVpv8P5SEgrXd6@mail.gmail.com>
References: <29213501.290601274270192630.JavaMail.defaultUser@defaultHost>
	<AANLkTinCbFQkWvehlmnmGrPdduWfWUjutgYADZAkSlCe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinCbFQkWvehlmnmGrPdduWfWUjutgYADZAkSlCe@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 19, 2010 at 9:01 AM, C Anthony Risinger <anthony@extof.me> =
wrote:
> ..........
> i need a way, programmatically and safely, to "move" the users
> installation from the original subvolume into an isolated subvolume
> ..........
> or to generate a new, empty default/root subvolume and place the curr=
ent
> default subvol (.) _into_ it... =A0how can this be done?

can any devs out there make this happen?  note, what i'm looking for
is _not_ setting the default subvolume to be mounted, but actually
moving/renaming the default (.) subvolume itself.  essentially, can we
get a command to do this:

# btrfs subvolume create new_root
# mv . new_root/old_root

that unsurprisingly fails with:

mv: cannot move `.' to `new_root/old_root': Device or resource busy

could we extend btrfs-progs tools to allow something like this?  does
the on disk format support _moving_ the default subvol?  this
operation is critical to "upgrade" a user who has installed their
system into the default subvol, as most naturally would.  clean
rollback systems/structures depend on the user having his system
installed to an isolated subvol, NOT the default.

what sayith you?

thanks,
C Anthony

additionally, is anything like the following on a TODO list anywhere?
thanks again.

> ps. a recursive snapshotting tool could be useful too (if / and /home
> were both subvols, the tool would create both when / was snapped,
> instead of /home being an empty folder in the snapshot [BUG?]).
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
