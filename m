Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob10.myregisteredsite.com ([209.17.115.48]:37340 "EHLO
	atl4mhob10.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab3EUO0a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 10:26:30 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob10.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r4LEQSG0016144
	for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 10:26:28 -0400
Message-ID: <519B841B.7050206@chinilu.com>
Date: Tue, 21 May 2013 07:26:35 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Virtual Device Support
References: <518CFE3A.3080900@chinilu.com> <knabiu$akg$1@ger.gmane.org> <5198E688.30402@chinilu.com> <CAHGunUke143r3pj0Piv3AtJrJO1x8Bm+qS5Z+sY1G1EobhMG_w@mail.gmail.com>
In-Reply-To: <CAHGunUke143r3pj0Piv3AtJrJO1x8Bm+qS5Z+sY1G1EobhMG_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In my case, I am backing up a system spanning five drives formatted 
btrfs, on a separate drive containing a separate backup volume and 
multiple complete backups, each from a different point in time.  This 
gives me protection from filesystem corruption, since the backups are on 
a separate volume, also protection from accidental deletion and other 
such issues by having backups spread over time going back as far as 
three months.  It also makes things very simple since I can just mount 
one of these backup subvolumes in place of the original and immediately 
be up and running.  Of course, all btrfs volumes could die at once as a 
result of some obscure problem such as a poison update or something like 
that, and that is why I keep a constantly updated JFS (and period 
backups to bluray) copy on hand.  I realize this is not foolproof, and 
actually plan to extend it further.  But huge drives are terribly 
inexpensive right now and this is one way I can take advantage of that.  
Of course I could have done this using multiple partitions, and I may 
one day regret not doing it that way for the very reasons you point out. 
However, I believe that I am sufficiently protected at this point to 
take the risk.  I really figure that if something were to corrupt both 
my main system AND the backup volume at the same time, it would probably 
knock out separate partitions as well. But ... perhaps not.  But I am 
indeed aware that one filesystem corruption could knock out all of those 
backups in one sweep.  As for the umount issue, it is ridiculously easy 
to script around, it just seems like somebody, either on the util-linux 
side, or on the btrfs side, could provide a more elegant solution, but 
it seems to fly in the face of entrenched ideologies on both sides. 
Fortunately, my only real problem that I can't script around is the boot 
issue and that is hopefully, just a matter of time before it gets 
fixed.  Thanks for your thoughts,  George

On 05/21/2013 01:16 AM, Michael Johnson - MJ wrote:
> I realize I am a bit late to the party on this, and but I would like 
> to understand the details of the workflow you are describing as I am 
> not seeing the benefit to creating backups on different subvolumes 
> with btrfs (but that's not to say there aren't reasons).
>
> The way I've gone about things is to have one btrfs volume mounted at 
> say /mnt/brtfs, backup to it, and then creates a read-only snapshots 
> in /mnt/btrfs/.snapshots.  I think this gives me all the benefits of 
> what you are describing without any of the hassle.
>
> Now, if my btrfs were to become corrupted, I would loose all of my 
> backups, but I believe you would be in the same boat using 
> completely separate subvolumes as they still part of the same 
> underlying data structure.  You would have a similar issue with zfs I 
> believe.
>
> With more tradition filesystems where the volume management is 
> separate from the filesystem, having 2 separate instances of say xfs, 
> on lvm volumes or even different partitions, your filesystem 
> corruption would not spread from volume A to volume B so that level of 
> separation makes sense.  But with btrfs, treating the subvolumes like 
> this does not provide such protection, If this is the reason for your 
> workflow, it may be simply that it used to provide some benefit, but 
> that benefit is gone.  As such I think you can actually simplify your 
> workflow and utilize btrfs more fully.
>
> That being said, I don't really know your workflow and the reasons for 
> it, so it is quite possibly a reasonable thing to keep doing.  I 
> simply don't have enough information and know that I have often time 
> found my self annoyed with a change, spent a lot of time to working 
> around the change, and then later realized, but I just was stuck in an 
> old way of thinking and that the new way allowed a more elegant workflow.
>
> But that is all just food for thought.  I do agree that if I can say 
> "mount LABEL=foo" it would be expected that I could also say "umount 
> LABEL=foo".  Perhaps the right thing to do would be to have modify the 
> btrfs command to allow 'btrfs mount' and 'btrfs umount' similar to the 
> way zfs works as this would allow some fun magic to happen outside of 
> util-linux.
>
> In any case, I hope my thoughts are at least a little useful.  Cheers!
>
>
> On Sun, May 19, 2013 at 7:49 AM, George Mitchell <george@chinilu.com 
> <mailto:george@chinilu.com>> wrote:
>
>     In reply to both of these comments in one message, let me give you
>     an example.
>
>     I use shell scripts to mount and unmount btrfs volumes for backup
>     purposes.  Most of these volumes are not listed in fstab simply
>     because I do not want to have to clutter my fstab with volumes
>     that are used only for backup.  So the only way I can mount them
>     is either by LABEL or by UUID.  But I can't unmount them by either
>     LABEL or UUID because that is not supported by util-linux and they
>     have no intention of supporting it in the future.  So I have to
>     resort to unmounting by directory and it becomes back and forth
>     between LABEL and directory which becomes very confusing when you
>     are dealing with complex shell scripts.  This is intolerable for
>     me so I use a kludge that allows me to first translate from LABEL
>     to device and then unmount by device.  To me it just seems klutzy
>     that one has to resort to these sorts of games to use a file
>     system that is supposed to be an improvement on what we already
>     have.  A simple virtual volume identifier would resolve that.
>     Doing the same for subvolumes would be nice, but I could live
>     without it with no problem.  I have worked with nixes for 30 years
>     beginning with AT&T pre-SRV on DEC-1170s and have seen a lot of
>     changes since those days, most of them for the better.  But, while
>     functionality is mandatory, convenience is always appreciated and
>     can help avoid costly mistakes and save time.  As I stated in my
>     original post, I KNOW and appreciate that all of you are working
>     hard on things that matter far more than this trivial item.  But
>     it is a major convenience and clarity issue for me and I am sure
>     it will be for others as well.  It is only rational that one
>     should be able to expect to mount by LABEL and unmount by LABEL,
>     but that doesn't work, and a major part of the reason that doesn't
>     work is that btrfs does not conform to the pattern of just about
>     every other file system on the planet in regards to how it treats
>     mount points.  And this is not even to mention all the other
>     issues involved like a large number of utilities that have no way
>     of knowing that a given partition is mounted, which would also be
>     resolved by virtual mount points since many if not most of those
>     utilities understand and process virtual volume identifiers.
>
>     Please just do me a favor and think about this a bit before you
>     just write it off.
>
>     - George
>
>
>
>
>     On 05/19/2013 04:04 AM, Martin wrote:
>
>         On 10/05/13 15:03, George Mitchell wrote:
>
>             One the things that is frustrating me the most at this
>             point from a user
>             perspective ...  The current method of simply using a
>             random member device or a LABEL or a UUID is just not
>             working well for
>             me.  Having a well thought out virtual device
>             infrastructure would...
>
>         Sorry, I'm a bit lost for your comments...
>
>         What is your use case and what are you hoping/expecting to see?
>
>
>         I've been following development of btrfs for a while and I'm
>         looking
>         forward to use it to efficiently replace some of the very useful
>         features of LVM2, drbd, and md-raid that I'm using at present...
>
>         OK, so the way of managing all that is going to be a little
>         different.
>
>         How would you want that?
>
>
>         Regards,
>         Martin
>
>         --
>         To unsubscribe from this list: send the line "unsubscribe
>         linux-btrfs" in
>         the body of a message to majordomo@vger.kernel.org
>         <mailto:majordomo@vger.kernel.org>
>         More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>
>
>     On 05/19/2013 04:15 AM, Roman Mamedov wrote:
>
>         On Fri, 10 May 2013 07:03:38 -0700
>         George Mitchell <george@chinilu.com
>         <mailto:george@chinilu.com>> wrote:
>
>             One the things that is frustrating me the most at this
>             point from a user
>             perspective regarding btrfs is the current lack of virtual
>             devices to
>             describe volumes and subvolumes.
>
>          From a user perspective btrfs subvolumes have a lot in common
>         with just
>
>         regular directories aka folders, and nothing in common with
>         (block)devices.
>         "Describing them with virtual devices" does not seem to make a
>         whole lot of
>         sense.
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-btrfs" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>
>
>
> -- 
> Michael Johnson - MJ

