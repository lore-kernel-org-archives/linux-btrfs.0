From: C Anthony Risinger <anthony@extof.me>
Subject: Re: default subvolume abilities/restrictions
Date: Sat, 12 Jun 2010 18:06:23 -0500
Message-ID: <AANLkTim0VvWP0CLIWCqHMUZX1dAHPOBWWcRoZYSRUgyn@mail.gmail.com>
References: <29213501.290601274270192630.JavaMail.defaultUser@defaultHost>
	<AANLkTinCbFQkWvehlmnmGrPdduWfWUjutgYADZAkSlCe@mail.gmail.com>
	<AANLkTikHScVP2MylD7EXVC-d-v0RloxVpv8P5SEgrXd6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikHScVP2MylD7EXVC-d-v0RloxVpv8P5SEgrXd6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 12, 2010 at 12:24 AM, C Anthony Risinger <anthony@extof.me>=
 wrote:
> On Wed, May 19, 2010 at 9:01 AM, C Anthony Risinger <anthony@extof.me=
> wrote:
>> ..........
>> i need a way, programmatically and safely, to "move" the users
>> installation from the original subvolume into an isolated subvolume
>> ..........
>> or to generate a new, empty default/root subvolume and place the cur=
rent
>> default subvol (.) _into_ it... =A0how can this be done?
>
> can any devs out there make this happen? =A0note, what i'm looking fo=
r
> is _not_ setting the default subvolume to be mounted, but actually
> moving/renaming the default (.) subvolume itself. =A0essentially, can=
 we
> get a command to do this:
>
> # btrfs subvolume create new_root
> # mv . new_root/old_root
>
> that unsurprisingly fails with:
>
> mv: cannot move `.' to `new_root/old_root': Device or resource busy
>
> could we extend btrfs-progs tools to allow something like this? =A0do=
es
> the on disk format support _moving_ the default subvol? =A0this
> operation is critical to "upgrade" a user who has installed their
> system into the default subvol, as most naturally would. =A0clean
> rollback systems/structures depend on the user having his system
> installed to an isolated subvol, NOT the default.
>
> what sayith you?

i might even try to implement this myself...

can i at least get confirmation that the above is possible?

all i want to do is create a new/empty subvol, put the old top-level
subvol inside it, and make the empty subvol the new root.  this lets
me put a users installation INTO a subvol even though they originally
installed the system into the root subvol.

guidance please?  chris? :-)

thanks,
C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
