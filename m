Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59734 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab3JIQER (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Oct 2013 12:04:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VTwF9-0004XR-Fx
	for linux-btrfs@vger.kernel.org; Wed, 09 Oct 2013 18:04:11 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Oct 2013 18:04:11 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Oct 2013 18:04:11 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfsck --repair --init-extent-tree: segfault error 4
Date: Wed, 09 Oct 2013 17:03:59 +0100
Message-ID: <l33up6$8hn$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org> <l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net> <l2a635$37m$1@ger.gmane.org> <l2ietn$jv1$1@ger.gmane.org> <l2k7kd$1dh$1@ger.gmane.org> <l2mnmf$us$1@ger.gmane.org> <l2otcg$mh$1@ger.gmane.org> <l2p3ja$v8r$1@ger.gmane.org> <l2ui33$vjd$1@ger.gmane.org> <D78E3D68-6547-4601-B90D-7B8F867782A6@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <D78E3D68-6547-4601-B90D-7B8F867782A6@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In summary:

Looks like minimal damage remains and yet I'm still suffering
"Input/output error" from btrfs and btrfsck appears to have looped...

A diff check suggests the damage to be in one (heavily linked to) tree
of a few MBytes.

Would a scrub clear out the damaged trees?


Worth debugging?

Thanks,
Martin


Further detail:


On 07/10/13 20:03, Chris Murphy wrote:
> 
> On Oct 7, 2013, at 8:56 AM, Martin <m_btrfs@ml1.co.uk> wrote:
> 
>> 
>> Or try "mount -o recovery,noatime" again?
> 
> Because of this: free space inode generation (0) did not match free
> space cache generation (1607)
> 
> Try mount option clear_cache. You could then use iotop to make sure
> the btrfs-freespace process becomes inactive before unmounting the
> file system; I don't think you need to wait in order to use the file
> system, nor do you need to unmount then remount without the option.
> But if it works, it should only be needed once, not as a persistent
> mount option.

Thanks for that.

So, trying:

mount -v -t btrfs -o recovery,noatime,clear_cache /dev/sdc

gave:

kernel: device label bu_A devid 1 transid 17448 /dev/sdc
kernel: btrfs: enabling inode map caching
kernel: btrfs: enabling auto recovery
kernel: btrfs: force clearing of disk cache
kernel: btrfs: disk space caching is enabled
kernel: btrfs: bdev /dev/sdc errs: wr 0, rd 27, flush 0, corrupt 0, gen 0


btrfs-freespace appeared occasionally briefly in atop but there's no
noticeable disk activity. All very rapidly done?

Running a diff check to see if all ok and what might be missing gave the
syslog output:

kernel: verify_parent_transid: 165 callbacks suppressed
kernel: parent transid verify failed on 915444506624 wanted 16974 found
13021
kernel: parent transid verify failed on 915444506624 wanted 16974 found
13021
kernel: parent transid verify failed on 915444506624 wanted 16974 found
13021
kernel: parent transid verify failed on 915444506624 wanted 16974 found
13021
kernel: parent transid verify failed on 915444506624 wanted 16974 found
13021
kernel: parent transid verify failed on 915444506624 wanted 16974 found
13021


The diff eventually failed with "Input/output error".

'mv' to move this failed directory tree out of the way worked.
Attempting to use 'ln -s' gave the attached syslog output and the
filesystem was made "Read-only".

Remounting:

mount -v -o remount,recovery,noatime,clear_cache,rw /dev/sdc

and the mv looks fine. Trying the 'ln -s' again gives:

ln: creating symbolic link `./portage': Read-only file system

unmounting gave the syslog message:

kernel: btrfs: commit super ret -30


Mounting again:

mount -v -t btrfs -o recovery,noatime,clear_cache /dev/sdc

showed that the symbolic link was put in place ok.

Rerunning the diff check eventually found another "Input/output error".


So unmounted and tried again:

btrfsck --repair --init-extent-tree /dev/sdc

Failed with:

btrfs unable to find ref byte nr 911367733248 parent 0 root 1  owner 2
offset 0
btrfs unable to find ref byte nr 911367737344 parent 0 root 1  owner 1
offset 1
btrfs unable to find ref byte nr 911367741440 parent 0 root 1  owner 0
offset 1
leaf free space ret -297791851, leaf data size 3995, used 297795846
nritems 2
checking extents
btrfsck: extent_io.c:606: free_extent_buffer: Assertion `!(eb->refs <
0)' failed.
enabling repair mode
Checking filesystem on /dev/sdc
UUID: 38a60270-f9c6-4ed4-8421-4bf1253ae0b3
Creating a new extent tree
Failed to find [911367733248, 168, 4096]
Failed to find [911367737344, 168, 4096]
Failed to find [911367741440, 168, 4096]



Rerunning again and this time btrfsck is sat there at 100% CPU for the
last 24 hours. Full output so far is:

parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
Ignoring transid failure


Nothing syslog and no disk activity.

Looped?...




>> Or is it dead?
>> 
>> (The 1.5TB of backup data is replicated elsewhere but it would be
>> good to rescue this version rather than completely redo from
>> scratch. Especially so for the sake of just a few MBytes of one
>> corrupt directory tree.)
> 
> Right. If you snapshot the subvolume containing the corrupt portion
> of the file system, the snapshot probably inherits that corruption.
> But if you write to only one of them, if those writes make the
> problem worse, should be isolated only to the one you write to. I
> might avoid writing to it, honestly. To save time, get increasingly
> aggressive to get data out of this directory and once you succeed,
> blow away the file system and start from scratch.
> 
> You could also then try kernel 3.12 rc4, as there are some btrfs bug
> fixes I'm seeing in there also, but I don't know if any of them will
> help your case. If you try it, mount normally, then try to get your
> data. If that doesn't work, try the recovery option. Maybe you'll get
> different results.

As suspected, thanks.

Would a scrub clear out the damaged trees?


Anything useful to try? Any debug value in looking at the fail cases?

Is there a btrfsck mode of making good everything that is certain and
dumping any remaining fragments into "lost + found"? (Or is that way
down the developments yet?)


Aside: btrfs looks to be usable enough, especially so with the disk
format now stable, to at least offer the well established features as
'stable'...?

(This is the first fail I've had, and considering the sata failed, is
no surprise... Too severe a test! But can the limited damage be
recovered...?)


Thanks,
Martin

