Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34060 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab3HGNqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 09:46:22 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Eric Sandeen <sandeen@redhat.com>
Cc: fdmanana@gmail.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
Date: Wed, 07 Aug 2013 15:46:20 +0200
Message-ID: <2202309.naAAXLWmb9@merkaba>
In-Reply-To: <5201652E.4000505@redhat.com>
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com> <CAL3q7H7e5r8bHrdR=kS2ueu8iM5q5fe6pkwm8W52fY-odMh6bw@mail.gmail.com> <5201652E.4000505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 6. August 2013, 16:05:50 schrieb Eric Sandeen:
> On 8/6/13 3:45 PM, Filipe David Manana wrote:
> > On Tue, Aug 6, 2013 at 9:37 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> >> On 8/6/13 1:27 PM, Filipe David Borba Manana wrote:
> >>> This change allows for most mount options to be persisted in
> >>> the filesystem, and be applied when the filesystem is mounted.
> >>> If the same options are specified at mount time, the persisted
> >>> values for those options are ignored.
> >>> 
> >>> The only options not supported are: subvol, subvolid, subvolrootid,
> >>> device and thread_pool. This limitation is due to how this feature
> >>> is implemented: basically there's an optional value (of type
> >>> struct btrfs_dir_item) in the tree of tree roots used to store the
> >>> list of options in the same format as they are passed to btrfs_mount().
> >>> This means any mount option that takes effect before the tree of tree
> >>> roots is setup is not supported.
> >>> 
> >>> To set these options, the user space tool btrfstune was modified
> >>> to persist the list of options into an unmounted filesystem's
> >>> tree of tree roots.
> >> 
> >> So, it does this thing, ok - but why?
> >> What is seen as the administrative advantage of this new mechanism?
> >> 
> >> Just to play devil's advocate, and to add a bit of history:
> >> 
> >> On any production system, the filesystems will be mounted via fstab,
> >> which has the advantages of being widely known, well understood, and
> >> 100% expected - as well as being transparent, unsurprising, and seamless.
> >> 
> >> For history: ext4 did this too.  And now it's in a situation where it's
> >> got mount options coming at it from both the superblock and from
> >> the commandline (or fstab), and sometimes they conflict; it also tries
> >> to report mount options in /proc/mounts, but has grown hairy code
> >> to decide which ones to print and which ones to not print (if it's
> >> a "default" option, don't print it in /proc/mounts, but what's default,
> >> code-default or fs-default?)  And it's really kind of an ugly mess.
> >> 
> >> Further, mounting 2 filesystems w/ no options in fstab or on the
> >> commandline, and getting different behavior due to hidden (sorry,
> >> persistent) options in the fs itself is surprising, and surprise
> >> is rarely good.
> >> 
> >> So this patch adds 100+ lines of new code, to implement this idea, but:
> >> what is the advantage?  Unless there is a compelling administrative
> >> use case, I'd vote against it.  Lines of code that don't exist don't
> >> have bugs.  ;)
> > 
> > There was a recent good example (imho at least) mentioned by Xavier
> > Gnata some time ago:
> > 
> > http://comments.gmane.org/gmane.comp.file-systems.btrfs/26011
> > 
> > cheers
> 
> Hm, I see.  I forgot about hotplugging in my "most systems mount
> via fstab" assertion.  :)
> 
> I was thinking (and Josef just suggested too) that making a
> dir flag, saying "everything under this dir gets compressed" might make
> more sense for that scenario than adding a whole slew of
> on-disk-persistent-mount-option code.
> 
> Because really, the motivation sounds like it's primarily for significant
> on-disk format changes controlled by mount options.  I understand that
> motivation more than being able to persist something like "noatime."

For a hotplug-able SSD having noatime stored persistently IMHO makes a lot of 
sense as well.

I won´t be surprised that at some time, extern SSDs or extern $successor-of-
SSD will be replacing extern harddisks.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
