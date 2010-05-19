From: C Anthony Risinger <anthony@extof.me>
Subject: Re: default subvolume abilities/restrictions
Date: Wed, 19 May 2010 09:01:47 -0500
Message-ID: <AANLkTinCbFQkWvehlmnmGrPdduWfWUjutgYADZAkSlCe@mail.gmail.com>
References: <29213501.290601274270192630.JavaMail.defaultUser@defaultHost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "kreijack@libero.it" <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <29213501.290601274270192630.JavaMail.defaultUser@defaultHost>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 19, 2010 at 6:56 AM, kreijack@libero.it <kreijack@libero.it> wrote:
> Hi Anthony,
>
> I think that for you may be interested to read this thread
>
> http://kerneltrap.org/mailarchive/linux-btrfs/2009/11/20/6588643/thread
>
> and to read a my blog about this argument
>
> http://kreijack.blogspot.com/2010/01/linux-btrfs-example-of-layout.html
>
> Regards
> Goffredo

thanks for the pointers, however the thread doesn't really offer a
solution or an indication of whether this will/can be possible :-(,
and your blog basically comes to the same conclusion that i already
agree with; the system should be installed into a subvolume from day
1.  i could be mistaken here, but in my experience, you cannot remove
a subvolume that has another subvolume within it.  thus, setting a new
default subvolume doesn't actually change the heirarchy of subvolumes,
and since the original default subvol (.) contains all other
subvolumes, it still cannot be removed, as it's the ultimate parent
subvolume (even though it's not necessarily the default anymore).  is
this correct?

i need a way, programmatically and safely, to "move" the users
installation from the original subvolume into an isolated subvolume
called __active (what you called "rootfs" in you thread/blog), or to
generate a new, empty default/root subvolume and place the current
default subvol (.) _into_ it...  how can this be done?  until i figure
this out i have to tell the user to manually remove the stagnant files
from the dot (.) subvolume (usr/etc/lib...), since i don't think my
users would appreciate me issuing an "rm -rf" against their system.

any other ideas/input?

C Anthony

ps. a recursive snapshotting tool could be useful too (if / and /home
were both subvols, the tool would create both when / was snapped,
instead of /home being an empty folder in the snapshot).
