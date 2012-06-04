Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46001 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab2FDPKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 11:10:36 -0400
Received: by lbbgm6 with SMTP id gm6so3146496lbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 08:10:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB9VWqAoc=+9B5FLtVbDY8xWeRt+O8oJ79BQKtdhOMjMAYu2eA@mail.gmail.com>
References: <CAHf9xvYX+3sjJL3anEQD0TJLbBiSsF4Pu1aBwVjeTofNmxFMpw@mail.gmail.com>
	<CAB9VWqAoc=+9B5FLtVbDY8xWeRt+O8oJ79BQKtdhOMjMAYu2eA@mail.gmail.com>
Date: Mon, 4 Jun 2012 20:40:34 +0530
Message-ID: <CAGEjNMf5hU4wteJepU5h4r=HXs_Anf_RGawHpphq=ft76Raw=Q@mail.gmail.com>
Subject: Re: inquiry on btrfs send/receive
From: shyam btrfs <shyam.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex, Jan,

I was also interested in send/receive semantics & was thinking that if
we adhere to the semantics as in
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg07482.html
of:

it is impossible to track the "deleted" items (files,dirs, eXtended
attributes). I can develop a command which compare two subvolumes an
extract all of this kind of information. But this command would return
correct information *only if*
  A) a subvolume is a snapshot of the other one
  B.1) the reference snapshot is not touched OR
  B.2) I have the lastgen "when" the snapshot is taken

then transid/generation number could be made to work to determine the
differences between two subvolumes including the deletes that were
involved. I agree that file-clone is tricky as you pointed, but we
dont use it in our environment.

Do you still see issues with it that I am missing?

Also out of curiosity, would you mind sharing how you avoided looking
at transid? Would it be that all meta changes are logged in
tree-modification-log or equivalent?

Thanks.

PS: Alex/Jan, sorry for the multiple mails. including the linux-btrfs
list refused HTML msgs.
--Shyam

On Mon, Jun 4, 2012 at 6:52 PM, Alexander Block <ablock84@googlemail.com> wrote:
>
> On Mon, Jun 4, 2012 at 2:39 PM, Alex Lyakas
> <alex.bolshoy.btrfs@gmail.com> wrote:
> > Hi Jan, Alex,
> >
> > I have seen some discussions about btrfs send/receive functionality
> > being developed by you. I have also been interested in this. I spent
> > some time coding a prototype doing something like Alex described in
> > http://www.spinics.net/lists/linux-btrfs/msg16175.html, i.e., walking
> > over FS tree and pulling those items that have transid/generation
> > larger than a particular value. I realized though, that there are many
> > issues with that approach, and also probably there are many issues I
> > am not aware of. Some of the issues I realized:
> Well, you are, like me in the beginning, on a wrong track ;) Using the
> transid only is not the way send/receive will be implemented when it's
> done.
> >
> > # How does one track changes in generic INODE_ITEM properties, like
> > "mode" or "uid/gid"? Whenever such property gets changed, INODE_ITEM
> > gets stamped with a new transid, but do we need to compare it with the
> > previous version on the receive side to realize what has changed?
> > # File size - is it required, again, to compare vs previous size, to
> > realize file truncation? (file grow perhaps can be realized via new
> > EXTENT_DATAs)
> > # What should be done if INODE_ITEM::flags change (e.g., inode gets
> > nodatacow/nodatasum flags set). What should be done at receive side?
> > # How does one track deletion of INODE_ITEMs? Or, deletion and
> > re-creation of a INODE_ITEM with the same inode number? (I saw that
> > inode_cache mount option allows to re-use inode numbers, so I think it
> > can happen.) Does this mean that on receive side, it is required to
> > compare contents of each directory vs previous version?
> > # What should be done with INODE_ITEMs like block/char device, FIFO or a socket?
> > # XATTR_ITEMs: although they have a transid stamp, again, need to
> > track deletion/re-creation of them. Again by comparing?
> > # INODE_REFs: these seem most tough to me, because they don't have
> > transid stamps. How such scenario can be handled: an INODE_ITEM had
> > two INODE_REFs with names N1 and N2. But now on the send side, both
> > those INODE_REFs were deleted and INODE_REFs N3 and N4 were created.
> > Does that mean we need to always compare all INODE_REFs for each
> > INODE_ITEM, or we perhaps can use DIR_ITEMs/DIR_INDEXs of parent
> > INODE_ITEM to detect changes in INODE_REFs?
> >
> > All in all, it looks like the approach of navigating the FS tree and
> > trying to *understand* specifically which modifications were
> > performed, is quite error-prone. And I am sure there are modifications
> > I am not aware about.
> The problem with the transid only approach is, that there is no way
> to find out "what" has changed in an inode. You only know which inode
> has changed. You could probably determine which extents have
> changed, but this is unreliable as you've already read in my older mail.
> There is also absolutely no way to detect deleted/moved files/dirs.
> When send/receive is released and working, I may try to implement
> a mode that only relies on the transid, but this has low priority for me
> and also needs some changes to other parts of btrfs. If I implement
> that, it would however still be unable to detect what has changed and
> would also miss deleted/moved dirs. You could compare it to rsync
> without the --delete option (which I use frequently to transfer VM
> images).
> >
> > I was wondering, what state your work is in? Is it possible to look at
> > some code or prototype, to understand what approach have you taken, or
> > perhaps an overall description of the approach?
> Currently, most things work as expected. But, the code is not in a state
> to be released. Jan, Arne, David and Stefan are currently reviewing my
> code and I have a lot of TODO's due to the suggestions they all made.
> >
> > Jan, I saw that you provided some new code for backref resolving. Can
> > you give a hint of how is that related to the send/receive
> > functionality?
> It is not only related to the send/receive code. It is currently mainly related
> to the upcoming qgroups patches that Jan is preparing. It may also be
> related to other parts of btrfs (as far as I know, scrub is also using the
> backref resolving code). His patches are however a requirement for
> send/receive to work properly when I release my first patches).
> >
> > Thanks,
> > Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
