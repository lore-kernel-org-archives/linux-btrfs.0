From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: default subvolume abilities/restrictions
Date: Wed, 19 May 2010 19:58:04 +0200
Message-ID: <201005191958.04868.kreijack@libero.it>
References: <29213501.290601274270192630.JavaMail.defaultUser@defaultHost> <AANLkTinCbFQkWvehlmnmGrPdduWfWUjutgYADZAkSlCe@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinCbFQkWvehlmnmGrPdduWfWUjutgYADZAkSlCe@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, May 19, 2010, C Anthony Risinger wrote:
> On Wed, May 19, 2010 at 6:56 AM, kreijack@libero.it <kreijack@libero.it> 
wrote:
> > Hi Anthony,
> >
> > I think that for you may be interested to read this thread
> >
> > http://kerneltrap.org/mailarchive/linux-btrfs/2009/11/20/6588643/thread
> >
> > and to read a my blog about this argument
> >
> > http://kreijack.blogspot.com/2010/01/linux-btrfs-example-of-layout.html
> >
> > Regards
> > Goffredo
> 
> thanks for the pointers, however the thread doesn't really offer a
> solution or an indication of whether this will/can be possible :-(,
> and your blog basically comes to the same conclusion that i already
> agree with; the system should be installed into a subvolume from day
> 1.  i could be mistaken here, but in my experience, you cannot remove
> a subvolume that has another subvolume within it.  thus, setting a new
> default subvolume doesn't actually change the heirarchy of subvolumes,
> and since the original default subvol (.) contains all other
> subvolumes, it still cannot be removed, as it's the ultimate parent
> subvolume (even though it's not necessarily the default anymore).  is
> this correct?

On the basis of my experiences I agree with you. I think that it was not a 
good design to link the subvolumes to directory entries. I prefer that the 
subvolumes live in a different namespace, and it were mounted when required.

> i need a way, programmatically and safely, to "move" the users
> installation from the original subvolume into an isolated subvolume
> called __active (what you called "rootfs" in you thread/blog), or to
> generate a new, empty default/root subvolume and place the current
> default subvol (.) _into_ it...  how can this be done?  until i figure
> this out i have to tell the user to manually remove the stagnant files
> from the dot (.) subvolume (usr/etc/lib...), since i don't think my
> users would appreciate me issuing an "rm -rf" against their system.
> 
> any other ideas/input?

I am not sure to have understood well. But a possible solution may be to 
- snapshot the default subvolume to a rootfs.
- boot in the rootfs subvolume
- mount the default subvol (mount -o subvol=default /dev/sdX /mnt/default)
- remove (carefully) the file under the default subvolume except the  
subvolume(s) (something like rm --one-file-system /mnt/default/).


> 
> C Anthony
> 
> ps. a recursive snapshotting tool could be useful too (if / and /home
> were both subvols, the tool would create both when / was snapped,
> instead of /home being an empty folder in the snapshot).




> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
