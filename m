From: Erik Jensen <erikjensen@laurelwoodart.com>
Subject: Re: Mis-Design of Btrfs?
Date: Thu, 14 Jul 2011 13:47:37 -0700
Message-ID: <CAGh96GEi+RY2sEGM1S0oCwcrRPP8CWo-F8hL1-GdACbCjSd14A@mail.gmail.com>
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown>
 <4E0AF091.9030301@redhat.com> <1309344469.22470.129.camel@cheyenne>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309344469.22470.129.camel@cheyenne>
List-ID: <linux-btrfs.vger.kernel.org>

 On Wed, Jun 29, 2011 at 3:47 AM, A. James Lewis <james@fsck.co.uk> wro=
te:
> Is there a possibility that one could have a 3 disk RAID5 array, and
> then add a 4th disk and then do a balance, growing the RAID5 onto 4
> disks and gaining the space still with RAID5?  It seems that to be
> consistent, BTRFS would have to do this.
>
> If this is the case, then I think that the BTRFS implementation of RA=
ID5
> would have to be quite different to the MD implementation.
>
> James.

 My understanding, gleaned from IRC several months ago, is that Btrfs
 would use the new drive, but not change the stripe size. Each
 allocation would then be written across some selection of three of the
 four drives.

 In other words, if you started with four stripes across three drives:
   AAA
   BBB
   CCC
   DDD
 and then added a drive and balanced, you might get something like:
   AAAB
   BBCC
   CDDD
 which would give you more space, but still use =E2=85=93 of the space =
for parity.

 Trying to remove a drive from the original three-drive configuration
 would be an error, similarly to trying to remove the second to last
 drive in RAID 1, currently.

 Actually changing the stripe size would be done using the same
 mechanism as changing RAID levels.

 Again, this is just an interested but uninvolved person's
 understanding based on an IRC conversation, so please salt to taste.

 -- Erik
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
